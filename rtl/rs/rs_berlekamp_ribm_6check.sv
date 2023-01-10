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



  rs_berlekamp_ribm_6check
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
// Workfile      : rs_berlekamp_ribm_6check.sv
// Description   : reformulated inversionless berlekamp algirithm module with get result after 6*check + 1 ticks
//                 module use check/2+1 GF(2^m) mult modules
//

`include "define.vh"

module rs_berlekamp_ribm_6check
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

  data_t gamma      [0 : t3];
  data_t gamma_zero;

  data_t gamma_reg  [1 : t+1];

  data_t sigma;
  data_t kv;

  localparam int cCNT_W = clogb2(check + 1);

  logic [cCNT_W-1 : 0]  cnt;
  logic                 cnt_done;

  enum bit [1 : 0] {
    cWAIT_STATE  ,
    cSTEP1_STATE ,
    cSTEP2_STATE ,
    cSTEP3_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic   ff;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cWAIT_STATE;
    end
    else if (iclkena) begin
      case (state)
        cWAIT_STATE  : state <= isyndrome_val ? cSTEP1_STATE                            : cWAIT_STATE;
        cSTEP1_STATE : state <= ff            ? cSTEP2_STATE                            : cSTEP1_STATE;
        cSTEP2_STATE : state <= ff            ? cSTEP3_STATE                            : cSTEP2_STATE;
        cSTEP3_STATE : state <= ff            ? (cnt_done ? cWAIT_STATE : cSTEP1_STATE) : cSTEP3_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Berlekamp logic
  //------------------------------------------------------------------------------------------------------

  logic done = 0;

  logic bm_decision = 0;

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
      end
      else if (state == cSTEP3_STATE & ff) begin
        cnt       <= cnt - 1'b1;
        cnt_done  <= (cnt == 2);
      end
      //
      ff <= (state == cWAIT_STATE) ? 1'b0 : !ff;
      //
      bm_decision <= (gamma_zero != 0) & ~kv[m-1];  // have enougth time for this

      unique case (state)
        cWAIT_STATE :  begin
          // load polynomes
          if (isyndrome_val) begin // asynchronus mode support
            for (int i = 0; i <= t3; i++) gamma[i] <= (i < t2) ? isyndrome[i + 1] : (i == t3);
          end
          for (int i = 0; i <= t3; i++) tetta[i] <= (i < t2) ? isyndrome[i + 1] : (i == t3);
          // init values
          gamma_zero  <= isyndrome[1];
          sigma       <= 1'b1;
          kv          <= 1'b0;
        end

        cSTEP1_STATE : begin
          gamma[0]        <= (gamma[0]      & {m{ff}}) ^ gf_mult_a_by_b(~ff ? sigma         : gamma_zero,
                                                                        ~ff ? gamma[1]      : tetta[0]    );
          for (int i = 1; i <= t; i++) begin
            gamma[t2 + i] <= (gamma[t2 + i] & {m{ff}}) ^ gf_mult_a_by_b(~ff ? sigma         : gamma_zero,
                                                                        ~ff ? gamma[i + 1]  : tetta[i]    );
          end

          if (~ff) begin
            gamma_reg[1]        <= gamma[1];
            gamma[1 : t2]       <= gamma[t+1 : t3];
            gamma_reg[2 : t+1]  <= gamma[2 : t+1];
          end

          if (ff) begin
            tetta[0]        <= bm_decision ? gamma_reg[1]      : tetta[0];
            tetta[1 : t2]   <= tetta[t+1 : t3];
            for (int i = 1; i <= t; i++) begin
              tetta[t2 + i] <= bm_decision ? gamma_reg[i + 1]  : tetta[i];
            end
          end
        end

        //
        cSTEP2_STATE : begin
          for (int i = 1; i <= t; i++) begin
            gamma[t2 + i] <= (gamma[t2 + i] & {m{ff}}) ^ gf_mult_a_by_b(~ff ? sigma         : gamma_zero,
                                                                        ~ff ? gamma[i + 1]  : tetta[i]    );
          end

          if (~ff) begin
            gamma[1 : t2]       <= gamma[t+1 : t3];
            gamma_reg[2 : t+1]  <= gamma[2 : t+1];
          end

          if (ff) begin
            tetta[1 : t2]   <= tetta[t+1 : t3];
            for (int i = 1; i <= t; i++) begin
              tetta[t2 + i] <= bm_decision ? gamma_reg[i + 1]  : tetta[i];
            end
          end
        end
        //
        cSTEP3_STATE : begin
          for (int i = 1; i <= t; i++) begin
            if (i == t)
//            gamma[t2 + i] <= (gamma[t2 + i] & {m{ff}}) ^ gf_mult_a_by_b(~ff ? sigma         : gamma_zero,
//                                                                        ~ff ? 0             : tetta[i]    );
              gamma[t2 + i] <= {m{ff}} &
                               ((gamma[t2 + i] & {m{ff}}) ^ gf_mult_a_by_b(~ff ? sigma         : gamma_zero,
                                                                           ~ff ? gamma[i + 1]  : tetta[i]    ));
            else
              gamma[t2 + i] <=  (gamma[t2 + i] & {m{ff}}) ^ gf_mult_a_by_b(~ff ? sigma         : gamma_zero,
                                                                           ~ff ? gamma[i + 1]  : tetta[i]    );
          end

          if (~ff) begin
            gamma[1 : t2]     <= gamma[t+1 : t3];
            gamma_reg[2 : t]  <= gamma[2 : t];
            gamma_reg[t + 1]  <= '0;
          end

          if (ff) begin
            tetta[1 : t2]   <= tetta[t+1 : t3];
            for (int i = 1; i <= t; i++) begin
              tetta[t2 + i] <= bm_decision ? gamma_reg[i + 1]  : tetta[i];
            end
            // take decision
            gamma_zero <= gamma[0];
            if (bm_decision) begin
              sigma <= gamma_zero;
              kv    <= ~kv;
            end
            else begin
              kv    <= kv + 1;
            end
          end
        end
        //
        default : begin end
      endcase
      // done is occured when state == cWAIT_STATE
      done <= (state == cSTEP3_STATE) & cnt_done & ff;
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
      logneed <= (state == cSTEP3_STATE) & ff;
      if (logneed) begin
        $display("%m step1 %0d :: gamma_lsb %0d kv %0d", cnt, gamma[0], kv);
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
