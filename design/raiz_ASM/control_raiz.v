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
  input [15:0] in_Q;
  input in_K;
  output reg out_S1;
  output reg out_S2;
  output reg out_S3;
  output reg out_S4;
  output reg out_RST;
  output reg out_DONE;
  parameter START   = 4'b0000;
  parameter STEP1   = 4'b0001;
  parameter CHECK   = 4'b0010;
  parameter OPERATE = 4'b0011;
  parameter ITERATE = 4'b0100;
  parameter DONE    = 4'b0101;
  parameter STEP2   = 4'b0110;

  reg [3:0] state;

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
      START:   state_name    = "START";
      STEP1:   state_name    = "STEP1";
      CHECK:   state_name    = "CHECK";
      OPERATE: state_name    = "OPERATE";
      ITERATE: state_name    = "ITERATE";
      STEP2:   state_name    = "STEP2";
      DONE:    state_name    = "DONE";
    endcase

  end
`endif

endmodule
