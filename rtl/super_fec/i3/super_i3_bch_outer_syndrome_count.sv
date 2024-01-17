/*






  logic      super_i3_bch_outer_syndrome_count__iclk                              ;
  logic      super_i3_bch_outer_syndrome_count__ireset                            ;
  logic      super_i3_bch_outer_syndrome_count__iclkena                           ;
  //
  logic      super_i3_bch_outer_syndrome_count__isop                              ;
  logic      super_i3_bch_outer_syndrome_count__ival                              ;
  ram_dat_t  super_i3_bch_outer_syndrome_count__idat                              ;
  //
  ram_addr_t super_i3_bch_outer_syndrome_count__oram_waddr                        ;
  logic      super_i3_bch_outer_syndrome_count__oram_wptr                         ;
  dat_t      super_i3_bch_outer_syndrome_count__oram_wdat     [cDEC_NUM]          ;
  logic      super_i3_bch_outer_syndrome_count__oram_write                        ;
  //
  logic      super_i3_bch_outer_syndrome_count__osyndrome_val                     ;
  logic      super_i3_bch_outer_syndrome_count__osyndrome_ptr                     ;
  gf_dat_t   super_i3_bch_outer_syndrome_count__osyndrome     [cDEC_NUM][1 : cT2] ;



  super_i3_bch_outer_syndrome_count
  super_i3_bch_outer_syndrome_count
  (
    .iclk          ( super_i3_bch_outer_syndrome_count__iclk          ) ,
    .ireset        ( super_i3_bch_outer_syndrome_count__ireset        ) ,
    .iclkena       ( super_i3_bch_outer_syndrome_count__iclkena       ) ,
    //
    .isop          ( super_i3_bch_outer_syndrome_count__isop          ) ,
    .ival          ( super_i3_bch_outer_syndrome_count__ival          ) ,
    .idat          ( super_i3_bch_outer_syndrome_count__idat          ) ,
    //
    .oram_waddr    ( super_i3_bch_outer_syndrome_count__oram_waddr    ) ,
    .oram_wptr     ( super_i3_bch_outer_syndrome_count__oram_wptr     ) ,
    .oram_wdat     ( super_i3_bch_outer_syndrome_count__oram_wdat     ) ,
    .oram_write    ( super_i3_bch_outer_syndrome_count__oram_write    ) ,
    //
    .osyndrome_val ( super_i3_bch_outer_syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( super_i3_bch_outer_syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( super_i3_bch_outer_syndrome_count__osyndrome     )
  );


  assign super_i3_bch_outer_syndrome_count__iclk    = '0 ;
  assign super_i3_bch_outer_syndrome_count__ireset  = '0 ;
  assign super_i3_bch_outer_syndrome_count__iclkena = '0 ;
  assign super_i3_bch_outer_syndrome_count__isop    = '0 ;
  assign super_i3_bch_outer_syndrome_count__ival    = '0 ;
  assign super_i3_bch_outer_syndrome_count__idat    = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_outer_syndrome_count.sv
// Description   : I.3 outer BCH (3860,3824) decoder array syndrome counter
//                 with input framer from "BCH(3860,3824) frame format" to 8 BCH(3860,3824) codeword native format
//

module super_i3_bch_outer_syndrome_count
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  isop          ,
  ival          ,
  idat          ,
  //
  oram_waddr    ,
  oram_wptr     ,
  oram_wdat     ,
  oram_write    ,
  //
  osyndrome_val ,
  osyndrome_ptr ,
  osyndrome
);

  `include "super_i3_bch_outer_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk                              ;
  input  logic      ireset                            ;
  input  logic      iclkena                           ;
  //
  input  logic      isop                              ;
  input  logic      ival                              ;
  input  ram_dat_t  idat                              ;
  //
  output ram_addr_t oram_waddr                        ;
  output logic      oram_wptr                         ;
  output dat_t      oram_wdat     [cDEC_NUM]          ;
  output logic      oram_write                        ;
  //
  output logic      osyndrome_val                     ;
  output logic      osyndrome_ptr                     ;
  output gf_dat_t   osyndrome     [cDEC_NUM][1 : cT2] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // alpha types
  gf_dat_t alpha__odat                 [0 : cT2];

  // syndrome vectors
  logic    syndrome_engine__isop       [cDEC_NUM][1 : cT2];
  dat_t    syndrome_engine__idat       [cDEC_NUM][1 : cT2];
  dat_t    syndrome_engine__idat_mask  [cDEC_NUM][1 : cT2];
  gf_dat_t syndrome_engine__ialpha     [cDEC_NUM][1 : cT2];
  gf_dat_t syndrome_engine__isyndrome  [cDEC_NUM][1 : cT2];
  gf_dat_t syndrome_engine__osyndrome  [cDEC_NUM][1 : cT2];

  logic     sop;
  logic     eop;
  logic     val;
  ram_dat_t dat;

  dat_t     dat2dec     [cDEC_NUM];
  dat_t     dat2dec_mask          ;

  ram_addr_t cnt;
  logic      ptr = '0; // can be any

  //------------------------------------------------------------------------------------------------------
  // generate first roots for GF
  //------------------------------------------------------------------------------------------------------

  gf_alpha
  #(
    .m      ( cM      ) ,
    .irrpol ( cIRRPOL ) ,
    .n      ( cT2 + 1 )
  )
  gf_alpha
  (
    .odat ( alpha__odat )
  );

  //------------------------------------------------------------------------------------------------------
  // framer ctrl
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
    end
    else if (iclkena) begin
      val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= isop;
      dat <= idat;
      eop <= ival & !isop & (cnt == cEOF_EDGE-2);
      //
      if (ival) begin
        ptr <= ptr + isop;
        cnt <= isop ? '0 : (cnt + 1'b1);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // framer datapath : get codeword native format
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    dat2dec_mask = '1;
    for (int d = 0; d < cDEC_NUM; d++) begin
      for (int i = 0; i < cDAT_W; i++) begin
        dat2dec[d][i] = dat[i*cDEC_NUM + d];
      end
    end
    // last word (128 bit) differ LSB first
    if (eop) begin
      dat2dec_mask = 16'h0303;
      for (int d = 0; d < cDEC_NUM; d++) begin
        dat2dec[d] = dat[d*cDAT_W +: cDAT_W];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram write in bch codeword native format
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oram_write <= val;
      oram_wptr  <= ptr;
      oram_waddr <= cnt;
      oram_wdat  <= dat2dec;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // syndromes
  //------------------------------------------------------------------------------------------------------

  genvar gd, gt;

  generate
    for (gd = 0; gd < cDEC_NUM; gd++) begin
      for (gt = 1; gt <= cT2; gt++) begin
        gf_syndrome_engine
        #(
          .m      ( cM      ) ,
          .irrpol ( cIRRPOL ) ,
          //
          .pDAT_W ( cDAT_W  )
        )
        syndrome_engine
        (
          .isop      ( syndrome_engine__isop      [gd][gt] ) ,
          .idat      ( syndrome_engine__idat      [gd][gt] ) ,
          .idat_mask ( syndrome_engine__idat_mask [gd][gt] ) ,
          .ialpha    ( syndrome_engine__ialpha    [gd][gt] ) ,
          .isyndrome ( syndrome_engine__isyndrome [gd][gt] ) ,
          .osyndrome ( syndrome_engine__osyndrome [gd][gt] )
        );

        assign syndrome_engine__isop      [gd][gt] = sop;
        assign syndrome_engine__idat      [gd][gt] = dat2dec      [gd]    ;
        assign syndrome_engine__idat_mask [gd][gt] = dat2dec_mask         ;
        assign syndrome_engine__ialpha    [gd][gt] = alpha__odat      [gt];
        assign syndrome_engine__isyndrome [gd][gt] = osyndrome    [gd][gt];

        always_ff @(posedge iclk) begin
          if (iclkena) begin
            if (val) begin
              osyndrome[gd][gt] <= syndrome_engine__osyndrome[gd][gt];
            end
          end
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osyndrome_val <= 1'b0;
    end
    else begin
      osyndrome_val <= val & eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osyndrome_ptr <= ptr;
    end
  end

endmodule
