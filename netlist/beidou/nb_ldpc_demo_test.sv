//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : nb_ldpc_demo_test.sv
// Description   : simple testbench for decoder netlist
//

module nb_ldpc_demo_test;

  parameter int pDAT_W        = 1 ;
  parameter int pTAG_W        = 8 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                     iclk             ;
  logic                     ireset           ;
  //
  logic [1 : 0]             icode_idx        ;
  //
  logic                     iclkin           ;
  //
  logic                     isop             ;
  logic                     ival             ;
  logic                     ieop             ;
  logic      [pDAT_W-1 : 0] idat             ;
  logic      [pTAG_W-1 : 0] itag             ;
  //
  logic                     ordy             ;
  logic                     obusy            ;
  logic                     osource_err      ;
  //
  logic                     iclkout          ;
  logic                     ireq             ;
  logic                     ofull            ;
  //
  logic                     osop             ;
  logic                     oval             ;
  logic                     oeop             ;
  logic      [pDAT_W-1 : 0] odat             ;
  logic      [pTAG_W-1 : 0] otag             ;

  logic             [7 : 0] dec__iNiter          ;
  logic                     dec__ifmode          ;
  //
  logic                     dec__isop            ;
  logic                     dec__ival            ;
  logic                     dec__ieop            ;
  logic      [pDAT_W-1 : 0] dec__idat            ;
  logic      [pTAG_W-1 : 0] dec__itag            ;
  //
  logic                     dec__ordy            ;
  logic                     dec__obusy           ;
  logic                     dec__oframe_in_error ;
  //
  logic                     dec__osop            ;
  logic                     dec__oval            ;
  logic                     dec__oeop            ;
  logic      [pDAT_W-1 : 0] dec__odat            ;
  logic      [pTAG_W-1 : 0] dec__otag            ;
  //
  logic             [7 : 0] dec__ouNiter         ;
  logic                     dec__odecfail        ;
  logic            [10 : 0] dec__obit_err        ;
  logic             [7 : 0] dec__osymb_err       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_enc
  #(
    .pDAT_W ( pDAT_W ) ,
    .pTAG_W ( pTAG_W )
  )
  uut
  (
    .iclk        ( iclk        ) ,
    .ireset      ( ireset      ) ,
    //
    .icode_idx   ( icode_idx   ) ,
    //
    .iclkin      ( iclkin      ) ,
    //
    .isop        ( isop        ) ,
    .ival        ( ival        ) ,
    .ieop        ( ieop        ) ,
    .idat        ( idat        ) ,
    .itag        ( itag        ) ,
    //
    .ordy        ( ordy        ) ,
    .obusy       ( obusy       ) ,
    .osource_err ( osource_err ) ,
    //
    .iclkout     ( iclkout     ) ,
    .ireq        ( ireq        ) ,
    .ofull       ( ofull       ) ,
    //
    .osop        ( osop        ) ,
    .oval        ( oval        ) ,
    .oeop        ( oeop        ) ,
    .odat        ( odat        ) ,
    .otag        ( otag        )
  );

  assign ireq = 1'b1;

  nb_ldpc_dec_wrp
  dec
  (
    .iclk            ( iclk                 ) ,
    .ireset          ( ireset               ) ,
    .iclk_core       ( iclk                 ) ,
    //
    .iNiter          ( dec__iNiter          ) ,
    .ifmode          ( dec__ifmode          ) ,
    //
    .isop            ( dec__isop            ) ,
    .ival            ( dec__ival            ) ,
    .ieop            ( dec__ieop            ) ,
    .idat            ( dec__idat            ) ,
    .itag            ( dec__itag            ) ,
    //
    .ordy            ( dec__ordy            ) ,
    .obusy           ( dec__obusy           ) ,
    .oframe_in_error ( dec__oframe_in_error ) ,
    //
    .osop            ( dec__osop            ) ,
    .oval            ( dec__oval            ) ,
    .oeop            ( dec__oeop            ) ,
    .odat            ( dec__odat            ) ,
    .otag            ( dec__otag            ) ,
    //
    .ouNiter         ( dec__ouNiter         ) ,
    .odecfail        ( dec__odecfail        ) ,
    .obit_err        ( dec__obit_err        ) ,
    .osymb_err       ( dec__osymb_err       )
  );

  assign dec__isop      = osop ;
  assign dec__ival      = oval ;
  assign dec__ieop      = oeop ;
  assign dec__idat      = osop ? ~odat : odat;
  assign dec__itag      = otag ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    iclk <= 1'b0;
    #5ns forever #5ns iclk = ~iclk;
  end

  assign iclkin  = iclk;
  assign iclkout = iclk;

  initial begin
    ireset <= 1'b1;
    repeat (5) @(posedge iclk);
    ireset <= 1'b0;
  end

  bit b_data      [44*6];
  bit b_enc_data  [88*6];
  bit b_dec_data  [44*6];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  int tsymb_num;
  int err ;

  assign dec__iNiter = 5;
  assign dec__ifmode = 1;

  assign icode_idx   = 0;

  initial begin : main
    isop      <= '0;
    ieop      <= '0;
    ival      <= '0;
    idat      <= '0;
    itag      <= '1;
    //
    @(posedge iclk iff !ireset);
    //
    @(posedge iclk);
    //
    gen_data(44);
    set_data(44);
    get_data(tsymb_num);
    // check data
    err = 0;
    //
    if (tsymb_num != 88) begin
      $display("wrong symbol size %0d", tsymb_num);
      err++;
    end

    for (int i = 0; i < 44*6; i++) begin
      if (b_data[i] != b_enc_data[i]) begin
        $display("error at %0d bit %0d symbol", i, i / 6);
        err++;
        $stop;
      end
    end

    $display("test enc done. err = %0d", err);

    get_dec_data(tsymb_num);
    // check data
    err = 0;
    //
    if (tsymb_num !=44) begin
      $display("dec :: wrong symbol size %0d", tsymb_num);
      err++;
    end
    //
    for (int i = 0; i < 44*6; i++) begin
      if (b_data[i] != b_dec_data[i]) begin
        $display("dec :: error at %0d bit %0d symbol", i, i / 6);
        err++;
        $stop;
      end
    end

    $display("test dec done. err = %0d, decfail = %0d, %0d/%0d, niter %0d", err, dec__odecfail, dec__osymb_err, dec__obit_err, dec__ouNiter);

    repeat (10) @(posedge iclk);

    //
    $stop;
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function void gen_data (int symb_num = 44);
    for (int i = 0; i < symb_num*6; i++) begin
      b_data[i] = $urandom;
    end
  endfunction

  task set_data (int symb_num = 44);
    bit [5 : 0] symb;
  begin
    for (int i = 0; i < symb_num*6; i++) begin
      ival <= 1'b1;
      isop <= (i == 0);
      ieop <= (i == (symb_num*6-1));
      idat <= b_data[i];
      @(posedge iclk);
      ival <= 1'b0;
      isop <= 1'b0;
      ieop <= 1'b0;
    end
  end
  endtask

  task get_data (output int symb_num);
    int bnum;
  begin
    do begin
      @(posedge iclk iff oval);
      //
      if (osop) begin
        symb_num = 0;
        bnum     = 0;
      end
      //
      b_enc_data[symb_num*6 + bnum] = odat;
      //
      bnum++;
      if (bnum == 6) begin
        bnum = 0;
        symb_num++;
      end
      //
      if (oeop) begin
        break;
      end
    end
    while (1) ;
  end
  endtask

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  task get_dec_data (output int symb_num);
    int bnum;
  begin
    do begin
      @(posedge iclk iff dec__oval);
      //
      if (dec__osop) begin
        symb_num = 0;
        bnum     = 0;
      end
      //
      b_dec_data[symb_num*6 + bnum] = dec__odat;
      //
      bnum++;
      if (bnum == 6) begin
        bnum = 0;
        symb_num++;
      end
      //
      if (dec__oeop) begin
        break;
      end
    end
    while (1) ;
  end
  endtask

endmodule
