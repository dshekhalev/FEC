/*



  parameter int n         = 240 ;
  parameter int check     =  30 ;
  parameter int m         =   8 ;
  parameter int irrpol    = 285 ;
  parameter int genstart  =   0 ;



  logic   rs_berlekamp__iclk                        ;
  logic   rs_berlekamp__iclkena                     ;
  logic   rs_berlekamp__ireset                      ;
  logic   rs_berlekamp__isyndrome_val               ;
  ptr_t   rs_berlekamp__isyndrome_ptr               ;
  data_t  rs_berlekamp__isyndrome       [1 : check] ;
  logic   rs_berlekamp__oloc_poly_val               ;
  data_t  rs_berlekamp__oloc_poly       [0 : errs]  ;
  data_t  rs_berlekamp__oomega_poly     [1 : errs]  ;
  ptr_t   rs_berlekamp__oloc_poly_ptr               ;
  logic   rs_berlekamp__oloc_decfail                ;



  rs_berlekamp_ribm_1p5check_by_check
  #(
    .n        ( n        ) ,
    .check    ( check    ) ,
    .m        ( m        ) ,
    .irrpol   ( irrpol   ) ,
    .genstart ( genstart )
  )
  rs_berlekamp
  (
    .iclk          ( rs_berlekamp__iclk          ) ,
    .iclkena       ( rs_berlekamp__iclkena       ) ,
    .ireset        ( rs_berlekamp__ireset        ) ,
    .isyndrome_val ( rs_berlekamp__isyndrome_val ) ,
    .isyndrome_ptr ( rs_berlekamp__isyndrome_ptr ) ,
    .isyndrome     ( rs_berlekamp__isyndrome     ) ,
    .oloc_poly_val ( rs_berlekamp__oloc_poly_val ) ,
    .oloc_poly     ( rs_berlekamp__oloc_poly     ) ,
    .oomega_poly   ( rs_berlekamp__oomega_poly   ) ,
    .oloc_poly_ptr ( rs_berlekamp__oloc_poly_ptr ) ,
    .oloc_decfail  ( rs_berlekamp__oloc_decfail  )
  );


  assign rs_berlekamp__iclk          = '0 ;
  assign rs_berlekamp__iclkena       = '0 ;
  assign rs_berlekamp__ireset        = '0 ;
  assign rs_berlekamp__isyndrome_val = '0 ;
  assign rs_berlekamp__isyndrome_ptr = '0 ;
  assign rs_berlekamp__isyndrome     = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_berlekamp_ribm_1check.sv
// Description   : reformulated inversionless berlekamp algirithm module with get result after
//                 check*(3*check/2 + 1) + 1 ticks & use only 2 GF(2^m) mult modules
//

`include "define.vh"

module rs_berlekamp_ribm_1p5check_by_check
(
  iclk          ,
  iclkena       ,
  ireset        ,
  isyndrome_val ,
  isyndrome_ptr ,
  isyndrome     ,
  oloc_poly_val ,
  oloc_poly     ,
  oomega_poly   ,
  oloc_poly_ptr ,
  oloc_decfail
);

  `include "rs_parameters.svh"
  `include "rs_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk                       ;
  input  logic   iclkena                    ;
  input  logic   ireset                     ;
  //
  input  logic   isyndrome_val              ;
  input  ptr_t   isyndrome_ptr              ;
  input  data_t  isyndrome      [1 : check] ;
  //
  output logic   oloc_poly_val              ;
  output data_t  oloc_poly      [0 : errs]  ;
  output data_t  oomega_poly    [1 : errs]  ;
  output ptr_t   oloc_poly_ptr              ;
  output logic   oloc_decfail               ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int t3 = check + errs;
  localparam int t2 = check;
  localparam int t  = errs;

  ptr_t  syndrome_ptr_latched ;

  data_t tetta      [0 : t3];
  data_t gamma      [0 : t3+1];

  data_t sigma;
  data_t kv;

  localparam int cCNT_W   = clogb2(t2 + 1);
  localparam int cTCNT_W  = clogb2(t3 + 1);

  logic [cCNT_W-1 : 0]  cnt;
  logic                 cnt_done;

  logic [cTCNT_W-1 : 0] tcnt;
  logic                 tcnt_done;

  enum bit {
    cWAIT_STATE   ,
    cSTEP1_STATE
  } state;

  //------------------------------------------------------------------------------------------------------
  // FSM
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
        cnt       <= t2; // easy to create dynamic variable check
        cnt_done  <= 1'b0;
        tcnt      <= t3;
        tcnt_done <= 1'b0;
      end
      else if (state == cSTEP1_STATE) begin
        tcnt      <= tcnt - 1'b1;
        tcnt_done <= (tcnt == 1); // [0 : t3] mult
        if (tcnt_done) begin
          tcnt      <= t3;
          cnt       <= cnt - 1'b1;
          cnt_done  <= (cnt == 2);
        end
      end
      //
      // decode process
      if (state == cWAIT_STATE) begin
        // load polynomes
        if (isyndrome_val) begin  // asynchronus mode support
          for (int i = 0; i <= t3+1; i++) gamma[i] <= (i < t2) ? isyndrome[i + 1] : (i == t3);
        end
        for (int i = 0; i <= t3; i++) tetta[i] <= (i < t2) ? isyndrome[i + 1] : (i == t3);
        // init values
        sigma         <= 1'b1;
        kv            <= 1'b0;
      end
      else if (state == cSTEP1_STATE) begin
        // gamma arithmetics
        gamma[t3] <= (tcnt_done ? {m{1'b0}} : gf_mult_a_by_b(sigma, gamma[1])) ^ gf_mult_a_by_b(gamma[0], tetta[0]);
        // tetta decision
        if ((gamma[0] != 0) & ~kv[m-1]) begin
          tetta[t3] <= tcnt_done ? {m{1'b0}} : gamma[1];
        end
        else begin
          tetta[t3] <= tetta[0];
        end
        // shift registers
        for (int i = 1; i < t3; i++) gamma[i] <= gamma[i+1];
        for (int i = 0; i < t3; i++) tetta[i] <= tetta[i+1];
        // decision
        if (tcnt_done) begin
          gamma[0] <= gamma[1];
          if ((gamma[0] != 0) & ~kv[m-1]) begin
            sigma         <= gamma[0];
            kv            <= ~kv;
          end
          else begin
            kv            <= kv + 1;
          end
        end
      end
      // done is occured when state == cWAIT_STATE
      done <= (state == cSTEP1_STATE) & cnt_done & tcnt_done;
    end // iclkena
  end

  assign oloc_poly_val = done;
  assign oloc_poly     = gamma[t : t2];
  assign oomega_poly   = gamma[0 : t-1];
  assign oloc_decfail  = 1'b0;
  assign oloc_poly_ptr = syndrome_ptr_latched;

  //------------------------------------------------------------------------------------------------------
  // logout
  //------------------------------------------------------------------------------------------------------

`ifdef __RS_BERLEKAMP_DEBUG_LOG__
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

  typedef data_t vector3_t [0 : t3];

  bit logneed;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      logneed <= (state == cSTEP1_STATE) & tcnt_done;
      if (logneed) begin
        $display("%m step %0d :: gamma_lsb %0d kv %0d", cnt, gamma[0], kv);
        vector_logout("gamma poly ", gamma[0 : t3]);
        vector_logout("tetta poly ", tetta[0 : t3]);
      end
    end
  end

  function void vector_logout (input string is, input vector3_t vector);
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
