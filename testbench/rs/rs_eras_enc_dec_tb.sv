//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision: 11044 $
// Date          : $Date$
// Workfile      : rs_enc_dec_tb.v
// Description   : rs decoder with erasure testbench
//


module rs_eras_enc_dec_tb ;

  parameter   int m         =   8;      // GF (2^m)
  parameter   int irrpol    = 285;      // irrectible poly
//parameter   int m         =   3;      // GF (2^m)
//parameter   int irrpol    =  11;      // irrectible poly

  localparam  int gf_n_max  = 2**m - 1; // maximum block size

  parameter int sym_err_w   =  m;   // clogb2(check + 1);
  parameter int bit_err_w   =  m+1; // clogb2((check + 1)*m);

  //------------------------------------------------------------------------------------------------------
  // RS parameters
  //------------------------------------------------------------------------------------------------------

//parameter int n           = 7;  // block size
//parameter int check       = 4;  // check symbols

//parameter int n           = 240;  // block size
//parameter int check       =  30;  // check symbols

//parameter int n           = 144;  // block size
//parameter int check       =  24;  // check symbols

//parameter int n           = 240;  // block size
//parameter int check       =  24;  // check symbols

  parameter int n           = 255;  // block size
  parameter int check       =  32;  // check symbols

//localparam int used_genstart = 0;
//localparam int used_genstart = gf_n_max-check;

  localparam int used_genstart  = 0;
  localparam int used_rootspace = 11;

  localparam int errs       = check/2;
  localparam int erasures   = check;

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef logic [m-1 : 0] data_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam pBM_TYPE = "ribm_2check";
//localparam pBM_TYPE = "ribm_2check_by_check";

  localparam bit pBM_ASYNC = 1'b0;

  localparam int NUM             = 128;

  localparam int MIN_BLOCK_DELAY = (pBM_TYPE == "ribm_2check_by_check") ? (2.1*check*check) : 0;
  localparam int MAX_BLOCK_DELAY = MIN_BLOCK_DELAY + 16;

  localparam int MIN_BIT_DELAY   = 0;
  localparam int MAX_BIT_DELAY   = 0;

  typedef struct {
    data_t  check_symb [n-1       : n-check];
    data_t  data_symb  [n-check-1 : 0];
  } rs_data_t;

  class data_trans;
    bit last;

    // rand rs_data_t     data; questa bug ???

    rand bit [m-1 : 0] check_symb [n-1       : n-check];
    rand bit [m-1 : 0] data_symb  [n-check-1 : 0];

    rand int unsigned symb_err_num; // errs + erasures
    rand int unsigned symb_era_num;
    rand int unsigned symb_err_pos [];
    rand int unsigned symb_era_pos [];

    int unsigned bit_err_num;       // common amount of bit errors
    int unsigned bit_err_value [];  // bit errors in each error symbol

    rand int unsigned block_delay ;
    rand int unsigned bit_delay   ;

//  constraint symb_error_dist     { symb_err_num dist {0 := 3, [1 : errs] :/ 5, [errs+1 : check] :/ 2;}
    constraint symb_error_dist     { symb_err_num dist {0 := 1, [1 : errs] :/ 5, [errs+1 : check] :/ 2,
                                                  [check+1 : check + (n-check)/16] :/ 10};}

//  constraint symb_error_dist     { symb_err_num == 3; }
    constraint symb_error_pos_size { symb_err_pos.size() == symb_err_num;
                                     symb_era_pos.size() == symb_err_num;}

    constraint symb_error_pos_pos  { foreach (symb_err_pos[i]) symb_err_pos[i] < n;}

    constraint order {solve symb_err_num before symb_err_pos;
                      solve symb_err_num before symb_era_num;}

    constraint symb_era_amount     { symb_era_num <= symb_err_num;}
//  constraint symb_era_amount     { symb_era_num == 0;}

    constraint block_delay_size { block_delay <= MAX_BLOCK_DELAY;
                                  block_delay >= MIN_BLOCK_DELAY;}

    constraint bit_delay_size   { bit_delay   <= MAX_BIT_DELAY;
                                  bit_delay   >= MIN_BIT_DELAY;}

    function void post_randomize ();
      bit is_unique;
      int err_num;
      bit tmp [0 : m-1];
      int eras_start;
    begin
      for (int i = 0; i < symb_err_num; i++) begin
        do begin
          is_unique = 1;
          for (int j = i-1; j >= 0; j--) begin
            is_unique &= (symb_err_pos[i] != symb_err_pos[j]);
          end
          if (!is_unique) begin
            symb_err_pos[i] = $urandom_range(0, n-1);
          end
        end
        while (!is_unique);
      end
      //
      if (symb_err_num != 0) begin
        symb_err_pos.sort();
      end
      //
      for (int i = 0; i < symb_err_num; i++) begin
        symb_era_pos[i] = (i < symb_era_num) ? 1 : 0;
      end
      //
      if (symb_era_num != 0) begin
        symb_era_pos.shuffle();
      end
      //
      // assign bit errors in symbols
      bit_err_num   = 0;
      bit_err_value = new[symb_err_num];
      //
      for (int i = 0; i < symb_err_num; i++) begin
        err_num = $urandom_range(1, m);
        bit_err_num += err_num;
        for (int b = 0; b < m; b++) begin
          tmp[b] = (b < err_num);
        end
//      $display("bit errors before %0p, %0d", tmp, err_num);
        tmp.shuffle();
//      $display("bit errors after %0p, %0d", tmp, err_num);
        for (int b =0; b < m; b++) begin
          bit_err_value[i][b] = tmp[b];
        end
      end
    end
    endfunction

  endclass

  data_trans enc2err  [$];
  data_trans err2dec  [$];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  logic                   iclk      ;
  logic                   iclkena   ;
  logic                   ireset    ;
  logic                   isop      ;
  logic                   ival      ;
  logic                   ieop      ;
  logic                   ieof      ;
  logic         [m-1 : 0] idat      ;
  logic                   osop      ;
  logic                   oval      ;
  logic                   oeop      ;
  logic                   oeof      ;
  logic         [m-1 : 0] odat      ;
  logic                   odecfail  ;
  logic [sym_err_w-1 : 0] onum_err_sym  ;
  logic [bit_err_w-1 : 0] onum_err_bit  ;

  logic                   enc__osop ;
  logic                   enc__oval ;
  logic                   enc__oeop ;
  logic         [m-1 : 0] enc__odat ;

  logic                   dec__isop ;
  logic                   dec__ieras;
  logic                   dec__ival ;
  logic                   dec__ieop ;
  logic         [m-1 : 0] dec__idat ;

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
    idat   =   '0;
    repeat (2) @(negedge iclk);
    ireset = 1'b0;

    @(posedge iclk iff iclkena);

    for (int j = 0; j < NUM; j++) begin
      tr = new;
      assert(tr.randomize()) else begin
        $error ("data generate error");
      end
      tr.last = (j == NUM-1);

//    $display("generate transacion %p", tr);

      enc2err.push_back(tr);
      for (int i = 0; i < n; i++) begin
        isop <= (i == 0);
        ieop <= (i == n-check-1);
        ieof <= (i == n-1);
        idat <= (i < (n-check)) ? tr.data_symb[i] : 0;
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

  rs_enc
  #(
    .n         ( n              ) ,
    .check     ( check          ) ,
    .m         ( m              ) ,
    .irrpol    ( irrpol         ) ,
    .genstart  ( used_genstart  ) ,
    .rootspace ( used_rootspace )
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
    dec__isop   <= 1'b0;
    dec__ieras  <= 1'b0;
    dec__ieop   <= 1'b0;
    dec__ival   <= 1'b0;
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

    dec__idat   <= 1'b0;
    dec__ieras  <= 1'b0;

    forever begin
      int i, eidx;

      for (int i = 0, eidx = 0; i < n; i++) begin
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
        if (eidx < tr.symb_err_num) begin
          if (tr.symb_err_pos[eidx] == i) begin
            dec__idat   <= enc__odat ^ tr.bit_err_value[eidx];
            dec__ieras  <= tr.symb_era_pos[eidx];
            eidx++;
          end
        end
        // assemble good data 2 scoreboard
        if (i < (n-check)) begin
          assert (tr.data_symb[i] == enc__odat) else begin
            $error ("coder data compare error bit %0d %0d != %0d", i, enc__odat, tr.data_symb[i]);
          end
        end
        else begin
          tr.check_symb[i] = enc__odat;
        end
        //
        if (i == n-1) begin
          assert (enc__oeop) else begin
            $error ("coder eop signal error");
          end
        end
      end
      // send transaction to sender
      err2dec.push_back(tr);
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rs_eras_dec
  #(
    .n          ( n              ) ,
    .check      ( check          ) ,
    .m          ( m              ) ,
    .irrpol     ( irrpol         ) ,
    .genstart   ( used_genstart  ) ,
    .rootspace  ( used_rootspace ) ,
    .pBM_TYPE   ( pBM_TYPE       ) ,
    .pBM_ASYNC  ( pBM_ASYNC      ) ,
    .sym_err_w  ( sym_err_w      ) ,
    .bit_err_w  ( bit_err_w      )
  )
  uut_dec
  (
    .iclk         ( iclk         ) ,
    .ireset       ( ireset       ) ,
    .iclkena      ( iclkena      ) ,
    //
    .isop         ( dec__isop    ) ,
    .ieras        ( dec__ieras   ) ,
    .ival         ( dec__ival    ) ,
    .ieop         ( dec__ieop    ) ,
    .idat         ( dec__idat    ) ,
    //
    .osop         ( osop         ) ,
    .oval         ( oval         ) ,
    .oeop         ( oeop         ) ,
    .oeof         ( oeof         ) ,
    .odat         ( odat         ) ,
    .odecfail     ( odecfail     ) ,
    .onum_err_sym ( onum_err_sym ) ,
    .onum_err_bit ( onum_err_bit )
  );

  //------------------------------------------------------------------------------------------------------
  // scroreboard
  //------------------------------------------------------------------------------------------------------

  initial begin : scoreboard
    data_trans      tr;
    rs_data_t tmp;

    int ecnt;
    int ecnt_pre;
    int wcnt;

    do begin

      for (int i = 0; i < n; i++) begin
        if (i == 0) begin
          @(posedge iclk iff (oval & osop & iclkena));
          tr = err2dec.pop_front();
        end
        else begin
          @(posedge iclk iff (oval & iclkena));
        end
        // assemble data
        if (i >= n - check) begin
          tmp.check_symb[i] = odat;
        end
        else begin
          tmp.data_symb[i]  = odat;
        end
        // scoreboard itself
        ecnt_pre = ecnt;
        if (i == n - check-1) begin
          assert (oeop) else begin
            $error ("decoder eop signal error");
          end
        end
        if (i == n-1) begin
          assert (oeof) else begin
            $error ("decoder eof signal error");
            $stop;
            ecnt++;
          end
          if ((tr.symb_era_num + 2*(tr.symb_err_num-tr.symb_era_num)) > check) begin
            assert (odecfail) else begin
              $warning ("decoder may be miss decfail signal error for block with %0d symbol errors", tr.symb_err_num);
              wcnt++;
            end
          end
          else begin
            assert (~odecfail) else begin
              $error ("decoder no decfail signal error");
              ecnt++;
            end
            assert (tr.symb_err_num == onum_err_sym) else begin
              $error ("decoder sym_err_num signal error %0d != %0d", tr.symb_err_num, onum_err_sym);
              ecnt++;
            end
            assert (tr.bit_err_num == onum_err_bit) else begin
              $error ("decoder bit_err_num signal error %0d != %0d", tr.bit_err_num, onum_err_bit);
              ecnt++;
            end
            assert ((tmp.check_symb == tr.check_symb)&&(tmp.data_symb == tr.data_symb)) else begin
              for (int i = 0; i < n; i++) begin
                if (i >= n - check) begin
                  if (tmp.check_symb[i] != tr.check_symb[i])
                    $display("error pos %0d %0d != %0d ", i, tmp.check_symb[i], tr.check_symb[i]);
                end
                else begin
                  if (tmp.data_symb[i] != tr.data_symb[i])
                    $display("error pos %0d %0d != %0d ", i, tmp.data_symb[i], tr.data_symb[i]);
                end
              end
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

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (oeof) begin
        if (odecfail === 0) begin
          $display("%0t decode done. symb errors %0d, bit errors %0d", $time, onum_err_sym, onum_err_bit);
        end
        else begin
          $display("%0t decfaile occured. symb errors %0d, bit errors %0d", $time, onum_err_sym, onum_err_bit);
        end
      end
    end
  end

endmodule
