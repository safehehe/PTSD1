module SCREEN_CONTROL (
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
    output out_signal_HUB75_LATCH,
    output [4:0] out_ROW,
    output out_RST
);
  assign out_signal_SHIFT_PLANE = in_signal_HUB75_ITER;
  assign out_signal_HUB75_LATCH = w_inter_HUB75_LATCH + w_inter_synced_LATCH;
  wire w_inter_synced_LATCH;
  wire [5:0] acc_ROW;
  assign out_ROW = acc_ROW[4:0];
  wire w_inter_HUB75_LATCH;
  assign out_RST = reg_RST;
  reg  reg_RST;
  reg  reg_render_INIT;
  reg  reg_CACHE_INIT;
  reg  reg_HUB75_LATCH;
  reg  reg_row_plus;
  wire w_BCM_INIT;
  wire w_BCM_RST;
  wire w_BCM_FINISH;
  wire w_BCM_CONTINUE;
  wire w_BCM_NEXT_PLANE;

  wire w_render_PLANE_SELECT_P;
  reg  reg_plane_select_plus;
  wire w_render_finished;

  parameter START = 0;
  parameter FIRST_RUN_CACHE_WAIT = 1;
  parameter FIRST_RUN_RENDER = 2;
  parameter OTHERS_WORKING = 3;
  parameter NEXT_CHECK_ROW = 4;
  reg [2:0] state;
  always @(negedge clk) begin
    if (rst) begin
      reg_RST = 1;
      reg_render_INIT = 0;
      reg_CACHE_INIT = 0;
      reg_HUB75_LATCH = 0;
      reg_row_plus = 0;
      reg_plane_select_plus = 0;
      state = START;
    end else
      case (state)
        START: begin
          reg_RST = 0;
          reg_CACHE_INIT = 1;
          reg_render_INIT = 0;
          reg_HUB75_LATCH = 0;
          reg_row_plus = 0;
          reg_plane_select_plus = 0;
          state = FIRST_RUN_CACHE_WAIT;
        end
        FIRST_RUN_CACHE_WAIT: begin
          if (in_signal_HUB75_WAITING) begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_render_INIT = 0;
            reg_HUB75_LATCH = 1;
            reg_row_plus = 0;
            reg_plane_select_plus = 0;
            state = FIRST_RUN_RENDER;
          end else begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_render_INIT = 0;
            reg_HUB75_LATCH = 0;
            reg_row_plus = 0;
            reg_plane_select_plus = 0;
            state = FIRST_RUN_CACHE_WAIT;
          end
        end
        FIRST_RUN_RENDER: begin
          reg_RST = 0;
          reg_CACHE_INIT = 1;
          reg_render_INIT = 1;
          reg_HUB75_LATCH = 0;
          reg_row_plus = 0;
          reg_plane_select_plus = 1;
          state = OTHERS_WORKING;
        end
        OTHERS_WORKING: begin
          if (w_render_finished) begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_render_INIT = 0;
            reg_HUB75_LATCH = 0;
            reg_row_plus = 1;
            reg_plane_select_plus = 0;
            state = NEXT_CHECK_ROW;
          end else if (w_render_PLANE_SELECT_P) begin
            reg_RST = 0;
            reg_CACHE_INIT = 1;
            reg_render_INIT = 0;
            reg_HUB75_LATCH = 0;
            reg_row_plus = 0;
            reg_plane_select_plus = 1;
            state = OTHERS_WORKING;
          end else begin
            reg_RST = 0;
            reg_CACHE_INIT = 0;
            reg_render_INIT = 0;
            reg_HUB75_LATCH = 0;
            reg_row_plus = 0;
            reg_plane_select_plus = 0;
            state = OTHERS_WORKING;
          end
        end
        NEXT_CHECK_ROW: begin
          if (acc_ROW == 32) begin
            reg_RST = 1;
            reg_render_INIT = 0;
            reg_CACHE_INIT = 0;
            reg_HUB75_LATCH = 0;
            reg_row_plus = 0;
            reg_plane_select_plus = 0;
            state = START;
          end else begin
            reg_RST = 0;
            reg_CACHE_INIT = 1;
            reg_render_INIT = 0;
            reg_HUB75_LATCH = 0;
            reg_row_plus = 0;
            reg_plane_select_plus = 0;
            state = FIRST_RUN_CACHE_WAIT;
          end
        end
        default: begin
          reg_RST = 0;
          reg_CACHE_INIT = 1;
          reg_render_INIT = 0;
          reg_HUB75_LATCH = 0;
          reg_row_plus = 0;
          reg_plane_select_plus = 0;
          state = FIRST_RUN_CACHE_WAIT;
        end
      endcase
  end

  acumulador #(
      .WIDTH(6),
      .RST_VALUE(0),
      .PLUS_VALUE(1)
  ) u_acumulador_row (
      .clk  (~clk),
      .rst  (reg_RST),
      .plus (reg_row_plus),
      .value(acc_ROW)
  );

  acumulador #(
      .WIDTH(2),
      .RST_VALUE(0),
      .PLUS_VALUE(1)
  ) u_acumulador_plane_select (
      .clk  (~clk),
      .rst  (reg_RST),
      .plus (reg_plane_select_plus),
      .value(out_PLANE_SELECT_MM)
  );

  BCM u_BCM (
      .clk           (clk),
      .rst           (w_BCM_RST),
      .in_INIT       (w_BCM_INIT),
      .in_CONTINUE   (w_BCM_CONTINUE),
      .out_NEXT_PLANE(w_BCM_NEXT_PLANE),
      .out_FINISH    (w_BCM_FINISH),
      .out_HALF_WAY  (out_signal_BRIGHT_DIM)
  );


  row_render u_row_render (
      .clk                (clk),
      .rst                (reg_RST),
      .in_INIT            (reg_render_INIT),
      .in_BCM_FINISH      (w_BCM_FINISH),
      .in_NEXT_PLANE      (w_BCM_NEXT_PLANE),
      .in_HUB75_WAITING   (in_signal_HUB75_WAITING),
      .out_render_finished(w_render_finished),
      .out_BCM_INIT       (w_BCM_INIT),
      .out_BCM_RST        (w_BCM_RST),
      .out_HUB75_LATCH    (w_inter_HUB75_LATCH),
      .out_BCM_CONTINUE   (w_BCM_CONTINUE),
      .out_PLANE_SELECT_P (w_render_PLANE_SELECT_P)
  );

  run_CACHE u_run_CACHE (
      .clk              (clk),
      .in_INIT          (reg_CACHE_INIT),
      .rst              (reg_RST),
      .in_PLANE_READY_MM(in_signal_PLANE_READY_MM),
      .out_CACHE        (out_signal_CACHE),
      .out_HUB75_INIT   (out_signal_HUB75_INIT)
  );

  hub75_latch_sync u_hub75_latch_sync (
      .clk                   (clk),
      .rst                   (reg_RST),
      .in_sync_hub75_latch   (reg_HUB75_LATCH),
      .out_synced_hub75_latch(w_inter_synced_LATCH)
  );


`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      FIRST_RUN_CACHE_WAIT: state_name = "CACHE";
      FIRST_RUN_RENDER: state_name = "RENDER";
      OTHERS_WORKING: state_name = "WORKING";
      NEXT_CHECK_ROW: state_name = "NEXT";
    endcase
  end
`endif

endmodule
