module control_raiz (
    clk,
    rst,
    in_init,
    in_Q,
    in_K,
    out_S1,
    out_S2,
    out_S3,
    out_S4,
    out_RST,
    out_DONE
);
  input clk;
  input rst;
  input in_init;
  input [15:0]in_Q;
  input in_K;
  output reg out_S1;
  output reg out_S2;
  output reg out_S3;
  output reg out_S4;
  output reg out_RST;
  output reg out_DONE;
  parameter START = 3'b000;
  parameter STEP1 = 3'b001;
  parameter CHECK = 3'b010;
  parameter OPERATE = 3'b011;
  parameter ITERATE = 3'b100;
  parameter DONE = 3'b101;
  parameter STEP2 = 3'b110;

  reg [2:0] state;

  always @(posedge clk) begin
    if (rst) state = START;
    else begin
      case (state)
        START: begin
          state = in_init ? STEP1 : START;
        end
        STEP1:   state = CHECK;
        CHECK: begin
          state = in_Q[15] ? ITERATE : OPERATE;
        end
        OPERATE: state = ITERATE;
        ITERATE: begin
          state = in_K ? DONE : STEP2;
        end
        STEP2:   state = STEP1;
        default: state = START;
      endcase
    end
  end

  always @(*) begin
    case (state)
      START: begin
        out_RST  = 1;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_S4   = 0;
        out_DONE = 0;
      end
      STEP1: begin
        out_RST  = 0;
        out_S1   = 1;
        out_S2   = 0;
        out_S3   = 0;
        out_S4   = 0;
        out_DONE = 0;
      end
      CHECK: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_S4   = 0;
        out_DONE = 0;
      end
      OPERATE: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 1;
        out_S3   = 0;
        out_S4   = 0;
        out_DONE = 0;
      end
      ITERATE: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 1;
        out_S4   = 0;
        out_DONE = 0;
      end
      STEP2: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_S4   = 1;
        out_DONE = 0;
      end
      DONE: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_S4   = 0;
        out_DONE = 1;
      end
      default: begin
        out_RST  = 1;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_S4   = 0;
        out_DONE = 0;
      end
    endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      STEP1: state_name = "STEP1";
      CHECK: state_name = "CHECK";
      OPERATE: state_name = "OPERATE";
      ITERATE: state_name = "ITERATE";
      STEP2: state_name = "STEP2";
      DONE: state_name = "DONE";
    endcase

  end
`endif

endmodule