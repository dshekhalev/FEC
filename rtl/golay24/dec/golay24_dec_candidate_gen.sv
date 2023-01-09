/*



  parameter int pIDX_NUM  = 1 ;



  logic  golay24_dec_candidate_gen__iclk              ;
  logic  golay24_dec_candidate_gen__ireset            ;
  logic  golay24_dec_candidate_gen__iclkena           ;
  logic  golay24_dec_candidate_gen__ival              ;
  dat_t  golay24_dec_candidate_gen__ich_hd            ;
  idx_t  golay24_dec_candidate_gen__iidx   [pIDX_NUM] ;
  logic  golay24_dec_candidate_gen__osop              ;
  logic  golay24_dec_candidate_gen__oval              ;
  logic  golay24_dec_candidate_gen__oeop              ;
  dat_t  golay24_dec_candidate_gen__odat              ;



  golay24_dec_candidate_gen
  #(
    .pIDX_NUM ( pIDX_NUM )
  )
  golay24_dec_candidate_gen
  (
    .iclk    ( golay24_dec_candidate_gen__iclk    ) ,
    .ireset  ( golay24_dec_candidate_gen__ireset  ) ,
    .iclkena ( golay24_dec_candidate_gen__iclkena ) ,
    .ival    ( golay24_dec_candidate_gen__ival    ) ,
    .ich_hd  ( golay24_dec_candidate_gen__ich_hd  ) ,
    .iidx    ( golay24_dec_candidate_gen__iidx    ) ,
    .osop    ( golay24_dec_candidate_gen__osop    ) ,
    .oval    ( golay24_dec_candidate_gen__oval    ) ,
    .oeop    ( golay24_dec_candidate_gen__oeop    ) ,
    .odat    ( golay24_dec_candidate_gen__odat    )
  );


  assign golay24_dec_candidate_gen__iclk    = '0 ;
  assign golay24_dec_candidate_gen__ireset  = '0 ;
  assign golay24_dec_candidate_gen__iclkena = '0 ;
  assign golay24_dec_candidate_gen__ival    = '0 ;
  assign golay24_dec_candidate_gen__ich_hd  = '0 ;
  assign golay24_dec_candidate_gen__iidx    = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_dec_candidate_gen.sv
// Description   : unit to generare candidates based upon channel hard decision and less reliable LLR indexes
//


module golay24_dec_candidate_gen
#(
  parameter int pIDX_NUM  = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  ich_hd  ,
  iidx    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk              ;
  input  logic  ireset            ;
  input  logic  iclkena           ;
  //
  input  logic  ival              ;
  input  dat_t  ich_hd            ;   // channel hard decision
  input  idx_t  iidx   [pIDX_NUM] ;   // least reliable LLRs indexes
  //
  output logic  osop              ;
  output logic  oval              ;
  output logic  oeop              ;
  output dat_t  odat              ;   // candidates

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [pIDX_NUM : 0] cnt_t;

  cnt_t cnt;
  dat_t ch_hd;
  dat_t ch_hd2cand;
  dat_t error_mask [pIDX_NUM];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  wire do_work = cnt[pIDX_NUM];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osop  <= 1'b0;
      oval  <= 1'b0;
      oeop  <= 1'b0;
      cnt   <= '0;
    end
    else if (iclkena) begin
      oval <= ival | do_work;
      osop <= ival ;
      oeop <= &cnt[pIDX_NUM-1 : 0];
      //
      if (ival) begin
        cnt <= (1'b1 << pIDX_NUM);
      end
      else if (do_work) begin
        cnt <= cnt + 1'b1;
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
//      ch_hd       <= ich_hd;
        ch_hd2cand  <= ich_hd & ~get_errors_mask(iidx);
        odat        <= ich_hd;
        for (int i = 0; i < pIDX_NUM; i++) begin
          error_mask[i] = get_error_mask(iidx[i]);
        end
      end
      else if (do_work) begin
//      odat  <= (ch_hd & ~assemble_error_mask(error_mask)) | assemble_error_vector(error_mask, cnt);
        odat  <= ch_hd2cand | assemble_error_vector(error_mask, cnt);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function automatic dat_t get_error_mask (input idx_t idx);
    get_error_mask = (24'h1 << idx);
  endfunction

  function automatic dat_t get_errors_mask (input idx_t idx [pIDX_NUM]);
    get_errors_mask = 0;
    for (int i = 0; i < pIDX_NUM; i++) begin
      get_errors_mask = get_errors_mask | get_error_mask(idx[i]);
    end
  endfunction

  function automatic dat_t assemble_error_mask (input dat_t error_mask [pIDX_NUM]);
    assemble_error_mask = 0;
    for (int i = 0; i < pIDX_NUM; i++) begin
      assemble_error_mask = assemble_error_mask | error_mask[i];
    end
  endfunction

  function automatic dat_t assemble_error_vector (input dat_t error_mask [pIDX_NUM], cnt_t cnt);
    assemble_error_vector = 0;
    for (int i = 0; i < pIDX_NUM; i++) begin
      if (cnt[i]) begin
        assemble_error_vector = assemble_error_vector | error_mask[i];
      end
    end
  endfunction

endmodule
