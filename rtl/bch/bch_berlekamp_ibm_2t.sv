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



  bch_berlekamp_ibm_2t
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
    .ireset        ( bch_berlekamp__ireset        ) ,
    .iclkena       ( bch_berlekamp__iclkena       ) ,
    .isyndrome_val ( bch_berlekamp__isyndrome_val ) ,
    .isyndrome_ptr ( bch_berlekamp__isyndrome_ptr ) ,
    .isyndrome     ( bch_berlekamp__isyndrome     ) ,
    .oloc_poly_val ( bch_berlekamp__oloc_poly_val ) ,
    .oloc_poly     ( bch_berlekamp__oloc_poly     ) ,
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
// Workfile      : bch_berlekamp_ibm_2t.sv
// Description   : inversionless berlekamp algirithm module with get result after 2*t + 1 ticks
//                 module use 2*t+2 GF(2^m) mult modules
//

module bch_berlekamp_ibm_2t
(
  iclk          ,
  ireset        ,
  iclkena       ,
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
  input  logic   isyndrome_val           ;
  input  ptr_t   isyndrome_ptr           ;
  input  data_t  isyndrome      [1 : t2] ;
  output logic   oloc_poly_val           ;
  output data_t  oloc_poly      [0 : t]  ;
  output ptr_t   oloc_poly_ptr           ;
  output logic   oloc_decfail            ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  data_t syndrome    [-t : t2];
  ptr_t  syndrome_ptr_latched ;

  data_t l_poly       [-1 : t];
  data_t l_poly_next   [0 : t];

  data_t b_poly       [-2 : t];

  localparam int cCNT_W = $clog2(t + 1);

  logic [cCNT_W-1 : 0]  cnt;
  logic                 cnt_done;

  data_t mult [0 : t];

  data_t delta;
  data_t sigma;
  data_t kv;

  enum bit [1:0] {
    cRESET_STATE,
    cWAIT_STATE ,
    cSTEP1_STATE,
    cSTEP2_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <= cWAIT_STATE;
        cWAIT_STATE  : state <= isyndrome_val ? cSTEP1_STATE  : cWAIT_STATE;
        cSTEP1_STATE : state <= cSTEP2_STATE;
        cSTEP2_STATE : state <= cnt_done      ? cWAIT_STATE   : cSTEP1_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Berlekamp logic
  //------------------------------------------------------------------------------------------------------

  logic done = 0;

  always_comb begin
    for (int i = 0; i <= t; i++) begin
      mult[i] = gf_mult_a_by_b(
        (state == cSTEP1_STATE) ? sigma     : delta,
        (state == cSTEP1_STATE) ? l_poly[i] : b_poly[i-1]
        );
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // capture pointer linked with used syndrome
      if (state == cWAIT_STATE & isyndrome_val) begin
        syndrome_ptr_latched <= isyndrome_ptr;
      end
      //
      // cycle counter for count [1 : t] cycles
      if (state == cWAIT_STATE) begin
        cnt       <= t;
        cnt_done  <= (t < 2);
      end
      else if (state == cSTEP2_STATE) begin
        cnt       <= cnt - 1'b1;
        cnt_done  <= (cnt == 2);
      end
      //
      // decode process
      unique case (state)
        cWAIT_STATE : begin
          // load syndrome register
          for (int i = -t; i <= t2; i++) syndrome[i] <= (i < 1) ? '0 : isyndrome[i];
          // init polynomes
          if (isyndrome_val) begin // asynchronus mode support
            for (int i = -1; i <=  t; i++) l_poly[i] <= (i == 0) ? 1'b1 : '0;
          end
          for (int i = -2; i <=  t; i++) b_poly[i] <= (i == 0) ? 1'b1 : '0;
          // init values
          sigma <= 1'b1;
          kv    <= 1'b0;
        end
        //
        cSTEP1_STATE : begin
          delta     <= count_delta(0);
          syndrome[-t : t2-2] <= syndrome[-t + 2 : t2];
          // count 1/2 of loc_poly
          for (int i = 0; i <= t; i++) begin
            l_poly_next[i] <= mult[i]; //gf_mult_a_by_b(sigma, l_poly[i]);
          end
        end
        //
        cSTEP2_STATE : begin
          for (int i = 0; i <= t; i++) begin
            l_poly[i] <= l_poly_next[i] ^ mult[i]; // gf_mult_a_by_b(delta, b_poly[i-1]);
          end
          if ((delta != 0) & ~kv[m-1]) begin
            b_poly[0 : t] <= l_poly[-1 : t-1]; // mult by z
            sigma         <= delta;
            kv            <= -kv;
          end
          else begin
            b_poly[0 : t] <= b_poly[-2 : t-2];  // mult by z^2
            kv            <= kv + 2;
          end
        end
        default : begin end
      endcase
      // done is occured when state == cWAIT_STATE
      done <= (state == cSTEP2_STATE) & cnt_done;
    end // iclkena
  end

  assign oloc_poly_val = done;
  assign oloc_poly     = l_poly[0 : t];
  assign oloc_poly_ptr = syndrome_ptr_latched;
  assign oloc_decfail   = 1'b0;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function data_t count_delta (input int r = 0);
    count_delta = r;
    for (int j = 0; j <= t; j++) begin
      count_delta ^= gf_mult_a_by_b(l_poly[j], syndrome[1-j]);
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // logout functions
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
`ifdef __BCH_BERLEKAMP_DEBUG_LOG__
  always_ff @(posedge iclk) begin
    string str, s;
    if (iclkena) begin
      if (isyndrome_val) begin
        $sformat(str, "BMA ibm synt get syndromes : ");
        for (int i = 1; i <= t2; i++) begin
          $sformat(s, " %d", isyndrome[i]);
          str = {str, s};
        end
        $display(str);
      end
    end
  end

  bit logneed;
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      logneed <= (state == cSTEP2_STATE);
      if (logneed) begin
        $display("step %0d, delta %0d sigma %0d kv %0d", cnt-1, delta, sigma, kv);
        vector_logout("l poly ", l_poly[0 : t]);
        vector_logout("b poly ", b_poly[0 : t]);
      end
    end
  end

  typedef data_t vector_t [0 : t];

  function void vector_logout (input string is, input vector_t vector);
    string str, s;
  begin
    str = is;
    for (int i = 0; i <= t; i++) begin
      $sformat(s, " %d", vector[i]);
      str = {str, s};
    end
    $display(str);
  end
  endfunction
`endif
  // synthesis translate_on

endmodule
