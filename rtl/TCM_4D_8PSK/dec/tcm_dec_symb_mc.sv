/*



  parameter int pDAT_W    = 8 ;
  parameter int pSYMB_M_W = 8 ;



  logic                 tcm_dec_symb_mc__iclk         ;
  logic                 tcm_dec_symb_mc__ireset       ;
  logic                 tcm_dec_symb_mc__iclkena      ;
  logic                 tcm_dec_symb_mc__i1sps        ;
  logic                 tcm_dec_symb_mc__isop         ;
  logic                 tcm_dec_symb_mc__ival         ;
  logic                 tcm_dec_symb_mc__ieop         ;
  logic  [pDAT_W-1 : 0] tcm_dec_symb_mc__idat_re      ;
  logic  [pDAT_W-1 : 0] tcm_dec_symb_mc__idat_im      ;
  logic                 tcm_dec_symb_mc__o1sps        ;
  logic                 tcm_dec_symb_mc__osop         ;
  logic                 tcm_dec_symb_mc__oval         ;
  logic                 tcm_dec_symb_mc__oeop         ;
  symb_m_t              tcm_dec_symb_mc__osymb_m      ;
  symb_m_sign_t         tcm_dec_symb_mc__osymb_m_sign ;



  tcm_dec_symb_mc
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_symb_mc
  (
    .iclk         ( tcm_dec_symb_mc__iclk         ) ,
    .ireset       ( tcm_dec_symb_mc__ireset       ) ,
    .iclkena      ( tcm_dec_symb_mc__iclkena      ) ,
    .i1sps        ( tcm_dec_symb_mc__i1sps        ) ,
    .isop         ( tcm_dec_symb_mc__isop         ) ,
    .ival         ( tcm_dec_symb_mc__ival         ) ,
    .ieop         ( tcm_dec_symb_mc__ieop         ) ,
    .idat_re      ( tcm_dec_symb_mc__idat_re      ) ,
    .idat_im      ( tcm_dec_symb_mc__idat_im      ) ,
    .o1sps        ( tcm_dec_symb_mc__o1sps        ) ,
    .osop         ( tcm_dec_symb_mc__osop         ) ,
    .oval         ( tcm_dec_symb_mc__oval         ) ,
    .oeop         ( tcm_dec_symb_mc__oeop         ) ,
    .osymb_m      ( tcm_dec_symb_mc__osymb_m      ) ,
    .osymb_m_sign ( tcm_dec_symb_mc__osymb_m_sign )
  );


  assign tcm_dec_symb_mc__iclk    = '0 ;
  assign tcm_dec_symb_mc__ireset  = '0 ;
  assign tcm_dec_symb_mc__iclkena = '0 ;
  assign tcm_dec_symb_mc__i1sps   = '0 ;
  assign tcm_dec_symb_mc__isop    = '0 ;
  assign tcm_dec_symb_mc__ival    = '0 ;
  assign tcm_dec_symb_mc__ieop    = '0 ;
  assign tcm_dec_symb_mc__idat_re = '0 ;
  assign tcm_dec_symb_mc__idat_im = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_symb_mc.sv
// Description   : 8PSK symbol metric calculator
//

`include "define.vh"

module tcm_dec_symb_mc
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  i1sps         ,
  isop          ,
  ival          ,
  ieop          ,
  idat_re       ,
  idat_im       ,
  //
  o1sps         ,
  osop          ,
  oval          ,
  oeop          ,
  osymb_m       ,
  osymb_m_sign
);

  parameter int pDAT_W = 8 ;

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk         ;
  input  logic                       ireset       ;
  input  logic                       iclkena      ;
  // 8PSK interface
  input  logic                       i1sps        ; // symbol frequency
  input  logic                       isop         ;
  input  logic                       ival         ; // first symbol of 4D symbol
  input  logic                       ieop         ;
  input  logic signed [pDAT_W-1 : 0] idat_re      ;
  input  logic signed [pDAT_W-1 : 0] idat_im      ;
  // 4D 8PSK interface
  output logic                       o1sps        ;
  output logic                       osop         ;
  output logic                       oval         ;
  output logic                       oeop         ;
  output symb_m_t                    osymb_m      ;
  output symb_m_sign_t               osymb_m_sign ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = pDAT_W + 1; // + 1 bit for add and for maximum negative abs value

  localparam int cSCALE_FACTOR = 181;
  localparam int cDIV_FACTOR_W =   8;

  localparam int cMULT_W = cDAT_W + cDIV_FACTOR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic               [3 : 0] v1sps;
  logic               [3 : 0] val;
  logic               [2 : 0] sop;
  logic               [2 : 0] eop;
  //
  // C0/C2 metric signals
  logic signed [pDAT_W-1 : 0] dat_re;
  logic signed [pDAT_W-1 : 0] dat_im;

  logic                       sign_re;
  logic                       sign_im;

  logic        [pDAT_W-1 : 0] adat_re, adat_re_reg;
  logic        [pDAT_W-1 : 0] adat_im, adat_im_reg;

  logic                       sign4adat_re, sign4adat_re_reg;
  logic                       sign4adat_im, sign4adat_im_reg;
  //
  // C1/C3 metric signals
  logic signed [cDAT_W-1 : 0] dat_im_add_re;
  logic signed [cDAT_W-1 : 0] dat_im_sub_re;

  logic                       sign_im_add_re;
  logic                       sign_im_sub_re;

  logic        [cDAT_W-1 : 0] adat_im_add_re;
  logic        [cDAT_W-1 : 0] adat_im_sub_re;

  logic                       sign4adat_im_add_re;
  logic                       sign4adat_im_sub_re;

  logic       [cMULT_W-1 : 0] mult_im_add_re;
  logic       [cMULT_W-1 : 0] mult_im_sub_re;

  logic                       sign4mult_im_add_re;
  logic                       sign4mult_im_sub_re;

  logic        [pDAT_W-1 : 0] adat_im_add_re_scaled;
  logic        [pDAT_W-1 : 0] adat_im_sub_re_scaled;

  //------------------------------------------------------------------------------------------------------
  // count maximum metric and save signums
  //
  // C0 = abs(re)                 = -C4
  // C1 = abs(im + re)*1/sqrt(2)  = -C5
  // C2 = abs(im)                 = -C6
  // C3 = abs(im - re)*1/sqrt(2)  = -C7
  //
  // 1/sqrt(2) ~= 0.707 ~= 181/256;
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      v1sps <= '0;
      val   <= '0;
    end
    else if (iclkena) begin
      v1sps <= (v1sps << 1) | i1sps;
      val   <= (val   << 1) | ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | isop;
      eop <= (eop << 1) | ieop;
      if (i1sps) begin
        dat_re        <= idat_re;
        dat_im        <= idat_im;
        //
        dat_im_add_re <= idat_im + idat_re;
        dat_im_sub_re <= idat_im - idat_re;
      end
    end
  end

  assign sign_re        = dat_re[pDAT_W-1];
  assign sign_im        = dat_im[pDAT_W-1];
  //
  assign sign_im_add_re = dat_im_add_re[cDAT_W-1];
  assign sign_im_sub_re = dat_im_sub_re[cDAT_W-1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
//    if (v1sps[0]) begin
        adat_re             <= (dat_re ^ {pDAT_W{sign_re}}) + sign_re;
        adat_im             <= (dat_im ^ {pDAT_W{sign_im}}) + sign_im;
        //
        sign4adat_re        <= sign_re;
        sign4adat_im        <= sign_im;
        //
        adat_im_add_re      <= (dat_im_add_re ^ {cDAT_W{sign_im_add_re}}) + sign_im_add_re;
        adat_im_sub_re      <= (dat_im_sub_re ^ {cDAT_W{sign_im_sub_re}}) + sign_im_sub_re;
        //
        sign4adat_im_add_re <= sign_im_add_re;
        sign4adat_im_sub_re <= sign_im_sub_re;
//    end
      //
//    if (v1sps[1]) begin
        adat_re_reg         <= adat_re;
        sign4adat_re_reg    <= sign4adat_re;
        //
        adat_im_reg         <= adat_im;
        sign4adat_im_reg    <= sign4adat_im;
        //
        mult_im_add_re      <= adat_im_add_re * cSCALE_FACTOR;
        sign4mult_im_add_re <= sign4adat_im_add_re;
        //
        mult_im_sub_re      <= adat_im_sub_re * cSCALE_FACTOR;
        sign4mult_im_sub_re <= sign4adat_im_sub_re;
//    end
    end
  end

  assign adat_im_add_re_scaled = mult_im_add_re >> cDIV_FACTOR_W;
  assign adat_im_sub_re_scaled = mult_im_sub_re >> cDIV_FACTOR_W;

  //------------------------------------------------------------------------------------------------------
  // non linear quantizer : detect maximum metric and do sligth increase
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] max_idx;

  logic [pDAT_W-1 : 0] dat    [2];
  logic        [1 : 0] dat_idx[2];

  always_comb begin
    // layer 1
    if (adat_re_reg > adat_im_reg) begin
      dat     [0] = adat_re_reg;
      dat_idx [0] = 0;
    end
    else begin
      dat     [0] = adat_im_reg;
      dat_idx [0] = 2;
    end
    //
    if (adat_im_add_re_scaled > adat_im_sub_re_scaled) begin
      dat     [1] = adat_im_add_re_scaled;
      dat_idx [1] = 1;
    end
    else begin
      dat     [1] = adat_im_sub_re_scaled;
      dat_idx [1] = 3;
    end
    // layer 2
    max_idx = (dat[0] > dat[1]) ? dat_idx[0] : dat_idx[1];
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (v1sps[2]) begin
        osop <= sop[2];
        oeop <= eop[2];
        //
        osymb_m     [0] <=      adat_re_reg           [pDAT_W-1 -: pSYMB_M_W] + (max_idx == 0); // no any overflow here
        osymb_m_sign[0] <= sign4adat_re_reg;

        osymb_m     [1] <=      adat_im_add_re_scaled [pDAT_W-1 -: pSYMB_M_W] + (max_idx == 1);
        osymb_m_sign[1] <= sign4mult_im_add_re;

        osymb_m     [2] <=      adat_im_reg           [pDAT_W-1 -: pSYMB_M_W] + (max_idx == 2);
        osymb_m_sign[2] <= sign4adat_im_reg;

        osymb_m     [3] <=      adat_im_sub_re_scaled [pDAT_W-1 -: pSYMB_M_W] + (max_idx == 3);
        osymb_m_sign[3] <= sign4mult_im_sub_re;
      end
    end
  end

  assign o1sps = v1sps[3];
  assign oval  = val  [3];

endmodule
