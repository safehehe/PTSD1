module control_raiz (
    clk,
    rst,
    in_init,
    in_Z,
    in_K,
    out_S1,
    out_S2,
    out_S3,
    out_DONE
);
  input clk;
  input rst;
  input in_init;
  input in_Z;
  input in_K;
  output reg out_S1;
  output reg out_S2;
  output reg out_S3;
  output reg out_RST;
  output reg out_DONE;
  parameter START = 3'b000;
  parameter STEP = 3'b001;
  parameter CHECK = 3'b010;
  parameter OPERATE = 3'b011;
  parameter ITERATE = 3'b100;
  parameter DONE = 3'b101;

  reg [2:0] state;

  always @(posedge clk) begin
    if (rst) state = START;
    else begin
      case (state)
        START: begin
          state = in_init ? STEP : START;
        end
        STEP: state = CHECK;
        CHECK: begin
          state = in_Z ? OPERATE : ITERATE;
        end
        OPERATE: state = ITERATE;
        ITERATE: begin
          state = in_K ? DONE : STEP;
        end
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
        out_DONE = 0;
      end
      STEP: begin
        out_RST  = 0;
        out_S1   = 1;
        out_S2   = 0;
        out_S3   = 0;
        out_DONE = 0;
      end
      CHECK: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_DONE = 0;
      end
      OPERATE: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 1;
        out_S3   = 0;
        out_DONE = 0;
      end
      ITERATE: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 1;
        out_DONE = 0;
      end
      DONE: begin
        out_RST  = 0;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_DONE = 1;
      end
      default: begin
        out_RST  = 1;
        out_S1   = 0;
        out_S2   = 0;
        out_S3   = 0;
        out_DONE = 0;
      end
    endcase
  end
endmodule
