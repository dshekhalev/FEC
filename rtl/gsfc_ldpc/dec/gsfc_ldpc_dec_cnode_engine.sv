/*



  parameter int pLLR_W        = 4 ;
  parameter int pLLR_BY_CYCLE = 1 ;
  parameter int pNODE_W       = 1 ;
  parameter bit pUSE_NORM     = 1 ;


  logic  gsfc_ldpc_dec_cnode_engine__iclk            ;
  logic  gsfc_ldpc_dec_cnode_engine__ireset          ;
  logic  gsfc_ldpc_dec_cnode_engine__iclkena         ;
  logic  gsfc_ldpc_dec_cnode_engine__isop            ;
  logic  gsfc_ldpc_dec_cnode_engine__ival            ;
  logic  gsfc_ldpc_dec_cnode_engine__ieop            ;
  zcnt_t gsfc_ldpc_dec_cnode_engine__izcnt           ;
  node_t gsfc_ldpc_dec_cnode_engine__ivn             ;
  logic  gsfc_ldpc_dec_cnode_engine__oval            ;
  node_t gsfc_ldpc_dec_cnode_engine__ocnode     [pW] ;
  logic  gsfc_ldpc_dec_cnode_engine__obusy           ;
  tcnt_t gsfc_ldpc_dec_cnode_engine__otcnt           ;
  logic  gsfc_ldpc_dec_cnode_engine__otcnt_zero      ;
  zcnt_t gsfc_ldpc_dec_cnode_engine__ozcnt           ;
  logic  gsfc_ldpc_dec_cnode_engine__odecfail        ;
  logic  gsfc_ldpc_dec_cnode_engine__oebusy          ;



  gsfc_ldpc_dec_cnode_engine
  #(
    .pLLR_W        ( pLLR_W        ) ,
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pNODE_W       ( pNODE_W       ) ,
    .pUSE_NORM     ( pUSE_NORM     )
  )
  gsfc_ldpc_dec_cnode_engine
  (
    .iclk       ( gsfc_ldpc_dec_cnode_engine__iclk       ) ,
    .ireset     ( gsfc_ldpc_dec_cnode_engine__ireset     ) ,
    .iclkena    ( gsfc_ldpc_dec_cnode_engine__iclkena    ) ,
    .isop       ( gsfc_ldpc_dec_cnode_engine__isop       ) ,
    .ival       ( gsfc_ldpc_dec_cnode_engine__ival       ) ,
    .ieop       ( gsfc_ldpc_dec_cnode_engine__ieop       ) ,
    .izcnt      ( gsfc_ldpc_dec_cnode_engine__izcnt      ) ,
    .ivmask     ( gsfc_ldpc_dec_cnode_engine__ivmask     ) ,
    .ivnode     ( gsfc_ldpc_dec_cnode_engine__ivnode     ) ,
    .oval       ( gsfc_ldpc_dec_cnode_engine__oval       ) ,
    .ocnode     ( gsfc_ldpc_dec_cnode_engine__ocnode     ) ,
    .obusy      ( gsfc_ldpc_dec_cnode_engine__obusy      ) ,
    .otcnt      ( gsfc_ldpc_dec_cnode_engine__otcnt      ) ,
    .otcnt_zero ( gsfc_ldpc_dec_cnode_engine__otcnt_zero ) ,
    .ozcnt      ( gsfc_ldpc_dec_cnode_engine__ozcnt      ) ,
    .odecfail   ( gsfc_ldpc_dec_cnode_engine__odecfail   )
    .oebusy     ( gsfc_ldpc_dec_cnode_engine__oebusy     )
  );


  assign gsfc_ldpc_dec_cnode_engine__iclk    = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__ireset  = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__iclkena = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__isop    = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__ival    = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__ieop    = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__izcnt   = '0 ;
  assign gsfc_ldpc_dec_cnode_engine__ivn     = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_cnode_engine.sv
// Description   : LDPC decoder check node arithmetic engine: read vnode and count cnode. Module use sequentual sort algorithm, the count and writeback cnode values
//                  L(r_ji) = prod(sign(vn_ij)) * min(abs(vn_ij)) exclude (j ~= 1)
//

module gsfc_ldpc_dec_cnode_engine
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  isop       ,
  ival       ,
  ieop       ,
  ivn        ,
  //
  oval       ,
  ocnode     ,
  //
  obusy      ,
  otcnt      ,
  otcnt_zero ,
  ozcnt      ,
  //
  odecfail   ,
  oebusy
);

  parameter bit pUSE_NORM = 1;

  `include "../gsfc_ldpc_parameters.svh"
  `include "gsfc_ldpc_dec_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk            ;
  input  logic    ireset          ;
  input  logic    iclkena         ;
  //
  input  logic    isop            ;
  input  logic    ival            ;
  input  logic    ieop            ;
  input  vn_min_t ivn             ;
  //
  output logic    oval            ;
  output node_t   ocnode     [pW] ;
  //
  output logic    obusy           ;
  output tcnt_t   otcnt           ;
  output logic    otcnt_zero      ;
  output zcnt_t   ozcnt           ;
  //
  output logic    odecfail        ;
  output logic    oebusy          ; // early busy

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    tcnt_t  val;
    logic   done;
    logic   zero;
  } tcnt_in;

  vn_min_t  vn;

  logic     sort_done;
  vn_min_t  sort_vn;

  logic     sort_sop;
  logic     sort_prod_sign;

  logic     cn_sign [pW];
  node_t    cn_abs  [pW];

  //------------------------------------------------------------------------------------------------------
  // sequential sort : master
  //------------------------------------------------------------------------------------------------------

                                       // {a,b} vs {c, d}
  wire check1 = (ivn.min1 < vn.min1);  //          (c < a) ? c : a
  wire check2 = (ivn.min2 < vn.min1);  // c < a  ? (d < a) ? d : a
  wire check3 = (ivn.min1 < vn.min2);  // c >= a ? (c < b) ? c : b

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        // cycle counter
        if (isop) begin
          tcnt_in.val   <= 1'b1;  // sop is actual cycle (!!!)
          tcnt_in.done  <= 1'b0;
          tcnt_in.zero  <= 1'b0;
        end
        else begin
          tcnt_in.val   <= tcnt_in.done ? '0 : (tcnt_in.val + 1'b1);
          tcnt_in.zero  <= tcnt_in.done | &tcnt_in.val;
          tcnt_in.done  <= (tcnt_in.val == pT-2);
        end
        //
        if (isop | tcnt_in.zero) begin
          vn <= ivn;
        end
        else begin
          vn.prod_sign  <= vn.prod_sign ^ ivn.prod_sign;
          vn.vn_sign    <= (vn.vn_sign << pW) | ivn.vn_sign;
          if (check1) begin
            vn.min1         <= ivn.min1;
            vn.min2         <= check2 ? ivn.min2 : vn.min1;
            vn.min1_idx     <= tcnt_in.val;
            vn.min1_weigth  <= ivn.min1_weigth;
          end
          else if (check3) begin
            vn.min2         <= ivn.min1;
          end
        end
      end
      //
      if (ival & isop) begin
        sort_sop <= 1'b1;
      end
      else if (sort_done) begin
        sort_sop <= 1'b0;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      sort_done <= 1'b0;
    end
    else if (iclkena) begin
      sort_done <= ival & tcnt_in.done;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // sequential flush : slave
  //------------------------------------------------------------------------------------------------------

  struct packed {
    tcnt_t val;
    logic  done;
    logic  zero;
  } tcnt_out;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obusy  <= 1'b0;
      oval   <= 1'b0;
    end
    else if (iclkena) begin
      if (sort_done) begin
        obusy <= 1'b1;
      end
      else if (tcnt_out.done) begin
        obusy <= 1'b0;
      end
      //
      oval <= obusy;
    end
  end

  assign oebusy = obusy;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (sort_done) begin
        sort_vn         <= vn;
        sort_vn.min1    <= normalize(vn.min1);
        sort_vn.min2    <= normalize(vn.min2);
        //
        tcnt_out        <= '0;
        tcnt_out.zero   <= 1'b1;
        //
        sort_prod_sign  <= sort_sop ? vn.prod_sign : (vn.prod_sign | sort_prod_sign);
      end
      else if (obusy) begin
        tcnt_out.val    <=  tcnt_out.val + 1'b1;
        tcnt_out.done   <= (tcnt_out.val == pT-2);
        tcnt_out.zero   <= &tcnt_out.val;
        sort_vn.vn_sign <= sort_vn.vn_sign << pW;
      end
      //
      if (obusy) begin
        odecfail <= sort_prod_sign;
        for (int w = 0; w < pW; w++) begin
          cn_abs  [w] <= ((sort_vn.min1_idx == tcnt_out.val) && (sort_vn.min1_weigth == w)) ? sort_vn.min2 : sort_vn.min1;
          cn_sign [w] <= sort_vn.vn_sign[pW*pT - 2 + w] ^ sort_vn.prod_sign;
        end
      end
    end
  end

  // register is outside of module
  always_comb begin
    for (int w = 0; w < pW; w++) begin
      ocnode[w] = (cn_abs[w] ^ {pNODE_W{cn_sign[w]}}) + cn_sign[w];
    end
  end

  // one tick early
  assign otcnt      = tcnt_out.val;
  assign otcnt_zero = tcnt_out.zero;
  assign ozcnt      = sort_vn.vn_zcnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function automatic vnode_t normalize (input vnode_t dat);
    logic [pNODE_W+2 : 0] tmp; // + 3 bit
  begin
    if (pUSE_NORM) begin //0.875
      case (cNORM_FACTOR)
        4       : begin // 0.5
          tmp = (dat <<< 2) + 4;
        end
        5       : begin // 0.625
          tmp = (dat <<< 2) + dat + 4;
        end
        6       : begin // 0.75
          tmp = (dat <<< 2) + (dat <<< 1) + 4;
        end
        default : begin // 0.875
          tmp = (dat <<< 3) - dat + 4;
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
