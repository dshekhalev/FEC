//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_eras_enc_dec_tb.sv
// Description   : bch erasure_decoder testbench
//

module bch_eras_enc_dec_tb ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // define BCH code (255, 223, 4/9)
  //
  parameter   int m         = 8;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 223;                    // maximum user payload size
  parameter   int d         = 9;                      // codespace

  // maximum length BCH code (255, 223, 4/9)
  parameter   int n         = gf_n_max;               // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int t          = (d-1)/2;    // number of corrected error
  localparam int t2         = 2*t;        // width of syndromes vector

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam pBM_TYPE = "ribm_1t";
//localparam pBM_TYPE = "ribm_2t";
//localparam pBM_TYPE = "ribm_t_by_t";

  const int NUM             = 128;

  const int MIN_BLOCK_DELAY = (pBM_TYPE == "ibm_2t_by_t") || (pBM_TYPE == "ribm_t_by_t") ? 500  : 0;
  const int MAX_BLOCK_DELAY = (pBM_TYPE == "ibm_2t_by_t") || (pBM_TYPE == "ribm_t_by_t") ? 2000 : 16;

  const int MIN_BIT_DELAY   = 0;
  const int MAX_BIT_DELAY   = 16;

  typedef struct packed {
    bit [n-1 : k] bch_bits;
    bit [k-1 : 0] dat_bits;
  } bch_data_t;

  class data_trans;
    bit             last;

    rand bch_data_t data;

    rand int unsigned bit_dist_num;
    rand int unsigned bit_dist_pos [];

    rand int unsigned bit_err_num;
    int unsigned bit_err_pos [];

    int unsigned bit_eras_num;
    int unsigned bit_eras_pos [];

    rand int unsigned block_delay ;
    rand int unsigned bit_delay   ;

    constraint clear_bch_bits { data.bch_bits == 0; }


    constraint distortion_num  { bit_dist_num dist {0 := 5, [1 : t] :/ 5, [t+1 : t2] :/ 2}; }
    constraint distortion_size { bit_dist_pos.size() == bit_dist_num; }
    constraint distortion_pos  { foreach (bit_dist_pos[i]) bit_dist_pos[i] < n;}

    constraint error_num       { bit_err_num <= bit_dist_num;}

    constraint order0 {solve bit_dist_num before bit_dist_pos;}
    constraint order1 {solve bit_dist_num before bit_err_num;}

    constraint block_delay_size { block_delay <= MAX_BLOCK_DELAY;
                                  block_delay >= MIN_BLOCK_DELAY;}
    constraint bit_delay_size   { bit_delay   <= MAX_BIT_DELAY;
                                  bit_delay   >= MIN_BIT_DELAY;}

    function void post_randomize ();
      bit is_unique;
      int eidx;
      int eraidx;
    begin
      // check array for unicity
      for (int i = 0; i < bit_dist_num; i++) begin
        do begin
          is_unique = 1;
          for (int j = i-1; j >= 0; j--) begin
            is_unique &= (bit_dist_pos[i] != bit_dist_pos[j]);
          end
          if (!is_unique)
            bit_dist_pos[i] = $urandom_range(0, n-1);
        end
        while (!is_unique);
      end
      // split on errors and erasures
      bit_eras_num  = bit_dist_num - bit_err_num;
      bit_err_pos   = new[bit_err_num];
      bit_eras_pos  = new[bit_eras_num];
      //
      eidx    = 0;
      eraidx  = 0;
      //
      for (int i = 0; i < bit_dist_num; i++) begin
        if (i < bit_err_num)
          bit_err_pos[eidx++] = bit_dist_pos[i];
        else
          bit_eras_pos[eraidx++] = bit_dist_pos[i];
      end
      //
      if (bit_dist_num != 0) begin
        bit_err_pos.sort();
        bit_eras_pos.sort();
      end
    end
    endfunction

  endclass

  data_trans enc2err  [$];
  data_trans err2dec  [$];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  logic           iclk      ;
  logic           iclkena   ;
  logic           ireset    ;
  logic           isop      ;
  logic           ival      ;
  logic           ieop      ;
  logic           ieof      ;
  logic           idat      ;
  logic           osop      ;
  logic           oval      ;
  logic           oeop      ;
  logic           oeof      ;
  logic           odat      ;
  logic           odecfail  ;
  logic [m-1 : 0] obiterr   ;

  logic           enc__osop ;
  logic           enc__oval ;
  logic           enc__oeop ;
  logic           enc__odat ;

  logic           dec__isop ;
  logic           dec__ival ;
  logic           dec__ieop ;
  logic           dec__ieras;
  logic           dec__idat ;

  //------------------------------------------------------------------------------------------------------
  // generate src stream
  //------------------------------------------------------------------------------------------------------

  initial begin : src_generator
    data_trans tr;

    ireset = 1'b1;
    isop   = 1'b0;
    ieop   = 1'b0;
    ieof   = 1'b0;
    ival   = 1'b0;
    idat   = 1'b0;
    repeat (2) @(negedge iclk);
    ireset = 1'b0;

    @(posedge iclk iff iclkena);

    for (int j = 0; j < NUM; j++) begin
      tr = new;
      assert(tr.randomize()) else begin
        $error ("data generate error");
      end
      tr.last = (j == NUM-1);

      enc2err.push_back(tr);
      for (int i = 0; i < n; i++) begin
        isop <= (i == 0);
        ieop <= (i == k-1);
        ieof <= (i == n-1);
        idat <= (i < k) ? tr.data.dat_bits[i] : 0;
        ival <= 1'b1;
        //
        @(posedge iclk iff iclkena);
        isop <= 1'b0;
        ieop <= 1'b0;
        ieof <= 1'b0;
        ival <= 1'b0;
        repeat (tr.bit_delay) @(posedge iclk iff iclkena);
      end
      repeat (tr.block_delay) @(posedge iclk iff iclkena);
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bch_enc
  #(
    .m       ( m       ) ,
    .k_max   ( k_max   ) ,
    .d       ( d       ) ,
    .n       ( n       )
  )
  uut_enc
  (
    .iclk    ( iclk      ) ,
    .iclkena ( iclkena   ) ,
    .ireset  ( ireset    ) ,
    //
    .isop    ( isop      ) ,
    .ieop    ( ieop      ) ,
    .ieof    ( ieof      ) ,
    .ival    ( ival      ) ,
    .idat    ( idat      ) ,
    //
    .osop    ( enc__osop ) ,
    .oval    ( enc__oval ) ,
    .oeop    ( enc__oeop ) ,
    .odat    ( enc__odat )
  );

  //------------------------------------------------------------------------------------------------------
  // error inserter
  //------------------------------------------------------------------------------------------------------

  initial begin
    dec__isop <= 1'b0;
    dec__ieop <= 1'b0;
    dec__ival <= 1'b0;
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin  // align delay in error inserter
      dec__isop <= enc__osop;
      dec__ieop <= enc__oeop;
      dec__ival <= enc__oval;
    end
  end

  initial begin : err_insertion
    data_trans tr;

    dec__idat  <= 1'b0;
    dec__ieras <= 1'b0;

    forever begin
      int i, eidx, eraidx;

      for (int i = 0, eidx = 0, eraidx = 0; i < n; i++) begin
        if (i == 0) begin // wait for new block
          @(posedge iclk iff (enc__oval & enc__osop & iclkena));
          tr = enc2err.pop_front();
        end
        else begin
          @(posedge iclk iff (enc__oval & iclkena));
        end
        // get data with error
        dec__idat   <= enc__odat;
        dec__ieras  <= 1'b0;
        if (eidx < tr.bit_err_num) begin
          if (tr.bit_err_pos[eidx] == i) begin
            dec__idat <= ~enc__odat;
            eidx++;
          end
        end
        if (eraidx < tr.bit_eras_num) begin
          if (tr.bit_eras_pos[eraidx] == i) begin
            dec__idat   <= ~enc__odat;
            dec__ieras  <= 1'b1;
            eraidx++;
          end
        end
        // assemble good data 2 scoreboard
        if (i < k) begin
          assert (tr.data.dat_bits[i] == enc__odat) else
            $error ("coder data compare error bit %0d %0b != %0b", i, enc__odat, tr.data.dat_bits[i]);
        end
        else begin
          tr.data.bch_bits[i] = enc__odat;
        end
        //
        if (i == n-1) begin
          assert (enc__oeop) else begin
            $error ("coder eop signal error");
          end
        end
      end
      // send transaction to scoreboard
      err2dec.push_back(tr);
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bch_eras_dec
  #(
    .m         ( m         ) ,
    .k_max     ( k_max     ) ,
    .d         ( d         ) ,
    .n         ( n         ) ,
    //
    .pBM_TYPE ( pBM_TYPE   )
  )
  uut_dec
  (
    .iclk     ( iclk       ) ,
    .ireset   ( ireset     ) ,
    .iclkena  ( iclkena    ) ,
    //
    .isop     ( dec__isop  ) ,
    .ival     ( dec__ival  ) ,
    .ieop     ( dec__ieop  ) ,
    .ieras    ( dec__ieras ) ,
    .idat     ( dec__idat  ) ,
    //
    .osop     ( osop       ) ,
    .oval     ( oval       ) ,
    .oeop     ( oeop       ) ,
    .oeof     ( oeof       ) ,
    .odat     ( odat       ) ,
    .odecfail ( odecfail   ) ,
    .obiterr  ( obiterr    )
  );

  //------------------------------------------------------------------------------------------------------
  // scroreboard
  //------------------------------------------------------------------------------------------------------

  initial begin : scoreboard
    data_trans      tr;
    logic [n-1 : 0] tmp;

    int ecnt;
    int ecnt_pre;
    int wcnt;

    do begin

      for (int i = 0; i < n; i++) begin
        if (i == 0) begin
          @(posedge iclk iff (oval & osop & iclkena));
          tr = err2dec.pop_front();
          //
          if (odecfail === 0) begin
            $display("%0t decode {err %0d : era %0d} done. errors %0d", $time, tr.bit_err_num, tr.bit_eras_num, obiterr);
          end
          else begin
            $display("%0t decfaile occured {err %0d : era %0d}. errors %0d", $time, tr.bit_err_num, tr.bit_eras_num, obiterr);
          end
          //
        end
        else begin
          @(posedge iclk iff (oval & iclkena));
        end

        tmp[i] = odat;
        //
        ecnt_pre = ecnt;

        if (i == k-1) begin
          assert (oeop) else begin
            $error ("decoder eop signal error");
          end
        end

        if (i == n-1) begin
          assert (oeof) else begin
            $error ("decoder eof signal error");
            ecnt++;
          end
          if ((2*tr.bit_err_num + tr.bit_eras_num) > t2) begin
            assert (odecfail) else begin
              $warning ("decoder may miss decfail signal error for block with %0d symbol errors and %0d erasures", tr.bit_err_num, tr.bit_eras_num);
              wcnt++;
            end
          end
          else begin
            assert (~odecfail) else begin
              $error ("decoder no decfail signal error");
              ecnt++;
            end
            //
            assert (tr.bit_dist_num == obiterr) else begin
              $error ("decoder err_num signal error %0d != %0d", tr.bit_dist_num, obiterr);
              ecnt++;
            end
            //
            assert (tmp == tr.data) else begin
              $error ("data compare error %h != %h, pos %h", tmp, tr.data, tmp ^ tr.data);
              for (int i = 0; i < n; i++) begin
                if (tmp[i] != tr.data[i])
                  $display("error pos %0d", i);
              end
              $display ("tr is %p", tr);
              ecnt++;
            end
          end
        end
        if (ecnt_pre != ecnt) begin
          $display("error occured for transaction %p", tr);
          $stop;
        end
      end
    end
    while (tr.last == 1'b0);
    $display("test done. block num = %0d :: errors == %0d, warnings = %0d occured", NUM, ecnt, wcnt);
    $stop;
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    iclk <= 1'b0;
    #5ns forever #5ns iclk = ~iclk;
  end

  initial iclkena = 1'b1;

endmodule
