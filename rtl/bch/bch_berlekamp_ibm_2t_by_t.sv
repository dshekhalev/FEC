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



  bch_berlekamp_ibm_2t_by_t
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
// Workfile      : bch_berlekamp_ibm_2t_by_t.sv
// Description   : inversionless berlekamp algirithm module with get result after 2*t + 2*(t + 1)^2 + 1 ticks
//                 module use only 2 GF(2^m) mult modules
//

`include "define.vh"

module bch_berlekamp_ibm_2t_by_t
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

  data_t l_poly      [-1 : t];
  data_t b_poly      [-2 : t];

  localparam int cCNT_W = clogb2(t + 1);

  logic [cCNT_W-1 : 0]  cnt;
  logic                 cnt_done;

  logic [cCNT_W-1 : 0]  t_cnt;
  logic                 t_cnt_done;

  data_t delta;

  data_t dat2mult_1_a  [0 : t] ;
  data_t dat2mult_12_b [0 : t] ;
  data_t dat2mult_2_a   ;

  data_t mult_1_ab;
  data_t mult_2_ab;

  data_t sigma;
  data_t kv;

  logic mult_val;

  enum bit [2:0] {
    cRESET_STATE ,
    cWAIT_STATE  ,
    cSTEP1_STATE ,
    cSTEP2_STATE ,
    cSTEP3_STATE ,
    cSTEP4_STATE ,
    //
    cSTEP5_STATE ,
    cSTEP6_STATE
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
        cRESET_STATE  : state <= cWAIT_STATE;
        cWAIT_STATE   : state <= isyndrome_val  ? cSTEP1_STATE  : cWAIT_STATE;
        cSTEP1_STATE  : state <= cSTEP2_STATE ;
        cSTEP2_STATE  : state <= t_cnt_done     ? cSTEP3_STATE  : cSTEP2_STATE; // long delay state
        cSTEP3_STATE  : state <= cSTEP4_STATE ;
        cSTEP4_STATE  : state <= t_cnt_done     ? (cnt_done ? cWAIT_STATE   : cSTEP1_STATE)  : cSTEP4_STATE; // long delay state
        //
        cSTEP5_STATE  : state <= cWAIT_STATE;
        cSTEP6_STATE  : state <= cWAIT_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Berlekamp logic
  //------------------------------------------------------------------------------------------------------

  logic done = '0;

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
      //else if (state == cSTEP5_STATE) begin
      else if (state == cSTEP4_STATE & t_cnt_done) begin
        cnt       <= cnt - 1'b1;
        cnt_done  <= (cnt == 2);
      end

      //
      // iteration counter for count [0 : t] iteration
      if ((state == cSTEP2_STATE) || (state == cSTEP4_STATE)) begin
        t_cnt       <= t_cnt + 1'b1;
        t_cnt_done  <= (t_cnt == t);
        mult_val    <= (t_cnt <= t);
      end
      else begin
        t_cnt       <= '0;
        t_cnt_done  <= 1'b0;
        mult_val    <= 1'b0;
      end

      unique case (state)
        //
        cWAIT_STATE : begin // decode process is high priority
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
        cSTEP1_STATE : begin // init count of delta & load galois mult shift registers
          delta <= '0;
          for (int i = 0; i <= t; i++) begin
            dat2mult_1_a  [i] <= syndrome[1-i];
            dat2mult_12_b [i] <= l_poly[i];
          end
          dat2mult_2_a        <= sigma;
          syndrome[-t : t2-2] <= syndrome[-t + 2 : t2];
        end
        //
        cSTEP2_STATE : begin // count delta & l_poly left, previous l_poly store in dat2mult_12_b
          // shift registes
          for (int i = 0; i <= t; i++) begin
            dat2mult_1_a  [i] <= (i == 0) ? dat2mult_1_a  [0] : dat2mult_1_a [i-1]; // shift
            dat2mult_12_b [i] <= (i == 0) ? dat2mult_12_b [t] : dat2mult_12_b[i-1]; // round shift use for store l_poly copy
          end
          // mults
          mult_1_ab <= gf_mult_a_by_b(dat2mult_1_a[t], dat2mult_12_b[t]);
          mult_2_ab <= gf_mult_a_by_b(dat2mult_2_a   , dat2mult_12_b[t]);
          //
          if (mult_val) begin
            delta <= delta ^ mult_1_ab;
            for (int i = 0; i <= t; i++) begin
              l_poly[i] <= (i == 0) ? mult_2_ab : l_poly[i-1];
            end
          end
        end
        //
        cSTEP3_STATE : begin  // take delta decision & load galois mult shift registers
          for (int i = 0; i <= t; i++) begin
            dat2mult_12_b [i] <= b_poly[i-1];
          end
          dat2mult_2_a <= delta;
          //
          if ((delta != 0) & ~kv[m-1]) begin
            b_poly[0]     <= l_poly[-1];
//          b_poly[1 : t] <= dat2mult_12_b[0 : t-1]; but there is one more shift that is why use [1 : t]
            b_poly[1 : t] <= dat2mult_12_b[1 : t];
            sigma         <= delta;
            kv            <= -kv;
          end
          else begin
            b_poly[0 : t] <= b_poly[-2 : t-2];  // mult by z^2
            kv            <= kv + 2;
          end
        end
        //
        cSTEP4_STATE : begin  // count l_poly rigth
          // shift registes
          for (int i = 0; i <= t; i++) begin
            dat2mult_12_b [i] <= (i == 0) ? dat2mult_12_b[t] : dat2mult_12_b[i-1];
          end
          // mults
          mult_2_ab <= gf_mult_a_by_b(dat2mult_2_a , dat2mult_12_b[t]);
          if (mult_val) begin
            for (int i = 0; i <= t; i++) begin
              l_poly [i] <= (i == 0) ?  (l_poly [t] ^ mult_2_ab) : l_poly [i-1];
            end
          end
        end
        default : begin end
      endcase
      // done is occured when state == cWAIT_STATE
      done <= (state == cSTEP4_STATE) & cnt_done & t_cnt_done;
    end
  end

  assign oloc_poly_val = done;
  assign oloc_poly     = l_poly[0 : t];
  assign oloc_poly_ptr = syndrome_ptr_latched;
  assign oloc_decfail   = 1'b0;

  //------------------------------------------------------------------------------------------------------
  // useful functions
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
`ifdef __USE_BCH_BERLEKAMP_DEBUG_LOG__

  typedef data_t vector_t [0 : t];

  always_ff @(posedge iclk) begin
    string str, s;
    if (iclkena) begin
      if (isyndrome_val) begin
        $sformat(str, "BMA ibm_fast_seq synt get syndromes : ");
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
      logneed <= (state == cSTEP4_STATE & t_cnt_done);
      if (logneed) begin
        $display("step %0d, delta %0d sigma %0d kv %0d", cnt-1, delta, sigma, kv);
        vector_logout("l poly ", l_poly[0 : t]);
        vector_logout("b poly ", b_poly[0 : t]);
      end
    end
  end

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
