module simple_turn_on (
    input clk,
    input resetn,
    output reg A,
    B,
    C,
    D,
    E,
    output reg R0,
    G0,
    B0,
    output reg R1,
    G1,
    B1,
    output reg LATCH,
    output reg nOE,  //Active Low
    output reg S_CLK,
    output reg LEDS
);

  reg [5:0] reg_ROW;
  reg reg_ROW_RST;
  reg reg_ROW_P;
  reg [6:0] reg_LED;
  reg reg_LED_RST;
  reg reg_LED_L;
  reg [2:0] reg_COLOR0;
  reg [2:0] reg_COLOR1;
  reg reg_FINISH_S;
  reg reg_EN_CLK;
  parameter START = 3'b000;
  parameter ITER_LED = 3'b001;
  parameter ITER_ROW = 3'b010;
  parameter SHOW = 3'b011;
  parameter FINISH = 3'b100;
  reg [2:0] state;


  always @(negedge clk) begin
    if (!resetn) begin
      state = START;
      reg_COLOR0 = 3'b111;
      reg_COLOR1 = 3'b000;
    end else begin
      case (state)
        START:   state = ITER_LED;
        ITER_LED: begin
          if (reg_LED == 0) state = ITER_ROW;
          else state = ITER_LED;
        end
        ITER_ROW: begin
          state = SHOW;
        end
        SHOW: begin
          if (reg_ROW == 32) state = FINISH;
          else state = FINISH;
        end
        default: state = FINISH;
      endcase
    end
  end

  always @(posedge clk) begin
    if (reg_ROW_RST) reg_ROW = 0;
    if (reg_LED_RST) reg_LED = 64;
    if (reg_ROW_P) reg_ROW = reg_ROW + 1;
    if (reg_LED_L) reg_LED = reg_LED - 1;
  end

  always @(*) begin
    S_CLK = clk & reg_EN_CLK;
  end
  always @(*) begin
    A  = reg_ROW[0];
    B  = reg_ROW[1];
    C  = reg_ROW[2];
    D  = reg_ROW[3];
    E  = reg_ROW[4];
    R0 = reg_COLOR0[0];
    G0 = reg_COLOR0[1];
    B0 = reg_COLOR0[2];
    R1 = reg_COLOR1[0];
    G1 = reg_COLOR1[1];
    B1 = reg_COLOR1[2];
  end
  always @(*) begin
    case (state)
      START: begin
        reg_LED_RST = 1;
        reg_LED_L = 0;
        reg_FINISH_S = 0;
        reg_ROW_P = 0;
        reg_ROW_RST = 1;
        reg_EN_CLK = 0;
        LATCH = 0;
        nOE = 0;
        LEDS = 1;
      end
      ITER_LED: begin
        reg_LED_RST = 0;
        reg_LED_L = 1;
        reg_FINISH_S = 0;
        reg_ROW_P = 0;
        reg_ROW_RST = 0;
        reg_EN_CLK = 1;
        LATCH = 0;
        nOE = 0;
        LEDS = 1;
      end
      ITER_ROW: begin
        reg_LED_RST = 1;
        reg_LED_L = 0;
        reg_FINISH_S = 0;
        reg_ROW_P = 0;
        reg_ROW_RST = 0;
        reg_EN_CLK = 0;
        LATCH = 1;
        nOE = 0;
        LEDS = 1;
      end
      SHOW: begin
        reg_LED_RST = 0;
        reg_LED_L = 0;
        reg_FINISH_S = 0;
        reg_ROW_P = 0;
        reg_ROW_RST = 0;
        reg_EN_CLK = 0;
        LATCH = 0;
        nOE = 1;
        LEDS = 1;
      end
      FINISH: begin
        reg_LED_RST = 0;
        reg_LED_L = 0;
        reg_FINISH_S = 1;
        reg_ROW_P = 0;
        reg_ROW_RST = 0;
        reg_EN_CLK = 0;
        LATCH = 0;
        nOE = 1;
        LEDS = 0;
      end
      default: begin
        reg_LED_RST = 1;
        reg_LED_L = 0;
        reg_FINISH_S = 0;
        reg_ROW_P = 0;
        reg_ROW_RST = 1;
        reg_EN_CLK = 0;
        LATCH = 0;
        nOE = 1;
        LEDS = 1;
      end
    endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      ITER_LED: state_name = "ITER_LED";
      ITER_ROW: state_name = "ITER_ROW";
      FINISH: state_name = "FINISH";
    endcase
  end
`endif


endmodule
