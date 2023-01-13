/*

  Generated using PSM version = 5.0




  logic          pc_3gpp_dec_sc_ctrl_state__iclk    ;
  logic          pc_3gpp_dec_sc_ctrl_state__isclr   ;
  logic          pc_3gpp_dec_sc_ctrl_state__ireset  ;
  logic          pc_3gpp_dec_sc_ctrl_state__iclkena ;
  logic [12 : 0] pc_3gpp_dec_sc_ctrl_state__br      ;
  logic [15 : 0] pc_3gpp_dec_sc_ctrl_state__out     ;
  logic [15 : 0] pc_3gpp_dec_sc_ctrl_state__out_r   ;



  pc_3gpp_dec_sc_ctrl_state
  pc_3gpp_dec_sc_ctrl_state
  (
    .iclk    ( pc_3gpp_dec_sc_ctrl_state__iclk    ) ,
    .isclr   ( pc_3gpp_dec_sc_ctrl_state__isclr   ) ,
    .ireset  ( pc_3gpp_dec_sc_ctrl_state__ireset  ) ,
    .iclkena ( pc_3gpp_dec_sc_ctrl_state__iclkena ) ,
    .br      ( pc_3gpp_dec_sc_ctrl_state__br      ) ,
    .out     ( pc_3gpp_dec_sc_ctrl_state__out     ) ,
    .out_r   ( pc_3gpp_dec_sc_ctrl_state__out_r   ) 
  );


  assign pc_3gpp_dec_sc_ctrl_state__iclk    = '0 ;
  assign pc_3gpp_dec_sc_ctrl_state__isclr   = '0 ;
  assign pc_3gpp_dec_sc_ctrl_state__ireset  = '0 ;
  assign pc_3gpp_dec_sc_ctrl_state__iclkena = '0 ;
  assign pc_3gpp_dec_sc_ctrl_state__br      = '0 ;



*/ 



module pc_3gpp_dec_sc_ctrl_state
(
  iclk    ,
  isclr   ,
  ireset  ,
  iclkena ,
  br      ,
  out     ,
  out_r   
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk    ;
  input  logic          isclr   ;
  input  logic          ireset  ;
  input  logic          iclkena ;
  input  logic [12 : 0] br      ;
  output logic [15 : 0] out     ;
  output logic [15 : 0] out_r   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef enum logic [4:0] {
    RESET           = 5'd0 ,
    WAIT_BUFFERREAY = 5'd1 ,
    DOSTART         = 5'd2 ,
    DOSTART_1       = 5'd3 ,
    FG512           = 5'd4 ,
    FG256           = 5'd5 ,
    FG128           = 5'd6 ,
    FG64            = 5'd7 ,
    FG32            = 5'd8 ,
    FG16            = 5'd9 ,
    FG16_1          = 5'd10 ,
    FG8             = 5'd11 ,
    FG8_1           = 5'd12 ,
    DO_8X8          = 5'd13 ,
    G8              = 5'd14 ,
    G8_1            = 5'd15 ,
    DO_8X8G         = 5'd16 ,
    COMB8           = 5'd17 ,
    COMB8_1         = 5'd18 ,
    COMB8_2         = 5'd19 ,
    COMB16          = 5'd20 ,
    COMB32          = 5'd21 ,
    COMB64          = 5'd22 ,
    COMB128         = 5'd23 ,
    COMB256         = 5'd24 ,
    COMB512         = 5'd25 ,
    DONE            = 5'd26 ,
    F_DO_8X8        = 5'd27 ,
    F_DO_8X8_1      = 5'd28 ,
    F_DO_8X8_2      = 5'd29 ,
    F_DO_8X8_3      = 5'd30 
  } state_t;

  state_t          state          ;
  state_t          next_state     ;
  state_t          ret_state      ;
  state_t          next_ret_state ;
  logic   [15 : 0] out_moore      ;
  logic   [15 : 0] next_out_moore ;
  logic   [15 : 0] out_mealy      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // state register process
  //
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      state <= RESET;
    else if (isclr)
      state <= RESET;
    else if (iclkena)
      state <= next_state;
  end
  //
  // state register process
  //
  always_ff @(posedge iclk) begin
    if (iclkena)
      ret_state <= next_ret_state;
  end
  //
  // state jump process
  //
  always_comb begin
  
    next_state      = RESET;
    next_ret_state  = ret_state;

    unique case (state)

      RESET           : begin
          next_state = WAIT_BUFFERREAY;
      end

      WAIT_BUFFERREAY : begin
        if (br[0] & br[1]) begin
          next_state = DOSTART;
        end
        else begin
          next_state = WAIT_BUFFERREAY;
        end
      end

      DOSTART         : begin
          next_state = DOSTART_1;
      end

      DOSTART_1       : begin
        if (br[8]) begin
          next_state = FG512;
        end
        else if (br[7]) begin
          next_state = FG256;
        end
        else if (br[6]) begin
          next_state = FG128;
        end
        else if (br[5]) begin
          next_state = FG64;
        end
        else if (br[4]) begin
          next_state = FG32;
        end
        else if (br[3]) begin
          next_state = FG16;
        end
        else begin
          next_state = FG8;
        end
      end

      FG512           : begin
        if (br[2]) begin
          next_state = FG256;
        end
        else begin
          next_state = FG512;
        end
      end

      FG256           : begin
        if (br[2]) begin
          next_state = FG128;
        end
        else begin
          next_state = FG256;
        end
      end

      FG128           : begin
        if (br[2]) begin
          next_state = FG64;
        end
        else begin
          next_state = FG128;
        end
      end

      FG64            : begin
        if (br[2]) begin
          next_state = FG32;
        end
        else begin
          next_state = FG64;
        end
      end

      FG32            : begin
        if (br[2]) begin
          next_state = FG16;
        end
        else begin
          next_state = FG32;
        end
      end

      FG16            : begin
        if (br[2]) begin
          next_state = FG16_1;
        end
        else begin
          next_state = FG16;
        end
      end

      FG16_1          : begin
          next_state = FG8;
      end

      FG8             : begin
          next_state = FG8_1;
      end

      FG8_1           : begin
          next_state = DO_8X8;
      end

      DO_8X8          : begin
        if (br[11]) begin
          next_state = G8;
        end
        else begin
          next_state = F_DO_8X8; next_ret_state = G8;
        end
      end

      G8              : begin
          next_state = G8_1;
      end

      G8_1            : begin
          next_state = DO_8X8G;
      end

      DO_8X8G         : begin
        if (br[11]) begin
          next_state = COMB8;
        end
        else begin
          next_state = F_DO_8X8; next_ret_state = COMB8;
        end
      end

      COMB8           : begin
          next_state = COMB8_1;
      end

      COMB8_1         : begin
        if (br[9]) begin
          next_state = COMB8_2;
        end
        else begin
          next_state = DOSTART;
        end
      end

      COMB8_2         : begin
          next_state = COMB16;
      end

      COMB16          : begin
        if (br[2] & br[9]) begin
          next_state = COMB32;
        end
        else if (br[2]) begin
          next_state = DOSTART;
        end
        else begin
          next_state = COMB16;
        end
      end

      COMB32          : begin
        if (br[2] & br[9]) begin
          next_state = COMB64;
        end
        else if (br[2]) begin
          next_state = DOSTART;
        end
        else begin
          next_state = COMB32;
        end
      end

      COMB64          : begin
        if (br[2] & br[9]) begin
          next_state = COMB128;
        end
        else if (br[2]) begin
          next_state = DOSTART;
        end
        else begin
          next_state = COMB64;
        end
      end

      COMB128         : begin
        if (br[2] & br[9]) begin
          next_state = COMB256;
        end
        else if (br[2]) begin
          next_state = DOSTART;
        end
        else begin
          next_state = COMB128;
        end
      end

      COMB256         : begin
        if (br[2] & br[9]) begin
          next_state = COMB512;
        end
        else if (br[2]) begin
          next_state = DOSTART;
        end
        else begin
          next_state = COMB256;
        end
      end

      COMB512         : begin
        if (br[2]) begin
          next_state = DONE;
        end
        else begin
          next_state = COMB512;
        end
      end

      DONE            : begin
          next_state = WAIT_BUFFERREAY;
      end

      F_DO_8X8        : begin
          next_state = F_DO_8X8_1;
      end

      F_DO_8X8_1      : begin
        if (br[12]) begin
          next_state = ret_state;
        end
        else begin
          next_state = F_DO_8X8_2;
        end
      end

      F_DO_8X8_2      : begin
          next_state = F_DO_8X8_3;
      end

      F_DO_8X8_3      : begin
          next_state = ret_state;
      end

    endcase

  end
  //
  // next_more decode process
  //
  always_comb begin
  
    out_mealy = 16'd0;

    unique case (state)

      RESET           : begin
      end

      WAIT_BUFFERREAY : begin
      end

      DOSTART         : begin
      end

      DOSTART_1       : begin
      end

      FG512           : begin
      end

      FG256           : begin
      end

      FG128           : begin
      end

      FG64            : begin
      end

      FG32            : begin
      end

      FG16            : begin
      end

      FG16_1          : begin
      end

      FG8             : begin
      end

      FG8_1           : begin
      end

      DO_8X8          : begin
      end

      G8              : begin
      end

      G8_1            : begin
      end

      DO_8X8G         : begin
      end

      COMB8           : begin
      end

      COMB8_1         : begin
      end

      COMB8_2         : begin
      end

      COMB16          : begin
      end

      COMB32          : begin
      end

      COMB64          : begin
      end

      COMB128         : begin
      end

      COMB256         : begin
      end

      COMB512         : begin
      end

      DONE            : begin
      end

      F_DO_8X8        : begin
      end

      F_DO_8X8_1      : begin
      end

      F_DO_8X8_2      : begin
      end

      F_DO_8X8_3      : begin
      end

    endcase

  end

  //
  // next_more decode process
  //
  always_comb begin
  
    next_out_moore = 16'd0;

    unique case (next_state)

      RESET           : begin
      end

      WAIT_BUFFERREAY : begin
        next_out_moore[2] = 1'b1;
        next_out_moore[4] = 1'b1;
        next_out_moore[6] = 1'b1;
      end

      DOSTART         : begin
        next_out_moore[5] = 1'b1;
      end

      DOSTART_1       : begin
      end

      FG512           : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[12] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG256           : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG128           : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG64            : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG32            : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG16            : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG16_1          : begin
      end

      FG8             : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      FG8_1           : begin
        next_out_moore[6] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      DO_8X8          : begin
        next_out_moore[5] = 1'b1;
        next_out_moore[12] = 1'b1;
      end

      G8              : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      G8_1            : begin
        next_out_moore[6] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
        next_out_moore[15] = 1'b1;
      end

      DO_8X8G         : begin
        next_out_moore[12] = 1'b1;
      end

      COMB8           : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB8_1         : begin
        next_out_moore[6] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB8_2         : begin
      end

      COMB16          : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB32          : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB64          : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB128         : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB256         : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      COMB512         : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[8] = 1'b1;
        next_out_moore[12] = 1'b1;
        next_out_moore[13] = 1'b1;
        next_out_moore[14] = 1'b1;
      end

      DONE            : begin
        next_out_moore[0] = 1'b1;
        next_out_moore[1] = 1'b1;
      end

      F_DO_8X8        : begin
        next_out_moore[12] = 1'b1;
        next_out_moore[13] = 1'b1;
      end

      F_DO_8X8_1      : begin
        next_out_moore[12] = 1'b1;
        next_out_moore[13] = 1'b1;
      end

      F_DO_8X8_2      : begin
        next_out_moore[12] = 1'b1;
        next_out_moore[13] = 1'b1;
      end

      F_DO_8X8_3      : begin
        next_out_moore[12] = 1'b1;
        next_out_moore[13] = 1'b1;
      end

    endcase
  end

  //
  // more register process
  //
  assign out = out_moore | out_mealy;
  
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      out_moore   <= 16'd0;
      out_r       <= 16'd0;
    end
    else if (isclr) begin
      out_moore   <= 16'd0;
      out_r       <= 16'd0;
    end
    else if (iclkena) begin
      out_moore   <= next_out_moore;
      out_r       <= out;
    end
  end


endmodule
