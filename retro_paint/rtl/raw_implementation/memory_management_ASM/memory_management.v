module memory_management (
    input clk,
    input rst,
    input in_CACHE,
    input [4:0] in_ROW,
    input [1:0] in_PLANE_SELECT,
    input in_SHIFT_PLANE,
    input [5:0] in_RGB01,
    input [511:0] in_FUSED_DATA,

    output reg out_PLANE_READY,
    output reg out_PLANE_LOAD0,
    output reg out_PLANE_LOAD1,
    output reg out_PLANE_SHIFT,
    output [2:0] out_RGB0,
    output [2:0] out_RGB1,
    output [63:0] out_R,
    output [63:0] out_G,
    output [63:0] out_B,
    output [5:0] out_ADDR,
    output reg out_RD
);
  reg reg_PAD_ADDR;

  assign out_ADDR = {reg_PAD_ADDR, in_ROW};

  assign out_RGB0 = in_RGB01[5:3];
  assign out_RGB1 = in_RGB01[2:0];

  plane_selection u_plane_selection (
      .in_selection     (in_PLANE_SELECT),
      .in_row_data      (in_FUSED_DATA),
      .out_red_channel  (out_R),
      .out_green_channel(out_G),
      .out_blue_channel (out_B)
  );

  reg [2:0] state;
  parameter START = 3'd0;
  parameter SHIFT_P = 3'd1;
  parameter S_CACHE0 = 3'd2;
  parameter S_LOAD0 = 3'd3;
  parameter S_CACHE1 = 3'd4;
  parameter S_LOAD1 = 3'd5;
  parameter DONE = 3'd6;

  always @(negedge clk) begin
    if (rst) begin
      state = START;
      out_RD = 0;
      out_PLANE_SHIFT = 0;
      out_PLANE_LOAD0 = 0;
      out_PLANE_LOAD1 = 0;
      out_PLANE_READY = 0;
      reg_PAD_ADDR = 0;
    end else
      case (state)
        START: begin
          if (in_SHIFT_PLANE) begin
            out_RD = 0;
            out_PLANE_SHIFT = 1;
            out_PLANE_LOAD0 = 0;
            out_PLANE_LOAD1 = 0;
            out_PLANE_READY = 0;
            reg_PAD_ADDR = 0;
            state = SHIFT_P;
          end else if (in_CACHE) begin
            out_RD = 1;
            out_PLANE_SHIFT = 0;
            out_PLANE_LOAD0 = 0;
            out_PLANE_LOAD1 = 0;
            out_PLANE_READY = 0;
            reg_PAD_ADDR = 0;
            state = S_CACHE0;
          end
        end
        SHIFT_P: begin
          if (in_SHIFT_PLANE) begin
            out_RD = 0;
            out_PLANE_SHIFT = 1;
            out_PLANE_LOAD0 = 0;
            out_PLANE_LOAD1 = 0;
            out_PLANE_READY = 0;
            reg_PAD_ADDR = 0;
            state = SHIFT_P;
          end else begin
            out_RD = 0;
            out_PLANE_SHIFT = 0;
            out_PLANE_LOAD0 = 0;
            out_PLANE_LOAD1 = 0;
            out_PLANE_READY = 0;
            reg_PAD_ADDR = 0;
            state = START;
          end
        end
        S_CACHE0: begin
          out_RD = 0;
          out_PLANE_SHIFT = 0;
          out_PLANE_LOAD0 = 1;
          out_PLANE_LOAD1 = 0;
          out_PLANE_READY = 0;
          reg_PAD_ADDR = 0;
          state = S_LOAD0;
        end
        S_LOAD0: begin
          out_RD = 1;
          out_PLANE_SHIFT = 0;
          out_PLANE_LOAD0 = 0;
          out_PLANE_LOAD1 = 0;
          out_PLANE_READY = 0;
          reg_PAD_ADDR = 1;
          state = S_CACHE1;
        end
        S_CACHE1: begin
          out_RD = 0;
          out_PLANE_SHIFT = 0;
          out_PLANE_LOAD0 = 0;
          out_PLANE_LOAD1 = 1;
          out_PLANE_READY = 0;
          reg_PAD_ADDR = 1;
          state = S_LOAD1;
        end
        S_LOAD1: begin
          out_RD = 0;
          out_PLANE_SHIFT = 0;
          out_PLANE_LOAD0 = 0;
          out_PLANE_LOAD1 = 0;
          out_PLANE_READY = 1;
          reg_PAD_ADDR = 0;
          state = DONE;
        end
        DONE: begin
          out_RD = 0;
          out_PLANE_SHIFT = 0;
          out_PLANE_LOAD0 = 0;
          out_PLANE_LOAD1 = 0;
          out_PLANE_READY = 0;
          reg_PAD_ADDR = 0;
          state = START;
        end
        default: begin
          if (in_SHIFT_PLANE) begin
            out_RD = 0;
            out_PLANE_SHIFT = 1;
            out_PLANE_LOAD0 = 0;
            out_PLANE_LOAD1 = 0;
            out_PLANE_READY = 0;
            reg_PAD_ADDR = 0;
            state = SHIFT_P;
          end else if (in_CACHE) begin
            out_RD = 1;
            out_PLANE_SHIFT = 0;
            out_PLANE_LOAD0 = 0;
            out_PLANE_LOAD1 = 0;
            out_PLANE_READY = 0;
            reg_PAD_ADDR = 0;
            state = S_CACHE0;
          end
        end
      endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      SHIFT_P: state_name = "SHIFT_P";
      S_CACHE0: state_name = "S_CACHE0";
      S_LOAD0: state_name = "S_LOAD0";
      S_CACHE1: state_name = "S_CACHE1";
      S_LOAD1: state_name = "S_LOAD1";
      DONE: state_name = "DONE";
    endcase
  end
`endif
endmodule
