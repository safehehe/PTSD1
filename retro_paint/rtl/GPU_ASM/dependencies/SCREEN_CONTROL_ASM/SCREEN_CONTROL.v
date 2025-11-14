module SCREEN_CONTROL #(
    parameter RESOLUTION = 3
) (
    input clk,
    input rst,
    input in_signal_PLANE_READY_MM,
    input in_signal_HUB75_WAITING,
    input in_signal_HUB75_ITER,
    output wire out_signal_BRIGHT_DIM,
    output out_signal_SHIFT_PLANE,
    output wire [1:0] out_PLANE_SELECT_MM,
    output wire out_signal_CACHE,
    output wire out_signal_HUB75_INIT,
    output out_signal_HUB75_SHOW,
    output [4:0] out_ROW,
    output out_RST
);
  assign out_signal_SHIFT_PLANE = in_signal_HUB75_ITER;
  assign out_signal_HUB75_SHOW  = reg_HUB75_SHOW;
  assign out_signal_HUB75_INIT = reg_HUB75_INIT+w_inter_HUB75_INIT;
  wire w_inter_HUB75_INIT;
  wire w_inter_HUB75_SHOW;
  assign out_RST = reg_RST;
  reg  reg_RST;
  reg  reg_HUB75_INIT;
  reg  reg_CACHE_INIT;
  reg  reg_ROW_P;
  reg  reg_PLANE_SELECT_P;
  reg  reg_BCM_INIT;
  reg  reg_BCM_PLS_RST;
  reg  reg_BCM_CONTINUE;
  reg  reg_HUB75_SHOW;
  wire w_BCM_FINISH;
  wire w_BCM_NEXT_PLANE;

  parameter START = 0;
  parameter ONCE_CACHE_WAITING = 1;
  parameter ONCE_SHOW = 2;
  parameter BCM_INIT_Y_CACHE = 3;
  parameter WORKING = 4;
  parameter HUB75_SHOW = 5;
  parameter PLANE_P = 6;
  parameter LAST_SHOW = 7;
  parameter CACHE_CLEAN = 8;
  reg [3:0] state;
  always @(negedge clk) begin
    if (rst) begin
      reg_RST = 1;
      reg_CACHE_INIT = 0;
      reg_ROW_P = 0;
      reg_PLANE_SELECT_P = 0;
      reg_BCM_INIT = 0;
      reg_BCM_PLS_RST = 1;
      reg_BCM_CONTINUE = 0;
      reg_HUB75_SHOW = 0;
      reg_HUB75_INIT = 0;
      state = START;
    end else
      case (state)
        START: begin
          reg_RST = 0;
          reg_CACHE_INIT = 1;
          reg_ROW_P = 0;
          reg_PLANE_SELECT_P = 0;
          reg_BCM_INIT = 0;
          reg_BCM_PLS_RST = 0;
          reg_BCM_CONTINUE = 0;
          reg_HUB75_SHOW = 0;
          reg_HUB75_INIT = 0;
          state = ONCE_CACHE_WAITING;
        end
        ONCE_CACHE_WAITING: begin
          if (in_signal_HUB75_WAITING) begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 1;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 0;
            reg_HUB75_SHOW = 1;
            reg_HUB75_INIT = 0;
            state = ONCE_SHOW;
          end else begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 0;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 0;
            reg_HUB75_SHOW = 0;
            reg_HUB75_INIT = 0;
            state = ONCE_CACHE_WAITING;
          end
        end
        ONCE_SHOW: begin
          reg_RST = 0;
          reg_CACHE_INIT = 1;
          reg_ROW_P = 0;
          reg_PLANE_SELECT_P = 0;
          reg_BCM_INIT = 1;
          reg_BCM_PLS_RST = 0;
          reg_BCM_CONTINUE = 0;
          reg_HUB75_SHOW = 1;
          reg_HUB75_INIT = 0;
          state = BCM_INIT_Y_CACHE;
        end
        BCM_INIT_Y_CACHE: begin
          reg_RST = 0;
          reg_CACHE_INIT = 0;
          reg_ROW_P = 0;
          reg_PLANE_SELECT_P = 0;
          reg_BCM_INIT = 0;
          reg_BCM_PLS_RST = 0;
          reg_BCM_CONTINUE = 0;
          reg_HUB75_SHOW = 1;
          reg_HUB75_INIT = 0;
          state = WORKING;
        end
        WORKING: begin
          if (w_BCM_FINISH) begin
            if (out_ROW == 31) begin
              reg_RST = 1;
              reg_CACHE_INIT = 0;
              reg_ROW_P = 0;
              reg_PLANE_SELECT_P = 0;
              reg_BCM_INIT = 0;
              reg_BCM_PLS_RST = 1;
              reg_BCM_CONTINUE = 0;
              reg_HUB75_SHOW = 1;
              reg_HUB75_INIT = 0;
              state = LAST_SHOW;
            end else begin
              reg_RST = 0;
              reg_CACHE_INIT = 0;
              reg_ROW_P = 1;
              reg_PLANE_SELECT_P = 0;
              reg_BCM_INIT = 0;
              reg_BCM_PLS_RST = 1;
              reg_BCM_CONTINUE = 0;
              reg_HUB75_SHOW = 1;
              reg_HUB75_INIT = 0;
              state = LAST_SHOW;
            end
          end else if (in_signal_HUB75_WAITING & w_BCM_NEXT_PLANE) begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 0;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 0;
            reg_HUB75_SHOW = 1;
            reg_HUB75_INIT = 0;
            state = HUB75_SHOW;
          end else begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 0;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 0;
            reg_HUB75_SHOW = 0;
            reg_HUB75_INIT = 0;
            state = WORKING;
          end
        end
        LAST_SHOW: begin
          reg_RST = 0;
          reg_CACHE_INIT = 0;
          reg_ROW_P = 0;
          reg_PLANE_SELECT_P = 0;
          reg_BCM_INIT = 0;
          reg_BCM_PLS_RST = 0;
          reg_BCM_CONTINUE = 0;
          reg_HUB75_SHOW = 0;
          reg_HUB75_INIT = 0;
          state = START;
        end
        HUB75_SHOW: begin
          if (out_PLANE_SELECT_MM == (RESOLUTION - 1)) begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 0;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 1;
            reg_HUB75_SHOW = 0;
            reg_HUB75_INIT = 0;
            state = CACHE_CLEAN;
          end else begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 1;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 1;
            reg_HUB75_SHOW = 0;
            reg_HUB75_INIT = 0;
            state = PLANE_P;
          end
        end
        CACHE_CLEAN: begin
          reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_ROW_P = 0;
            reg_PLANE_SELECT_P = 0;
            reg_BCM_INIT = 0;
            reg_BCM_PLS_RST = 0;
            reg_BCM_CONTINUE = 0;
            reg_HUB75_SHOW = 0;
            reg_HUB75_INIT = 1;
            state = WORKING;
        end
        PLANE_P: begin
          reg_RST = 0;
          reg_CACHE_INIT = 1;
          reg_ROW_P = 0;
          reg_PLANE_SELECT_P = 0;
          reg_BCM_INIT = 0;
          reg_BCM_PLS_RST = 0;
          reg_BCM_CONTINUE = 0;
          reg_HUB75_SHOW = 0;
          reg_HUB75_INIT = 0;
          state = WORKING;
        end
        default: begin
          reg_RST = 1;
          reg_CACHE_INIT = 0;
          reg_ROW_P = 0;
          reg_PLANE_SELECT_P = 0;
          reg_BCM_INIT = 0;
          reg_BCM_PLS_RST = 0;
          reg_BCM_CONTINUE = 0;
          reg_HUB75_SHOW = 0;
          reg_HUB75_INIT = 0;
          state = START;
        end
      endcase
  end

  acumulador #(
      .WIDTH(5),
      .RST_VALUE(0),
      .PLUS_VALUE(1)
  ) u_acumulador_row (
      .clk  (~clk),
      .rst  (reg_RST),
      .plus (reg_ROW_P),
      .value(out_ROW)
  );

  acumulador #(
      .WIDTH(2),
      .RST_VALUE(0),
      .PLUS_VALUE(1)
  ) u_acumulador_plane_select (
      .clk  (~clk),
      .rst  (reg_BCM_PLS_RST),
      .plus (reg_PLANE_SELECT_P),
      .value(out_PLANE_SELECT_MM)
  );

  BCM u_BCM (
      .clk           (~clk),
      .rst           (reg_BCM_PLS_RST),
      .in_INIT       (reg_BCM_INIT),
      .in_CONTINUE   (reg_BCM_CONTINUE),
      .out_NEXT_PLANE(w_BCM_NEXT_PLANE),
      .out_FINISHED  (w_BCM_FINISH),
      .out_BRIGH_DIM (out_signal_BRIGHT_DIM)
  );

  run_CACHE u_run_CACHE (
      .clk              (clk),
      .in_INIT          (reg_CACHE_INIT),
      .rst              (reg_RST),
      .in_PLANE_READY_MM(in_signal_PLANE_READY_MM),
      .out_order_CACHE  (out_signal_CACHE),
      .out_HUB75_INIT   (w_inter_HUB75_INIT)
  );



`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      ONCE_CACHE_WAITING: state_name = "ONCE_CACHE_WAITING";
      ONCE_SHOW: state_name = "ONCE_SHOW";
      BCM_INIT_Y_CACHE: state_name = "BCM_INIT_Y_CACHE";
      WORKING: state_name = "WORKING";
      LAST_SHOW: state_name = "LAST_SHOW";
      HUB75_SHOW: state_name = "HUB75_SHOW";
      PLANE_P: state_name = "PLANE_P";
    endcase
  end
`endif

endmodule
