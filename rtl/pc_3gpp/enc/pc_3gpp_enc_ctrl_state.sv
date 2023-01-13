/*

  Generated using PSM version = 5.0




  logic          pc_3gpp_enc_ctrl_state__iclk    ;
  logic          pc_3gpp_enc_ctrl_state__isclr   ;
  logic          pc_3gpp_enc_ctrl_state__ireset  ;
  logic          pc_3gpp_enc_ctrl_state__iclkena ;
  logic  [3 : 0] pc_3gpp_enc_ctrl_state__br      ;
  logic [14 : 0] pc_3gpp_enc_ctrl_state__out     ;
  logic [14 : 0] pc_3gpp_enc_ctrl_state__out_r   ;



  pc_3gpp_enc_ctrl_state
  pc_3gpp_enc_ctrl_state
  (
    .iclk    ( pc_3gpp_enc_ctrl_state__iclk    ) ,
    .isclr   ( pc_3gpp_enc_ctrl_state__isclr   ) ,
    .ireset  ( pc_3gpp_enc_ctrl_state__ireset  ) ,
    .iclkena ( pc_3gpp_enc_ctrl_state__iclkena ) ,
    .br      ( pc_3gpp_enc_ctrl_state__br      ) ,
    .out     ( pc_3gpp_enc_ctrl_state__out     ) ,
    .out_r   ( pc_3gpp_enc_ctrl_state__out_r   ) 
  );


  assign pc_3gpp_enc_ctrl_state__iclk    = '0 ;
  assign pc_3gpp_enc_ctrl_state__isclr   = '0 ;
  assign pc_3gpp_enc_ctrl_state__ireset  = '0 ;
  assign pc_3gpp_enc_ctrl_state__iclkena = '0 ;
  assign pc_3gpp_enc_ctrl_state__br      = '0 ;



*/ 



module pc_3gpp_enc_ctrl_state
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
  input  logic  [3 : 0] br      ;
  output logic [14 : 0] out     ;
  output logic [14 : 0] out_r   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef enum logic [3:0] {
    RESET           = 4'd0 ,
    WAIT_BUFFERREAY = 4'd1 ,
    DO_8X8          = 4'd2 ,
    DO_8X8_1        = 4'd3 ,
    COMB8           = 4'd4 ,
    COMB8_1         = 4'd5 ,
    COMB16          = 4'd6 ,
    COMB32          = 4'd7 ,
    COMB64          = 4'd8 ,
    COMB128         = 4'd9 ,
    COMB256         = 4'd10 ,
    COMB512         = 4'd11 ,
    DONE            = 4'd12 
  } state_t;

  state_t          state          ;
  state_t          next_state     ;
  logic   [14 : 0] out_moore      ;
  logic   [14 : 0] next_out_moore ;
  logic   [14 : 0] out_mealy      ;

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
  // state jump process
  //
  always_comb begin
  
    next_state = RESET;

    unique case (state)

      RESET           : begin
          next_state = WAIT_BUFFERREAY;
      end

      WAIT_BUFFERREAY : begin
        if (br[0] & br[1]) begin
          next_state = DO_8X8;
        end
        else begin
          next_state = WAIT_BUFFERREAY;
        end
      end

      DO_8X8          : begin
          next_state = DO_8X8_1;
      end

      DO_8X8_1        : begin
          next_state = COMB8;
      end

      COMB8           : begin
          next_state = COMB8_1;
      end

      COMB8_1         : begin
        if (br[3]) begin
          next_state = COMB16;
        end
        else begin
          next_state = DO_8X8;
        end
      end

      COMB16          : begin
        if (br[2] & br[3]) begin
          next_state = COMB32;
        end
        else if (br[2]) begin
          next_state = DO_8X8;
        end
        else begin
          next_state = COMB16;
        end
      end

      COMB32          : begin
        if (br[2] & br[3]) begin
          next_state = COMB64;
        end
        else if (br[2]) begin
          next_state = DO_8X8;
        end
        else begin
          next_state = COMB32;
        end
      end

      COMB64          : begin
        if (br[2] & br[3]) begin
          next_state = COMB128;
        end
        else if (br[2]) begin
          next_state = DO_8X8;
        end
        else begin
          next_state = COMB64;
        end
      end

      COMB128         : begin
        if (br[2] & br[3]) begin
          next_state = COMB256;
        end
        else if (br[2]) begin
          next_state = DO_8X8;
        end
        else begin
          next_state = COMB128;
        end
      end

      COMB256         : begin
        if (br[2] & br[3]) begin
          next_state = COMB512;
        end
        else if (br[2]) begin
          next_state = DO_8X8;
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

    endcase

  end
  //
  // next_more decode process
  //
  always_comb begin
  
    out_mealy = 15'd0;

    unique case (state)

      RESET           : begin
      end

      WAIT_BUFFERREAY : begin
      end

      DO_8X8          : begin
      end

      DO_8X8_1        : begin
      end

      COMB8           : begin
      end

      COMB8_1         : begin
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

    endcase

  end

  //
  // next_more decode process
  //
  always_comb begin
  
    next_out_moore = 15'd0;

    unique case (next_state)

      RESET           : begin
      end

      WAIT_BUFFERREAY : begin
        next_out_moore[2] = 1'b1;
        next_out_moore[4] = 1'b1;
        next_out_moore[6] = 1'b1;
      end

      DO_8X8          : begin
        next_out_moore[5] = 1'b1;
        next_out_moore[12] = 1'b1;
      end

      DO_8X8_1        : begin
        next_out_moore[5] = 1'b1;
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

      COMB16          : begin
        next_out_moore[7] = 1'b1;
        next_out_moore[9] = 1'b1;
        next_out_moore[10] = 1'b1;
        next_out_moore[12] = 1'b1;
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

    endcase
  end

  //
  // more register process
  //
  assign out = out_moore | out_mealy;
  
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      out_moore   <= 15'd0;
      out_r       <= 15'd0;
    end
    else if (isclr) begin
      out_moore   <= 15'd0;
      out_r       <= 15'd0;
    end
    else if (iclkena) begin
      out_moore   <= next_out_moore;
      out_r       <= out;
    end
  end


endmodule
