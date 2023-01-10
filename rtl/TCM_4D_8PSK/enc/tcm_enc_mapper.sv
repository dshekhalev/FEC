/*






  logic          tcm_enc_mapper__iclk     ;
  logic          tcm_enc_mapper__ireset   ;
  logic          tcm_enc_mapper__iclkena  ;
  logic  [1 : 0] tcm_enc_mapper__icode    ;
  logic          tcm_enc_mapper__i1sps    ;
  logic          tcm_enc_mapper__isop     ;
  logic          tcm_enc_mapper__ieop     ;
  logic          tcm_enc_mapper__ival     ;
  logic [11 : 0] tcm_enc_mapper__idat     ;
  logic          tcm_enc_mapper__o1sps    ;
  logic          tcm_enc_mapper__osop     ;
  logic          tcm_enc_mapper__oeop     ;
  logic          tcm_enc_mapper__oval     ;
  logic  [2 : 0] tcm_enc_mapper__odat     ;



  tcm_enc_mapper
  tcm_enc_mapper
  (
    .iclk    ( tcm_enc_mapper__iclk    ) ,
    .ireset  ( tcm_enc_mapper__ireset  ) ,
    .iclkena ( tcm_enc_mapper__iclkena ) ,
    .icode   ( tcm_enc_mapper__icode   ) ,
    .i1sps   ( tcm_enc_mapper__i1sps   ) ,
    .isop    ( tcm_enc_mapper__isop    ) ,
    .ieop    ( tcm_enc_mapper__ieop    ) ,
    .ival    ( tcm_enc_mapper__ival    ) ,
    .idat    ( tcm_enc_mapper__idat    ) ,
    .o1sps   ) tcm_enc_mapper__o1sps   ) ,
    .osop    ( tcm_enc_mapper__osop    ) ,
    .oeop    ( tcm_enc_mapper__oeop    ) ,
    .oval    ( tcm_enc_mapper__oval    ) ,
    .odat    ( tcm_enc_mapper__odat    )
  );


  assign tcm_enc_mapper__iclk    = '0 ;
  assign tcm_enc_mapper__ireset  = '0 ;
  assign tcm_enc_mapper__iclkena = '0 ;
  assign tcm_enc_mapper__icode   = '0 ;
  assign tcm_enc_mapper__i1sps   = '0 ;
  assign tcm_enc_mapper__isop    = '0 ;
  assign tcm_enc_mapper__ieop    = '0 ;
  assign tcm_enc_mapper__ival    = '0 ;
  assign tcm_enc_mapper__idat    = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_enc_mapper.v
// Description   : 4D-8PSK TCM encoder and 8PSK mapper
//

module tcm_enc_mapper
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  i1sps   ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  //
  o1sps   ,
  osop    ,
  oeop    ,
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk     ;
  input  logic          ireset   ;
  input  logic          iclkena  ;
  //
  input  logic  [1 : 0] icode    ;  // 0/1/2/3 - 2/2.25/2.5/2.75
  //
  input  logic          i1sps    ;  // symbol frequency
  // 4D symbol interface
  input  logic          isop     ;
  input  logic          ieop     ;
  input  logic          ival     ;  // must be align with symbol frequency
  input  logic [11 : 0] idat     ;
  // 8PSK symbol interface
  output logic          o1sps    ;
  output logic          osop     ;
  output logic          oeop     ;
  output logic          oval     ;
  output logic  [2 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [2 : 0] symb_t [4];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic sop   ;
  logic eop   ;
  logic s1sps ;

  logic [1 : 0] cnt;

  symb_t  z;

  //------------------------------------------------------------------------------------------------------
  // mapper
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      s1sps <= 1'b0;
    end
    else if (iclkena) begin
      s1sps <= i1sps;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (i1sps) begin
        cnt <= ival ? '0 : (cnt + 1'b1);
        //
        if (ival) begin
          sop <= isop;
          eop <= ieop;
          case (icode)
            2'b00 : z <= map_2_0 (idat);
            2'b01 : z <= map_2_25(idat);
            2'b10 : z <= map_2_5 (idat);
            2'b11 : z <= map_2_75(idat);
          endcase
        end
        else if (cnt == 3) begin
          sop <= 1'b0;
          eop <= 1'b0;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output symbol muxer
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      o1sps <= 1'b0;
      oval  <= 1'b0;
    end
    else if (iclkena) begin
      o1sps <= s1sps;
      oval  <= s1sps & (cnt == 0);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (s1sps) begin
        osop  <= sop & (cnt == 0);
        oeop  <= eop & (cnt == 3);
        odat  <= z[cnt];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // mapper functions
  //------------------------------------------------------------------------------------------------------

  function symb_t map_2_0 (input logic [11 : 0] x);
    symb_t z;
  begin
    z[0] = {x[8], x[5], x[1]};
    //
    z[1] = {x[8], x[5], x[1]} +
           {x[7], x[3], 1'b0};
    //
    z[2] = {x[8], x[5], x[1]} +
           {x[6], x[2], 1'b0};
    //
    z[3] = {x[8], x[5], x[1]} +
           {x[7], x[3], 1'b0} +
           {x[6], x[2], 1'b0} +
           {x[4], x[0], 1'b0};
    //
    map_2_0 = z;
  end
  endfunction

  function symb_t map_2_25  (input logic [11 : 0] x);
    symb_t z;
  begin
    z[0] = {x[9], x[6], x[2]};
    //
    z[1] = {x[9], x[6], x[2]} +
           {x[8], x[4], x[0]};
    //
    z[2] = {x[9], x[6], x[2]} +
           {x[7], x[3], 1'b0};
    //
    z[3] = {x[9], x[6], x[2]} +
           {x[8], x[4], 1'b0} +
           {x[7], x[3], 1'b0} +
           {x[5], x[1], x[0]};
    //
    map_2_25 = z;
  end
  endfunction

  function symb_t map_2_5   (input logic [11 : 0] x);
    symb_t z;
  begin
    z[0] = {x[10], x[7], x[3]};
    //
    z[1] = {x[10], x[7], x[3]} +
           { x[9], x[5], x[1]};
    //
    z[2] = {x[10], x[7], x[3]} +
           { x[8], x[4], x[0]};
    //
    z[3] = {x[10], x[7], x[3]} +
           { x[9], x[5], x[1]} +
           { x[8], x[4], x[0]} +
           { x[6], x[2], 1'b0};
    //
    map_2_5 = z;
  end
  endfunction

  function symb_t map_2_75  (input logic [11 : 0] x);
    symb_t z;
  begin
    z[0] = {x[11], x[8], x[4]};
    //
    z[1] = {x[11], x[8], x[4]} +
           {x[10], x[6], x[2]};
    //
    z[2] = {x[11], x[8], x[4]} +
           { x[9], x[5], x[1]};
    //
    z[3] = {x[11], x[8], x[4]} +
           {x[10], x[6], x[2]} +
           { x[9], x[5], x[1]} +
           { x[7], x[3], x[0]};
    //
    map_2_75 = z;
  end
  endfunction

endmodule
