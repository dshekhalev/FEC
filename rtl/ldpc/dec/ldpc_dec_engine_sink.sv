/*



  parameter int pLLR_BY_CYCLE   = 1 ;
  parameter int pNODE_BY_CYCLE  = 1 ;
  parameter int pIERR_W         = 1 ;
  parameter int pODAT_W         = 1 ;
  parameter int pOERR_W         = 1 ;
  parameter int pADDR_W         = 1 ;
  parameter int pTAG_W          = 1 ;



  logic                       ldpc_dec_engine_sink__iclk                      ;
  logic                       ldpc_dec_engine_sink__ireset                    ;
  logic                       ldpc_dec_engine_sink__iclkena                   ;
  logic                       ldpc_dec_engine_sink__ibitsop                   ;
  logic                       ldpc_dec_engine_sink__ibitval                   ;
  logic                       ldpc_dec_engine_sink__ibiteop                   ;
  logic [pLLR_BY_CYCLE-1 : 0] ldpc_dec_engine_sink__ibitdat  [pNODE_BY_CYCLE] ;
  logic       [pIERR_W-1 : 0] ldpc_dec_engine_sink__ibiterr                   ;
  logic                       ldpc_dec_engine_sink__idecfail                  ;
  logic        [pTAG_W-1 : 0] ldpc_dec_engine_sink__itag                      ;
  logic                       ldpc_dec_engine_sink__osop                      ;
  logic                       ldpc_dec_engine_sink__oval                      ;
  logic                       ldpc_dec_engine_sink__oeop                      ;
  logic       [pADDR_W-1 : 0] ldpc_dec_engine_sink__oaddr                     ;
  logic        [pTAG_W-1 : 0] ldpc_dec_engine_sink__otag                      ;
  logic       [pODAT_W-1 : 0] ldpc_dec_engine_sink__odat     [pNODE_BY_CYCLE] ;
  logic                       ldpc_dec_engine_sink__odecfail                  ;
  logic       [pOERR_W-1 : 0] ldpc_dec_engine_sink__oerr                      ;



  ldpc_dec_engine_sink
  #(
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pIERR_W        ( pIERR_W        ) ,
    .pODAT_W        ( pODAT_W        ) ,
    .pOERR_W        ( pOERR_W        ) ,
    .pADDR_W        ( pADDR_W        ) ,
    .pTAG_W         ( pTAG_W         )
  )
  ldpc_dec_engine_sink
  (
    .iclk     ( ldpc_dec_engine_sink__iclk     ) ,
    .ireset   ( ldpc_dec_engine_sink__ireset   ) ,
    .iclkena  ( ldpc_dec_engine_sink__iclkena  ) ,
    .ibitsop  ( ldpc_dec_engine_sink__ibitsop  ) ,
    .ibitval  ( ldpc_dec_engine_sink__ibitval  ) ,
    .ibiteop  ( ldpc_dec_engine_sink__ibiteop  ) ,
    .ibitdat  ( ldpc_dec_engine_sink__ibitdat  ) ,
    .ibiterr  ( ldpc_dec_engine_sink__ibiterr  ) ,
    .idecfail ( ldpc_dec_engine_sink__idecfail ) ,
    .itag     ( ldpc_dec_engine_sink__itag     ) ,
    .osop     ( ldpc_dec_engine_sink__osop     ) ,
    .oval     ( ldpc_dec_engine_sink__oval     ) ,
    .oeop     ( ldpc_dec_engine_sink__oeop     ) ,
    .oaddr    ( ldpc_dec_engine_sink__oaddr    ) ,
    .otag     ( ldpc_dec_engine_sink__otag     ) ,
    .odat     ( ldpc_dec_engine_sink__odat     ) ,
    .odecfail ( ldpc_dec_engine_sink__odecfail ) ,
    .oerr     ( ldpc_dec_engine_sink__oerr     )
  );


  assign ldpc_dec_engine_sink__iclk     = '0 ;
  assign ldpc_dec_engine_sink__ireset   = '0 ;
  assign ldpc_dec_engine_sink__iclkena  = '0 ;
  assign ldpc_dec_engine_sink__ibitsop  = '0 ;
  assign ldpc_dec_engine_sink__ibitval  = '0 ;
  assign ldpc_dec_engine_sink__ibiteop  = '0 ;
  assign ldpc_dec_engine_sink__ibitdat  = '0 ;
  assign ldpc_dec_engine_sink__ibiterr  = '0 ;
  assign ldpc_dec_engine_sink__idecfail = '0 ;
  assign ldpc_dec_engine_sink__itag     = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_engine_sink.sv
// Description   : data width conversion engine for LDPC decoder output.
//                 work in 3 cases:
//                  1. pODAT_W ==           pLLR_BY_CYCLE - no any DWC
//                  2. pODAT_W == integer * pLLR_BY_CYCLE - integer DWC simple shift register based
//                  3. pODAT_W ==  fract  * pLLR_BY_CYCLE - complex DWC mux based
//                 constraints:
//                  pODAT_W >= pLLR_BY_CYCLE
//                  pLLR_BY_CYCLE must be multuply of pZF
//                  pNODE_BY_CYCLE must be multuply of pT
//                  pODAT_W must be multuply of pZF * pT/pNODE_BY_CYCLE
//

`include "define.vh"

module ldpc_dec_engine_sink
#(
  parameter int pLLR_BY_CYCLE   =             2 ,
  parameter int pNODE_BY_CYCLE  =             1 ,
  parameter int pIERR_W         =             8 ,
  //
  parameter int pODAT_W         = pLLR_BY_CYCLE ,
  parameter int pOERR_W         =            16 ,
  parameter int pADDR_W         =             8 ,
  parameter int pTAG_W          = 1
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  ibitsop  ,
  ibitval  ,
  ibiteop  ,
  ibitdat  ,
  ibiterr  ,
  //
  idecfail ,
  itag     ,
  //
  osop     ,
  oval     ,
  oeop     ,
  oaddr    ,
  otag     ,
  odat     ,
  //
  odecfail ,
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                      ;
  input  logic                       ireset                    ;
  input  logic                       iclkena                   ;
  //
  input  logic                       ibitsop                   ;
  input  logic                       ibitval                   ;
  input  logic                       ibiteop                   ;
  input  logic [pLLR_BY_CYCLE-1 : 0] ibitdat  [pNODE_BY_CYCLE] ;
  input  logic       [pIERR_W-1 : 0] ibiterr                   ;
  //
  input  logic                       idecfail                  ;
  input  logic        [pTAG_W-1 : 0] itag                      ;
  //
  output logic                       osop                      ;
  output logic                       oval                      ;
  output logic                       oeop                      ;
  output logic       [pADDR_W-1 : 0] oaddr                     ;
  output logic        [pTAG_W-1 : 0] otag                      ;
  output logic       [pODAT_W-1 : 0] odat     [pNODE_BY_CYCLE] ;
  //
  output logic                       odecfail                  ;
  output logic       [pOERR_W-1 : 0] oerr                      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam bit cNO_DWC              = (pODAT_W == pLLR_BY_CYCLE);

  localparam int cINT_DWC_FACTOR      = pODAT_W/pLLR_BY_CYCLE;

  localparam bit cINT_DWC             = (pODAT_W == (pLLR_BY_CYCLE * cINT_DWC_FACTOR));

  localparam int cLOG2_INT_DWC_FACTOR = clogb2(cINT_DWC_FACTOR);

  localparam int cFRAC_DWC_CNT_W      = clogb2(pODAT_W) + 1;  // + 1 bit for overflow

  localparam int cFRAC_BIT_BUFFER_W   = pODAT_W + pLLR_BY_CYCLE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (cNO_DWC) begin

      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          oval <= 1'b0;
        end
        else if (iclkena) begin
          oval <= ibitval;
        end
      end
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          osop <= ibitsop;
          oeop <= ibiteop;
          if (ibitval) begin
            oaddr <= ibitsop ? '0 : (oaddr + 1'b1);
            odat  <= ibitdat;
            //
            oerr  <= ibitsop ? ibiterr : (oerr + ibiterr);
            //
            if (ibitsop) begin
              otag      <= itag;
              odecfail  <= idecfail;
            end
          end
        end
      end

    end
    else if (cINT_DWC) begin

      struct packed {
        logic [cLOG2_INT_DWC_FACTOR-1 : 0] val;
        logic                              done;
      } dwc_cnt;

      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          oval <= 1'b0;
        end
        else if (iclkena) begin
          oval <= ibitval & !ibitsop & dwc_cnt.done;
        end
      end
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ibitval) begin
            if (ibitsop) begin
              dwc_cnt.val   <= 1'b1;
              dwc_cnt.done  <= (cINT_DWC_FACTOR == 2);
            end
            else begin
              dwc_cnt.val   <=  dwc_cnt.done ? '0 : (dwc_cnt.val + 1'b1);
              dwc_cnt.done  <= (dwc_cnt.val == cINT_DWC_FACTOR-2);
            end
          end
          //
          if (ibitsop & ibitval) begin
            osop <= 1'b1;
          end
          else if (oval) begin
            osop <= 1'b0;
          end
          //
          oeop <= ibiteop & ibitval;
          //
          if (ibitval & ibitsop) begin
            oaddr <= '0;
          end
          else if (oval) begin
            oaddr <= oaddr + 1'b1;
          end
          //
          if (ibitval) begin
            for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
              odat[n] <= {ibitdat[n], odat[n][pODAT_W-1 : pLLR_BY_CYCLE]};
            end
            //
            oerr  <= ibitsop ? ibiterr : (oerr + ibiterr);
            //
            if (ibitsop) begin
              otag      <= itag;
              odecfail  <= idecfail;
            end
          end
        end
      end

    end
    else begin

      logic [cFRAC_DWC_CNT_W-1 : 0] dwc_cnt;
      logic                         dwc_cnt_done;

      logic [cFRAC_BIT_BUFFER_W-1 : 0] bitdat_buffer [pNODE_BY_CYCLE] ;

      logic                 sop     ;
      logic                 val     ;
      logic                 eop     ;
      logic [pADDR_W-1 : 0] addr    ;
      logic  [pTAG_W-1 : 0] tag     ;

      logic [pOERR_W-1 : 0] err     ;
      logic                 decfail ;

      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          val   <= 1'b0;
        end
        else if (iclkena) begin
          val <= ibitval & !ibitsop;
        end
      end
      //
      assign dwc_cnt_done = (dwc_cnt >= pODAT_W);
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ibitval) begin
            if (ibitsop) begin
              dwc_cnt <= pLLR_BY_CYCLE;
            end
            else begin
              dwc_cnt <= dwc_cnt_done ? (dwc_cnt + pLLR_BY_CYCLE - pODAT_W) : (dwc_cnt + pLLR_BY_CYCLE);
            end
          end
          else if (dwc_cnt_done) begin
            dwc_cnt <= (dwc_cnt - pODAT_W);
          end
          //
          if (ibitsop & ibitval) begin
            sop <= 1'b1;
          end
          else if (val & dwc_cnt_done) begin
            sop <= 1'b0;
          end
          //
          eop <= ibiteop & ibitval;
          //
          if (ibitval & ibitsop) begin
            addr <= '0;
          end
          else if (val & dwc_cnt_done) begin
            addr <= addr + 1'b1;
          end
          //
          if (ibitval) begin
            for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
              bitdat_buffer[n] <= {ibitdat[n], bitdat_buffer[n][cFRAC_BIT_BUFFER_W-1 : pLLR_BY_CYCLE]};
            end
            err <= ibitsop ? ibiterr : (oerr + ibiterr);
            if (ibitsop) begin
              tag      <= itag;
              decfail  <= idecfail;
            end
          end
        end
      end
      //
      //
      //
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          osop <= 1'b0;
          oval <= 1'b0;
          oeop <= 1'b0;
        end
        else if (iclkena) begin
          osop <= sop;
          oval <= val & dwc_cnt_done;
          oeop <= eop;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          oaddr     <= addr;
          //
          odecfail  <= decfail;
          otag      <= tag;
          //
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-1 -: pODAT_W];
            case (dwc_cnt - pODAT_W)
              1 : begin
                odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-2 -: pODAT_W];
              end
              2 : begin
                odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-3 -: pODAT_W];
              end
              3 : begin
                if (pLLR_BY_CYCLE >= 3) begin
                  odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-4 -: pODAT_W];
                end
              end
              4 : begin
                if (pLLR_BY_CYCLE >= 4) begin
                  odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-5 -: pODAT_W];
                end
              end
              5 : begin
                if (pLLR_BY_CYCLE >= 5) begin
                  odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-6 -: pODAT_W];
                end
              end
              6 : begin
                if (pLLR_BY_CYCLE >= 6) begin
                  odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-7 -: pODAT_W];
                end
              end
              7 : begin
                if (pLLR_BY_CYCLE >= 7) begin
                  odat[n] <= bitdat_buffer[n][cFRAC_BIT_BUFFER_W-8 -: pODAT_W];
                end
              end
            endcase
          end
        end
      end

    end
  endgenerate



endmodule
