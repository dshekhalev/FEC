/*



  parameter int pLLR_W       = 4 ;
  parameter int pNODE_W      = 8 ;
  parameter int pNORM_FACTOR = 7 ;
  parameter int pNORM_OFFSET = 1 ;



  logic         ldpc_dvb_dec_sort_engine__iclk                ;
  logic         ldpc_dvb_dec_sort_engine__ireset              ;
  logic         ldpc_dvb_dec_sort_engine__iclkena             ;
  //
  logic         ldpc_dvb_dec_sort_engine__istart              ;
  //
  logic         ldpc_dvb_dec_sort_engine__ival                ;
  strb_t        ldpc_dvb_dec_sort_engine__istrb               ;
  logic         ldpc_dvb_dec_sort_engine__ivmask              ;
  node_t        ldpc_dvb_dec_sort_engine__ivnode              ;
  //
  logic         ldpc_dvb_dec_sort_engine__osort_val           ;
  vn_min_t      ldpc_dvb_dec_sort_engine__osort_rslt          ;
  min_col_idx_t ldpc_dvb_dec_sort_engine__osort_num_m1        ;
  //
  logic         ldpc_dvb_dec_sort_engine__osort_b1_pre_val    ;
  min_col_idx_t ldpc_dvb_dec_sort_engine__osort_b1_pre_num_m1 ;
  //
  logic         ldpc_dvb_dec_sort_engine__osort_b2_pre_val    ;
  min_col_idx_t ldpc_dvb_dec_sort_engine__osort_b2_pre_num_m1 ;
  //
  logic         ldpc_dvb_dec_sort_engine__odecfail            ;



  ldpc_dvb_dec_sort_engine
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pNODE_W      ( pNODE_W      ) ,
    .pNORM_FACTOR ( pNORM_FACTOR ) ,
    .pNORM_OFFSET ( pNORM_OFFSET )
  )
  ldpc_dvb_dec_sort_engine
  (
    .iclk                ( ldpc_dvb_dec_sort_engine__iclk                ) ,
    .ireset              ( ldpc_dvb_dec_sort_engine__ireset              ) ,
    .iclkena             ( ldpc_dvb_dec_sort_engine__iclkena             ) ,
    //
    .istart              ( ldpc_dvb_dec_sort_engine__istart              ) ,
    //
    .ival                ( ldpc_dvb_dec_sort_engine__ival                ) ,
    .istrb               ( ldpc_dvb_dec_sort_engine__istrb               ) ,
    .ivmask              ( ldpc_dvb_dec_sort_engine__ivmask              ) ,
    .ivnode              ( ldpc_dvb_dec_sort_engine__ivnode              ) ,
    //
    .osort_val           ( ldpc_dvb_dec_sort_engine__osort_val           ) ,
    .osort_rslt          ( ldpc_dvb_dec_sort_engine__osort_rslt          ) ,
    .osort_num_m1        ( ldpc_dvb_dec_sort_engine__osort_num_m1        ) ,
    //
    .osort_b1_pre_val    ( ldpc_dvb_dec_sort_engine__osort_b1_pre_val    ) ,
    .osort_b1_pre_num_m1 ( ldpc_dvb_dec_sort_engine__osort_b1_pre_num_m1 ) ,
    //
    .osort_b2_pre_val    ( ldpc_dvb_dec_sort_engine__osort_b2_pre_val    ) ,
    .osort_b2_pre_num_m1 ( ldpc_dvb_dec_sort_engine__osort_b2_pre_num_m1 ) ,
    //
    .odecfail            ( ldpc_dvb_dec_sort_engine__odecfail            )
  );


  assign ldpc_dvb_dec_sort_engine__iclk    = '0 ;
  assign ldpc_dvb_dec_sort_engine__ireset  = '0 ;
  assign ldpc_dvb_dec_sort_engine__iclkena = '0 ;
  assign ldpc_dvb_dec_sort_engine__istart  = '0 ;
  assign ldpc_dvb_dec_sort_engine__ival    = '0 ;
  assign ldpc_dvb_dec_sort_engine__istrb   = '0 ;
  assign ldpc_dvb_dec_sort_engine__ivmask  = '0 ;
  assign ldpc_dvb_dec_sort_engine__ivnode  = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_sort_engine.sv
// Description   : Serial sort engine for min-sum algorithm
//

module ldpc_dvb_dec_sort_engine
(
  iclk             ,
  ireset              ,
  iclkena             ,
  //
  istart              ,
  //
  ival                ,
  istrb               ,
  ivmask              ,
  ivnode              ,
  //
  osort_val           ,
  osort_rslt          ,
  osort_num_m1        ,
  //
  osort_b1_pre_val    ,
  osort_b1_pre_num_m1 ,
  //
  osort_b2_pre_val    ,
  osort_b2_pre_num_m1 ,
  //
  odecfail
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk                ;
  input  logic        ireset              ;
  input  logic        iclkena             ;
  //
  input  logic        istart              ;
  //
  input  logic        ival                ;
  input  strb_t       istrb               ;
  input  logic        ivmask              ;
  input  node_t       ivnode              ;
  //
  output logic        osort_val           ;
  output vn_min_t     osort_rslt          ;
  output vn_min_col_t osort_num_m1        ;
  //
  output logic        osort_b1_pre_val    ;  // look ahead decision (before 1 tick)
  output vn_min_col_t osort_b1_pre_num_m1 ;
  //
  output logic        osort_b2_pre_val    ;  // look ahead decision (before 2 tick)
  output vn_min_col_t osort_b2_pre_num_m1 ;
  //
  output logic        odecfail            ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         val   ;
  strb_t        strb  ;

  logic         pmask ;

  logic         vnode_done;
  vn_min_col_t  vnode_col;
  logic         sign_vnode;
  vnode_t       abs_vnode;

  logic         vn_sort_done;
  logic         vn_sort_pmask;
  vn_min_t      vn_sort;
  vn_min_col_t  vn_sort_num_m1;

  //------------------------------------------------------------------------------------------------------
  // get abs
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val        <= 1'b0;
      vnode_done <= 1'b0;
    end
    else if (iclkena) begin
      val        <= ival;
      vnode_done <= ival & istrb.eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      strb <= istrb;
      //
      if (ivmask) begin
        sign_vnode <= 1'b0;
        abs_vnode  <= '1;
      end
      else begin
        sign_vnode <=  ivnode[pNODE_W-1];
        abs_vnode  <= (ivnode ^ {pNODE_W{ivnode[pNODE_W-1]}}) + ivnode[pNODE_W-1];
      end
      //
      if (ival) begin
        vnode_col <= istrb.sop ? '0 : (vnode_col + 1'b1);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // serial sort
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      vn_sort_done  <= 1'b0;
    end
    else if (iclkena) begin
      vn_sort_done  <= vnode_done;
    end
  end

  wire check1 = (abs_vnode < vn_sort.min1);
  wire check2 = (abs_vnode < vn_sort.min2);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        vn_sort_num_m1 <= vnode_col;
        if (strb.sop) begin
          vn_sort.prod_sign <= sign_vnode;
          vn_sort.min1      <= abs_vnode;
          vn_sort.min2      <= '1;
          vn_sort.min1_col  <= vnode_col;
        end
        else begin
          vn_sort.prod_sign <= vn_sort.prod_sign ^ sign_vnode;
          //
          if (check1) begin
            vn_sort.min1     <= abs_vnode;
            vn_sort.min1_col <= vnode_col;
          end
          if (check2) begin
            vn_sort.min2     <= check1 ? vn_sort.min1 : abs_vnode;
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output valid 2 tick after ival & ieop
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osort_val <= 1'b0;
    end
    else if (iclkena) begin
      osort_val <= vn_sort_done;
    end
  end

  // edge comparator for decfail
  wire vn_sort_leq1 = (vn_sort.min1[pNODE_W-1 : 1] == 0);  // <= 0..1

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istart) begin
        odecfail <= 1'b0;
      end
      else if (vn_sort_done) begin
        odecfail <= odecfail | vn_sort.prod_sign | vn_sort_leq1;
      end
      //
      if (vn_sort_done) begin
        osort_num_m1    <= vn_sort_num_m1;
        osort_rslt      <= vn_sort;
        if (pNORM_OFFSET) begin
          osort_rslt.min1 <= vn_sort.min1 - (vn_sort.min1 != 0);  // offset value is 1
          osort_rslt.min2 <= vn_sort.min2 - (vn_sort.min2 != 0);  // it's positive value
        end
        else begin
          osort_rslt.min1 <= normalize(vn_sort.min1);
          osort_rslt.min2 <= normalize(vn_sort.min2);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // look ahead signals
  //------------------------------------------------------------------------------------------------------

  // before 2 tick of osort val signal
  assign osort_b2_pre_val    = vnode_done;
  assign osort_b2_pre_num_m1 = vnode_col;

  // before 1 tick of osort_val signal
  assign osort_b1_pre_val    = vn_sort_done;
  assign osort_b1_pre_num_m1 = vn_sort_num_m1;

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function automatic vnode_t normalize (input vnode_t dat);
    logic [pNODE_W+2 : 0] tmp; // + 3 bit
  begin
    if (pNORM_FACTOR != 0) begin //0.875
      case (pNORM_FACTOR)
        1       : begin // 0.125
          tmp =  dat + 4;
        end
        2       : begin // 0.25
          tmp = (dat <<< 1) + 4;
        end
        3       : begin // 0.375
          tmp = (dat <<< 1) + dat + 4;
        end
        4       : begin // 0.5
          tmp = (dat <<< 2) + 4;
        end
        5       : begin // 0.625
          tmp = (dat <<< 2) + dat + 4;
        end
        6       : begin // 0.75
          tmp = (dat <<< 2) + (dat <<< 1) + 4;
        end
        7       : begin // 0.875
          tmp = (dat <<< 3) - dat + 4;
        end
        default : begin // no normalization
          tmp = (dat <<< 3);
        end
      endcase
      normalize = tmp[pNODE_W+2 : 3];
    end
    else begin
      normalize = dat;
    end
  end
  endfunction

endmodule
