module row_render (
    input clk,
    input rst,
    input in_INIT,
    input in_BCM_FINISH,
    input in_NEXT_PLANE,
    input in_HUB75_WAITING,
    output reg out_render_finished,
    output reg out_BCM_INIT,
    output reg out_BCM_RST,
    output reg out_HUB75_LATCH,
    output reg out_BCM_CONTINUE,
    output reg out_PLANE_SELECT_P
);
  parameter START = 0;
  parameter BCM_INIT = 1;
  parameter CHECK = 2;
  parameter LATCH = 3;
  parameter NEXT = 4;
  parameter FINISH = 5;
  reg [2:0] state;

  always @(posedge clk) begin
    if (rst) begin
      if (in_INIT) begin
        out_render_finished = 0;
        out_BCM_INIT = 1;
        out_BCM_RST = 0;
        out_HUB75_LATCH = 0;
        out_BCM_CONTINUE = 0;
        out_PLANE_SELECT_P = 0;
        state = BCM_INIT;
      end else begin
        out_render_finished = 0;
        out_BCM_INIT = 0;
        out_BCM_RST = 1;
        out_HUB75_LATCH = 0;
        out_BCM_CONTINUE = 0;
        out_PLANE_SELECT_P = 0;
        state = START;
      end
    end else
      case (state)
        START: begin
          if (in_INIT) begin
            out_render_finished = 0;
            out_BCM_INIT = 1;
            out_BCM_RST = 0;
            out_HUB75_LATCH = 0;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = BCM_INIT;
          end else begin
            out_render_finished = 0;
            out_BCM_INIT = 0;
            out_BCM_RST = 1;
            out_HUB75_LATCH = 0;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = START;
          end
        end
        BCM_INIT: begin
          out_render_finished = 0;
          out_BCM_INIT = 0;
          out_BCM_RST = 0;
          out_HUB75_LATCH = 0;
          out_BCM_CONTINUE = 0;
          out_PLANE_SELECT_P = 0;
          state = CHECK;
        end
        CHECK: begin
          if (in_BCM_FINISH) begin
            out_render_finished = 1;
            out_BCM_INIT = 0;
            out_BCM_RST = 0;
            out_HUB75_LATCH = 0;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = FINISH;
          end else if (in_NEXT_PLANE & in_HUB75_WAITING) begin
            out_render_finished = 0;
            out_BCM_INIT = 0;
            out_BCM_RST = 0;
            out_HUB75_LATCH = 1;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = LATCH;
          end else begin
            out_render_finished = 0;
            out_BCM_INIT = 0;
            out_BCM_RST = 0;
            out_HUB75_LATCH = 0;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = CHECK;
          end
        end
        LATCH: begin
          out_render_finished = 0;
          out_BCM_INIT = 0;
          out_BCM_RST = 0;
          out_HUB75_LATCH = 0;
          out_BCM_CONTINUE = 0;
          out_PLANE_SELECT_P = 0;
          state = NEXT;
        end
        NEXT: begin
          out_render_finished = 0;
          out_BCM_INIT = 0;
          out_BCM_RST = 0;
          out_HUB75_LATCH = 0;
          out_BCM_CONTINUE = 1;
          out_PLANE_SELECT_P = 1;
          state = CHECK;
        end
        default: begin
          if (in_INIT) begin
            out_render_finished = 0;
            out_BCM_INIT = 1;
            out_BCM_RST = 0;
            out_HUB75_LATCH = 0;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = BCM_INIT;
          end else begin
            out_render_finished = 0;
            out_BCM_INIT = 0;
            out_BCM_RST = 1;
            out_HUB75_LATCH = 0;
            out_BCM_CONTINUE = 0;
            out_PLANE_SELECT_P = 0;
            state = START;
          end
        end
      endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: begin
        if (in_INIT) begin
          state_name = "START - INIT";
        end else begin
          state_name = "START - RST";
        end
      end
      BCM_INIT: state_name = "BCM_INIT";
      CHECK: begin
        if (in_BCM_FINISH) state_name = "CHECK - FINISH";
        else if (in_NEXT_PLANE + in_HUB75_WAITING) state_name = "CHECK - LATCH";
        else state_name = "CHECK";
      end
      LATCH : state_name = "LATCH";
      NEXT : state_name = "NEXT";
    endcase
  end
`endif
endmodule
