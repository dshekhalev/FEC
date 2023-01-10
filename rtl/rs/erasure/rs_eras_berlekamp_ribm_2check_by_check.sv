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
  data_t  rs_berlekamp__ieras_root      [1 : check] ;
  data_t  rs_berlekamp__ieras_num                   ;
  logic   rs_berlekamp__oloc_poly_val               ;
  data_t  rs_berlekamp__oloc_poly       [0 : check] ;
  data_t  rs_berlekamp__oloc_poly_deg               ;
  data_t  rs_berlekamp__oomega_poly     [1 : check] ;
  ptr_t   rs_berlekamp__oloc_poly_ptr               ;
  logic   rs_berlekamp__oloc_decfail                ;



  rs_eras_berlekamp_ribm_2check
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
    .ieras_root    ( rs_berlekamp__ieras_root    ) ,
    .ieras_num     ( rs_berlekamp__ieras_num     ) ,
    .oloc_poly_val ( rs_berlekamp__oloc_poly_val ) ,
    .oloc_poly     ( rs_berlekamp__oloc_poly     ) ,
    .oloc_poly_deg ( rs_berlekamp__oloc_poly_deg ) ,
    .oomega_poly   ( rs_berlekamp__oomega_poly   ) ,
    .oloc_poly_ptr ( rs_berlekamp__oloc_poly_ptr ) ,
    .oloc_decfail  ( rs_berlekamp__oloc_decfail  )
  );


  assign rs_berlekamp__iclk           = '0 ;
  assign rs_berlekamp__iclkena        = '0 ;
  assign rs_berlekamp__ireset         = '0 ;
  assign rs_berlekamp__isyndrome_val  = '0 ;
  assign rs_berlekamp__isyndrome_ptr  = '0 ;
  assign rs_berlekamp__isyndrome      = '0 ;
  assign rs_berlekamp__ieras_root     = '0 ;
  assign rs_berlekamp__ieras_num      = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_eras_berlekamp_ribm_2check.sv
// Description   : reformulated inversionless berlekamp algirithm with erasures module
//                 with get result after 2*((check + 1)*check + 1) + 1 ticks
//                 module use 4 GF(2^m) mult modules
//

`include "define.vh"

module rs_eras_berlekamp_ribm_2check_by_check
(
  iclk          ,
  iclkena       ,
  ireset        ,
  isyndrome_val ,
  isyndrome_ptr ,
  isyndrome     ,
  ieras_root    ,
  ieras_num     ,
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
  input  data_t  ieras_root     [1 : check] ;
  input  data_t  ieras_num                  ;
  //
  output logic   oloc_poly_val              ;
  output data_t  oloc_poly      [0 : check] ;
  output data_t  oomega_poly    [1 : check] ;
  output ptr_t   oloc_poly_ptr              ;
  output logic   oloc_decfail               ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int t3 = check + errs;
  localparam int t2 = check;
  localparam int t  = errs;

  ptr_t  syndrome_ptr_latched ;

  data_t eras_num     ;
  logic  eras_decfail ;
  logic  eras_is_zero ;
  logic  eras_is_max  ;

  data_t l_poly       [-1 : t2];
  data_t b_poly       [-1 : t2];

  data_t temp_sh_reg  [1  : t2];
  logic  gamma_is_zero;

  data_t tetta        [0  : t2];
  data_t gamma        [0  : t2];

  data_t sigma;
  data_t kv;

  localparam int cCNT_W   = clogb2(check + 1);
  localparam int cTCNT_W  = clogb2(t2 + 1);

  logic [cCNT_W-1 : 0]  cnt;
  logic                 cnt_done;

  logic                 cnt_r_done;
  logic [cCNT_W-1 : 0]  cnt_r_level;

  logic [cTCNT_W-1 : 0] tcnt;
  logic                 tcnt_done;

  enum bit [2 : 0] {
    cWAIT_STATE       ,
    cEPOLY_STEP_STATE ,  // count Ã(x)
    cEPOLY_DONE_STATE ,  // init BM/Ô(x) variables
    cOMEGA_STEP_STATE ,  // count Ô(x)
    cBM_INIT_STATE    ,  // init BM variables
    cBM_STEP_STATE       // BM steps
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  assign cnt_r_done = (cnt == cnt_r_level);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cWAIT_STATE;
    end
    else if (iclkena) begin
      case (state)
        cWAIT_STATE       : state <= isyndrome_val              ? cEPOLY_STEP_STATE : cWAIT_STATE;
        //
        cEPOLY_STEP_STATE : state <= (cnt_done    & tcnt_done)  ? cEPOLY_DONE_STATE : cEPOLY_STEP_STATE;
        cEPOLY_DONE_STATE : state <= eras_is_zero               ? cBM_INIT_STATE    : cOMEGA_STEP_STATE;
        //
        cOMEGA_STEP_STATE : state <= (cnt_r_done  & tcnt_done)  ? cBM_INIT_STATE    : cOMEGA_STEP_STATE;
        //
        cBM_INIT_STATE    : state <= eras_is_max                ? cWAIT_STATE       : cBM_STEP_STATE;
        cBM_STEP_STATE    : state <= (cnt_done    & tcnt_done)  ? cWAIT_STATE       : cBM_STEP_STATE;
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
        syndrome_ptr_latched  <= isyndrome_ptr;
        eras_num              <= ieras_num;
      end
      // we have t2 tick to decode eras num
      eras_decfail  <= (eras_num > t2);
      eras_is_zero  <= (eras_num == 0);
      eras_is_max   <= eras_decfail ? 1'b1  : (eras_num == t2);
      cnt_r_level   <= eras_decfail ? 1     : (t2 - eras_num + 1);
      //
      // cycle counter for count [1 : t2] cycles
      if (state == cWAIT_STATE || state == cEPOLY_DONE_STATE) begin
        cnt         <= t2; // easy to create dynamic variable check
        cnt_done    <= 1'b0;
        tcnt        <= t2 + 1;
        tcnt_done   <= 1'b0;
      end
      else if (state == cEPOLY_STEP_STATE || state == cOMEGA_STEP_STATE || state == cBM_STEP_STATE) begin
        tcnt        <= tcnt - 1'b1;
        tcnt_done   <= (tcnt == 2);
        if (tcnt_done) begin
          tcnt      <= t2 + 1;
          cnt       <= cnt - 1'b1;
          cnt_done  <= (cnt <= 2);
        end
      end
      //
      // decode process
      case (state)
        cWAIT_STATE : begin
          // load polynomes
          if (isyndrome_val) begin  // asynchronus mode support
            for (int i =  0; i <= t2; i++) gamma [i] <= (i < t2) ? isyndrome[i + 1] : 0;
            for (int i = -1; i <= t2; i++) l_poly[i] <= (i == 0) ? 1 : 0;
          end
          for (int i =  0; i <= t2; i++) tetta  [i] <= (i < t2) ? isyndrome[i + 1] : 0;
          for (int i = -1; i <= t2; i++) b_poly [i] <= (i == 0) ? 1 : 0;
          //
          temp_sh_reg[1 : t2] <= ieras_root[1 : t2];
          // init values
          sigma <= 1'b1;
          kv    <= 1'b0;
        end
        //
        cEPOLY_STEP_STATE : begin
          // l_poly arithmetic
          l_poly[0]       <= tcnt_done ? l_poly[t2] : (gf_mult_a_by_b(sigma, l_poly[t2]) ^ gf_mult_a_by_b(temp_sh_reg[1], l_poly[t2-1]));
          l_poly[1 : t2]  <= l_poly[0 : t2-1];

          // "roots" shift registers
          if (tcnt_done) begin
            temp_sh_reg[1 : t2-1] <= temp_sh_reg[2 : t2]; // shift left
          end
        end
        //
        cEPOLY_DONE_STATE : begin
          b_poly[0 : t2]      <= l_poly[0 : t2];
          temp_sh_reg[1 : t2] <= l_poly[1 : t2];
        end
        //
        cOMEGA_STEP_STATE : begin
          // gamma arithmetic
          gamma[t2]       <= tcnt_done ? {m{1'b0}} : (gf_mult_a_by_b(sigma, gamma[1]) ^ gf_mult_a_by_b(temp_sh_reg[1], tetta[0]));
          gamma[0 : t2-1] <= gamma[1 : t2];

          // tetta shift registers
          tetta[t2]       <= tcnt_done ? {m{1'b0}} : tetta[0];
          tetta[0 : t2-1] <= tetta[1 : t2];

          // "l_poly" shift registers
          if (tcnt_done) begin
            temp_sh_reg[1 : t2-1] <= temp_sh_reg[2 : t2]; // shift left
          end
        end
        //
        cBM_INIT_STATE : begin
          tetta[0 : t2]   <=  gamma [0 : t2];
          temp_sh_reg[1]  <=  gamma [0];
          gamma_is_zero   <= (gamma [0] == 0);
        end
        //
        cBM_STEP_STATE : begin
          // l_poly arithmetic
          l_poly[0]       <= gf_mult_a_by_b(sigma, l_poly[t2]) ^ gf_mult_a_by_b(temp_sh_reg[1] , b_poly[t2-1]);
          l_poly[1 : t2]  <= l_poly[0 : t2-1];

          // gamma arithmetic
          gamma[t2]       <= tcnt_done ? {m{1'b0}} : (gf_mult_a_by_b(sigma, gamma[1]) ^ gf_mult_a_by_b(temp_sh_reg[1], tetta[0]));
          gamma[0 : t2-1] <= gamma[1 : t2];

          // shift registers
          b_poly[0 : t2-1]  <= b_poly[-1 : t2-2];
          tetta [0 : t2-1]  <= tetta  [1 : t2];

          // b_poly/tetta decision
          if (~gamma_is_zero & ~kv[m-1]) begin
            b_poly[-1]  <= tcnt_done ? {m{1'b0}} : l_poly[t2-1];
            tetta[t2]   <= tcnt_done ? {m{1'b0}} : gamma[1];
          end
          else begin
            b_poly[-1]  <= tcnt_done ? {m{1'b0}} : b_poly[t2-2];
            tetta[t2]   <= tcnt_done ? {m{1'b0}} : tetta[0];
          end

          // decision
          if (tcnt_done) begin
            temp_sh_reg[1]  <=  gamma [1];
            gamma_is_zero   <= (gamma [1] == 0);
            if (~gamma_is_zero & ~kv[m-1]) begin
              sigma <= temp_sh_reg[1];
              kv    <= ~kv;
            end
            else begin
              kv    <= kv + 1;
            end
          end
        end
      endcase
      // done is occured when state == cWAIT_STATE
      done <= ((state == cBM_STEP_STATE) & cnt_done & tcnt_done) || ((state == cBM_INIT_STATE) & eras_is_max);
    end // iclkena
  end

  assign oloc_poly_val = done;
  assign oloc_poly     = l_poly[0 : t2];
  assign oomega_poly   = gamma [0 : t2-1];
  assign oloc_decfail  = eras_decfail;
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
        $sformat(str, "%m get %0d erasures : ", ieras_num);
        for (int i = 1; i <= t2; i++) begin
          $sformat(s, " %d", ieras_root[i]);
          str = {str, s};
        end
        $display(str);
      end
    end
  end

  typedef data_t vector_t [0 : t2];

  bit logneed;
  bit logneed1;

  assign logneed = (state == cBM_INIT_STATE) || logneed1;
//assign logneed = (state == cBM_INIT_STATE) || done;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      logneed1 <= (state == cBM_STEP_STATE & tcnt_done);// || (state == cEPOLY_STEP_STATE & tcnt_done);
      if (logneed) begin
        $display("%m step %0d :: gamma_lsb %0d kv %0d", cnt, gamma[0], kv);
        vector_logout("l     poly ", l_poly[0 : t2]);
        vector_logout("b     poly ", b_poly[0 : t2]);
        vector_logout("gamma poly ", gamma [0 : t2]);
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
    $display("%m ", str);
  end
  endfunction
  // synthesis translate_on
`endif

endmodule
