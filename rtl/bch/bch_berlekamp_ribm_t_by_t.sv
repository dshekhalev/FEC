/*



  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;



  logic   bch_berlekamp__iclk                     ;
  logic   bch_berlekamp__ireset                   ;
  logic   bch_berlekamp__iclkena                  ;
  logic   bch_berlekamp__isyndrome_val            ;
  ptr_t   bch_berlekamp__isyndrome_ptr            ;
  data_t  bch_berlekamp__isyndrome       [1 : t2] ;
  logic   bch_berlekamp__oloc_poly_val            ;
  data_t  bch_berlekamp__oloc_poly        [0 : t] ;
  ptr_t   bch_berlekamp__oloc_poly_ptr            ;
  logic   bch_berlekamp__oloc_decfail             ;



  bch_berlekamp_ribm_t_by_t
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  bch_berlekamp
  (
    .iclk          ( bch_berlekamp__iclk          ) ,
    .iclkena       ( bch_berlekamp__iclkena       ) ,
    .ireset        ( bch_berlekamp__ireset        ) ,
    .isyndrome_val ( bch_berlekamp__isyndrome_val ) ,
    .isyndrome_ptr ( bch_berlekamp__isyndrome_ptr ) ,
    .isyndrome     ( bch_berlekamp__isyndrome     ) ,
    .oloc_poly_val ( bch_berlekamp__oloc_poly_val ) ,
    .oloc_poly     ( bch_berlekamp__oloc_poly     ) ,
    .oomega_poly   ( bch_berlekamp__oomega_poly   ) ,
    .oloc_poly_ptr ( bch_berlekamp__oloc_poly_ptr ) ,
    .oloc_decfail  ( bch_berlekamp__oloc_decfail  )
  );


  assign bch_berlekamp__iclk          = '0 ;
  assign bch_berlekamp__ireset        = '0 ;
  assign bch_berlekamp__iclkena       = '0 ;
  assign bch_berlekamp__isyndrome_val = '0 ;
  assign bch_berlekamp__isyndrome_ptr = '0 ;
  assign bch_berlekamp__isyndrome     = '0 ;




*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_berlekamp_ribm_t_by_t.sv
// Description   : reformulated inversionless berlekamp algirithm module with get result after t*(t2 + 1) + 1 ticks
//                 module use only 2 GF(2^m) mult modules
//

`include "define.vh"

module bch_berlekamp_ribm_t_by_t
(
  iclk          ,
  iclkena       ,
  ireset        ,
  isyndrome_val ,
  isyndrome_ptr ,
  isyndrome     ,
  oloc_poly_val ,
  oloc_poly     ,
  oloc_poly_ptr ,
  oloc_decfail
);

  `include "bch_parameters.svh"
  `include "bch_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk                    ;
  input  logic   ireset                  ;
  input  logic   iclkena                 ;
  //
  input  logic   isyndrome_val           ;
  input  ptr_t   isyndrome_ptr           ;
  input  data_t  isyndrome      [1 : t2] ;
  //
  output logic   oloc_poly_val           ;
  output data_t  oloc_poly      [0 : t]  ;
  output ptr_t   oloc_poly_ptr           ;
  output logic   oloc_decfail            ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ptr_t  syndrome_ptr_latched ;

  data_t tetta       [0 : t2+1];
  logic  tetta_clear [0 : t2+2];

  data_t gamma       [0 : t2+2];

  data_t sigma;
  data_t kv;

  localparam int cCNT_W   = clogb2(t + 1);
  localparam int cTCNT_W  = clogb2(t2 + 1);

  logic [cCNT_W-1 : 0]  cnt;
  logic                 cnt_done;

  logic [cTCNT_W-1 : 0] tcnt;
  logic                 tcnt_done;
  logic                 tcnt_mask;

  enum bit {
    cWAIT_STATE   ,
    cSTEP1_STATE
  } state;

  //------------------------------------------------------------------------------------------------------
  //  FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cWAIT_STATE;
    end
    else if (iclkena) begin
      case (state)
        cWAIT_STATE  : state <= isyndrome_val           ? cSTEP1_STATE  : cWAIT_STATE;
        cSTEP1_STATE : state <= (cnt_done & tcnt_done)  ? cWAIT_STATE   : cSTEP1_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Berlekamp logic
  //------------------------------------------------------------------------------------------------------

  logic done = 1'b0;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // capture pointer linked with used syndrome
      if (state == cWAIT_STATE & isyndrome_val) begin
        syndrome_ptr_latched <= isyndrome_ptr;
      end
      //
      // cycle counter for count [1 : t2] cycles
      if (state == cWAIT_STATE) begin
        cnt       <= t;     // easy to create dynamic variable check
        cnt_done  <= (t < 2);
        tcnt      <= t2;
        tcnt_done <= 1'b0;
        tcnt_mask <= 1'b0;
      end
      else if (state == cSTEP1_STATE) begin
        tcnt      <= tcnt - 1'b1;
        tcnt_done <= (tcnt == 1); // [0 : t2] mult
        tcnt_mask <= (tcnt == 1) | (tcnt == 2);
        if (tcnt_done) begin
          tcnt      <= t2;
          cnt       <= cnt - 1'b1;
          cnt_done  <= (cnt == 2);
        end
      end
      //
      // decode process
      if (state == cWAIT_STATE) begin
        // load polynomes
        if (isyndrome_val) begin // asynchronus mode support
          for (int i = 0; i <= t2+2; i++) gamma[i] <= ((i < t2-1) & ~i[0]) ? isyndrome[i+1] : (i == t2);
        end
        for (int i = 0; i <= t2+1; i++)   tetta[i] <= ((i < t2-1) &  i[0]) ? isyndrome[i+1] : (i == t2);
        //
        for (int i = 0; i <= t2+2; i++)   tetta_clear[i] <= (i == t2-4) | (i == t2-3);
        // init values
        sigma       <= 1'b1;
        kv          <= 1'b0;
      end
      else if (state == cSTEP1_STATE) begin
        // gamma arithmetics
        gamma[t2]  <= (tcnt_mask ? {m{1'b0}} : gf_mult_a_by_b(sigma, gamma[2])) ^ gf_mult_a_by_b(gamma[0], tetta[1]);
        // tetta decision
        if ((gamma[0] != 0) & ~kv[m-1]) begin
          tetta[t2] <= tetta_clear[0] ? '0 : (gamma [1] & {m{~tcnt_done}});
        end
        else begin
          tetta[t2] <= tetta_clear[0] ? '0 : tetta [0];
        end
        // shift registers
        for (int i = 1; i < t2; i++) gamma[i] <= gamma[i+1];
        for (int i = 0; i < t2; i++) tetta[i] <= tetta[i+1];
        // tetta_clear shift
        for (int i = 0; i <= t2; i++) begin
          if (tcnt_done) begin // round shift one position + shift left 2 position
            tetta_clear[i] <= (i < t2-2) ? tetta_clear[i+3] : ((i == t2) ? tetta_clear[0] : '0);
          end
          else begin            // round shift one position
            tetta_clear[i] <= (i == t2) ? tetta_clear[0] : tetta_clear[i+1];
          end
        end
        // decision
        if (tcnt_done) begin
          gamma[0] <= gamma[1];
          if ((gamma[0] != 0) & ~kv[m-1]) begin
            sigma <= gamma[0];
            kv    <= -kv;
          end
          else begin
            kv    <= kv + 2;
          end
        end
      end
      // done is occured when state == cWAIT_STATE
      done <= (state == cSTEP1_STATE) & cnt_done & tcnt_done;
    end // iclkena
  end

  assign oloc_poly_val = done;
  assign oloc_poly     = gamma[0 : t];
  assign oloc_decfail  = 1'b0;
  assign oloc_poly_ptr = syndrome_ptr_latched;

  //------------------------------------------------------------------------------------------------------
  // logout
  //------------------------------------------------------------------------------------------------------

`ifdef __BCH_BERLEKAMP_DEBUG_LOG__
  // synthesis translate_off
  always_ff @(posedge iclk) begin
    string str, s;
    if (iclkena) begin
      if (isyndrome_val) begin
        $sformat(str, "%m get syndromes : ");
        for (int i = 1; i <= t2; i++) begin
          $sformat(s, " %d", isyndrome[i]);
          str = {str, s};
        end
        $display(str);
      end
    end
  end

  typedef data_t vector_t [0 : t2];

  bit logneed;
  bit tdone;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      logneed <= (state == cSTEP1_STATE & tcnt_done) | (state == cWAIT_STATE & isyndrome_val);
      tdone   <= tcnt_done;
      if (logneed) begin
        $display("%m step %0d :: gamma_lsb %0d sigma %0d, kv %0d done %0b", cnt, gamma[0], sigma, $signed(kv), tdone);
        vector_logout("gamma poly\t",   gamma[0 : t2]);
        vector_logout("tetta poly\t",   tetta[0 : t2]);
        vector_logout("tettc poly\t",   tetta_clear[0 : t2]);
      end
    end
  end

  function void vector_logout (input string is, input vector_t vector);
    string str, s;
  begin
    str = is;
    foreach (vector[i]) begin
      $sformat(s, " %d", vector[i]);
      str = {str, s};
    end
    $display(str);
  end
  endfunction
  // synthesis translate_on
`endif

endmodule
