//
// Project       : hamming
// Author        : Shekhalev Denis (des00)
// Workfile      : hamming_tb.v
// Description   : tb for systematic extended hamming codec
//

module hamming_tb ;

//parameter int pR      = 6 ; // {64/63, 57}
//parameter int pR      = 5 ; // {32/31, 26}
//parameter int pR      = 4 ; // {16/15, 11}
  parameter int pR      = 3 ; // { 8/ 7, 4}
  parameter bit pEXT    = 0 ;
  parameter int pTAG_W  = 1 ;

  logic                iclk       ;
  logic                ireset     ;
  logic                iclkena    ;

  logic                enc__isop  ;
  logic                enc__ival  ;
  logic                enc__ieop  ;
  logic                enc__ieof  ;
  logic [pTAG_W-1 : 0] enc__itag  ;
  logic                enc__idat  ;

  logic                enc__osop  ;
  logic                enc__oval  ;
  logic                enc__oeop  ;
  logic [pTAG_W-1 : 0] enc__otag  ;
  logic                enc__odat  ;


  logic                dec__isop      ;
  logic                dec__ival      ;
  logic                dec__ieop      ;
  logic [pTAG_W-1 : 0] dec__itag      ;
  logic                dec__idat      ;

  logic                dec__osop      ;
  logic                dec__oval      ;
  logic                dec__oeop      ;
  logic                dec__odecfail  ;
  logic [pTAG_W-1 : 0] dec__otag      ;
  logic                dec__odat      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDBITS = 2**pR - pR - 1;
  localparam int cCBITS = 2**pR - 1 + pEXT;

  localparam int cMAX_BLOCK_DELAY = 10;
  localparam int cMIN_BLOCK_DELAY = 0;

  localparam int cMAX_BIT_DELAY   = 10;
  localparam int cMIN_BIT_DELAY   = 0;

  class data_trans;
    bit last;

    rand bit [cCBITS-1 : 0] data;

    rand int unsigned bit_err_num;
    rand int unsigned bit_err_pos [];

    rand int unsigned block_delay ;
    rand int unsigned bit_delay   ;

    constraint error_dist     { bit_err_num dist {0 := 3, 1 := 3, 2 := 3};}

    constraint error_pos_size { bit_err_pos.size() == bit_err_num; }
    constraint error_pos_pos  { foreach (bit_err_pos[i]) bit_err_pos[i] < cCBITS;}

    constraint order {solve bit_err_num before bit_err_pos;}

    constraint block_delay_size { block_delay <= cMAX_BLOCK_DELAY;
                                  block_delay >= cMIN_BLOCK_DELAY;}
    constraint bit_delay_size   { bit_delay   <= cMAX_BIT_DELAY;
                                  bit_delay   >= cMIN_BIT_DELAY;}

    function void post_randomize ();
      bit is_unique;
    begin
      for (int i = 0; i < bit_err_num; i++) begin
        do begin
          is_unique = 1;
          for (int j = i-1; j >= 0; j--) begin
            is_unique &= (bit_err_pos[i] != bit_err_pos[j]);
          end
          if (!is_unique)
            bit_err_pos[i] = $urandom_range(0, cCBITS-1);
        end
        while (!is_unique);
      end
      if (bit_err_num != 0)
        bit_err_pos.sort();
    end
    endfunction

    function bit do_compare (input bit [cCBITS-1 : 0] rdata);
      do_compare = (data[cDBITS-1 : 0] == rdata[cDBITS-1 : 0]);
    endfunction

  endclass

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  hamming_enc
  #(
    .pR     ( pR     ) ,
    .pTAG_W ( pTAG_W )
  )
  enc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .isop    ( enc__isop  ) ,
    .ival    ( enc__ival  ) ,
    .ieop    ( enc__ieop  ) ,
    .ieof    ( enc__ieof  ) ,
    .itag    ( enc__itag  ) ,
    .idat    ( enc__idat  ) ,
    //
    .osop    ( enc__osop  ) ,
    .oval    ( enc__oval  ) ,
    .oeop    ( enc__oeop  ) ,
    .otag    ( enc__otag  ) ,
    .odat    ( enc__odat  )
  );

  hamming_dec
  #(
    .pR     ( pR     ) ,
    .pEXT   ( pEXT   ) ,
    .pTAG_W ( pTAG_W )
  )
  dec
  (
    .iclk     ( iclk          ) ,
    .ireset   ( ireset        ) ,
    .iclkena  ( iclkena       ) ,
    //
    .isop     ( dec__isop     ) ,
    .ival     ( dec__ival     ) ,
    .ieop     ( dec__ieop     ) ,
    .itag     ( dec__itag     ) ,
    .idat     ( dec__idat     ) ,
    //
    .osop     ( dec__osop     ) ,
    .oval     ( dec__oval     ) ,
    .oeop     ( dec__oeop     ) ,
    .odecfail ( dec__odecfail ) ,
    .otag     ( dec__otag     ) ,
    .odat     ( dec__odat     )
  );

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  const int   N = 1000;

  data_trans  tr;
  data_trans  tx_fifo[$];
  data_trans  rx_fifo[$];
  data_trans  rx_tr;

  //------------------------------------------------------------------------------------------------------
  // "noisy" channel
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      dec__ival <= 1'b0;
    else if (iclkena)
      dec__ival <= enc__oval;
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dec__isop <= enc__osop ;
      dec__ieop <= enc__oeop ;
      dec__itag <= enc__otag ;
    end
  end

  initial begin
    data_trans tmp_tr;
    forever begin
      @(posedge iclk iff (iclkena & enc__oval & enc__osop));
      tmp_tr = tx_fifo.pop_back();
      rx_fifo.push_front(tmp_tr);
      for (int i = 0; i < cCBITS; i++) begin
        if ((tmp_tr.bit_err_num != 0) && (i inside {tmp_tr.bit_err_pos}))
          dec__idat <= !enc__odat;
        else
          dec__idat <=  enc__odat;
        //
        if (enc__oeop)
          break;
        else
          @(posedge iclk iff (iclkena & enc__oval));
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    iclk <= 1'b0;
    #5ns forever #5ns iclk = ~iclk;
  end

  assign iclkena = 1'b1;

  initial begin : gen
    ireset = 1'b1;
    enc__isop = 1'b0;
    enc__ieop = 1'b0;
    enc__ieof = 1'b0;
    enc__ival = 1'b0;
    enc__itag = '0;
    enc__idat = 1'b0;
    repeat (10) @(negedge iclk);
    ireset = 1'b0;

    @(posedge iclk);

    for (int i = 0; i < N; i++) begin
      tr = new;
      void'(tr.randomize);
      tr.last = (i == N-1);
      tx_fifo.push_front(tr);
      do_encode(tr);
    end
  end

  bit                rx_decfail;
  bit [cDBITS-1 : 0] rx_data;

  int err;

  initial begin //: checker
    err = 0;
    //
    forever begin
      @(posedge iclk iff (iclkena & dec__oval & dec__osop));
      //
      for (int i = 0; i < cDBITS; i++) begin
        rx_decfail  = dec__odecfail;
        rx_data[i]  = dec__odat;
        if (i == cDBITS-1)
          break;
        else
          @(posedge iclk iff (iclkena & dec__oval));
      end
      //
      assert (dec__oeop) else $error ("dec__oeop is incorrect");
      //
      rx_tr = rx_fifo.pop_back();
      if (rx_tr.bit_err_num < 2) begin
        assert (rx_tr.do_compare(rx_data)) else begin
          err++;
          $error("data compare error %b != %b, tr context is %p", rx_tr.data[cDBITS-1 : 0], rx_data, rx_tr);
        end
        assert (!rx_decfail) else begin
          err++;
          $error("decfail incorrect for 0/1 error");
        end
      end
      else begin
        if (pEXT) begin
          assert (rx_decfail) else begin
            err++;
            $error("decfail incorrect for 2 errors");
          end
        end
      end
      //
      if (rx_tr.last)
        break;
    end
    $display("test done. %0d errors", err);
    $stop;
  end

  task do_encode (data_trans tr);
    for (int i = 0; i < cCBITS; i++) begin
      enc__isop <= (i == 0);
      enc__ieop <= (i == cDBITS-1);
      enc__ieof <= (i == cCBITS-1);
      enc__idat <= tr.data[i];
      enc__ival <= 1'b1;
      @(posedge iclk iff iclkena);
      enc__ival <= 1'b0;
      repeat (tr.bit_delay) @(posedge iclk iff iclkena);
    end
    repeat (tr.block_delay) @(posedge iclk iff iclkena);
  endtask

endmodule
