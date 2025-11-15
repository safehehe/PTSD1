module GPU (
    input clk,
    input rstn,
    output [2:0] to_screen_RGB0,
    output [2:0] to_screen_RGB1,
    output to_screen_CLK,
    output [4:0] to_screen_ABCDE,
    output to_screen_LATCH,
    output to_screen_nOE
);
  wire w_HUB75_INIT;
  wire [4:0] w_ROW;
  wire w_HUB75_RST;
  wire w_HUB75_SHOW;
  wire w_HUB75_WAITING;
  wire w_HUB75_ITER;
  wire [2:0] w_HUB75_RGB0;
  wire [2:0] w_HUB75_RGB1;

  wire w_BRIGH_DIM;

  wire [63:0] w_PLANES_CACHE_RED;
  wire [63:0] w_PLANES_CACHE_GREEN;
  wire [63:0] w_PLANES_CACHE_BLUE;
  wire w_PLANES_CACHE_LOAD0;
  wire w_PLANES_CACHE_LOAD1;
  wire w_PLANES_CACHE_SHIFT;
  wire [5:0] w_PLANES_CACHE_RGB01;

  wire w_CONTROL_CACHE;
  wire [1:0] w_CONTROL_PLANE_SELECT;
  wire w_CONTROL_SHIFT_PLANE;
  wire w_CONTROL_PLANE_READY;
  wire w_CONTROL_RST;
  wire w_MEM_MANG_RD;
  wire [5:0] w_MEM_MANG_ADDR;

  wire [511:0] w_VRAM_DATA;

  SCREEN_CONTROL u_SCREEN_CONTROL (
      .clk                     (clk),
      .rst                     (!rstn),
      .in_signal_PLANE_READY_MM(w_CONTROL_PLANE_READY),
      .in_signal_HUB75_WAITING (w_HUB75_WAITING),
      .in_signal_HUB75_ITER    (w_HUB75_ITER),
      .out_signal_BRIGHT_DIM   (w_BRIGH_DIM),
      .out_signal_SHIFT_PLANE  (w_CONTROL_SHIFT_PLANE),
      .out_PLANE_SELECT_MM     (w_CONTROL_PLANE_SELECT),
      .out_signal_CACHE        (w_CONTROL_CACHE),
      .out_signal_HUB75_INIT   (w_HUB75_INIT),
      .out_signal_HUB75_SHOW   (w_HUB75_SHOW),
      .out_signal_HUB75_RST    (w_HUB75_RST),
      .out_ROW                 (w_ROW),
      .out_RST                 (w_CONTROL_RST)
  );

  memory_management u_memory_management (
      .clk            (clk),
      .rst            (w_CONTROL_RST),
      .in_CACHE       (w_CONTROL_CACHE),
      .in_ROW         (w_ROW),
      .in_PLANE_SELECT(w_CONTROL_PLANE_SELECT),
      .in_SHIFT_PLANE (w_CONTROL_SHIFT_PLANE),
      .in_RGB01       (w_PLANES_CACHE_RGB01),
      .in_FUSED_DATA  (w_VRAM_DATA),
      .out_PLANE_READY(w_CONTROL_PLANE_READY),
      .out_PLANE_LOAD0(w_PLANES_CACHE_LOAD0),
      .out_PLANE_LOAD1(w_PLANES_CACHE_LOAD1),
      .out_PLANE_SHIFT(w_PLANES_CACHE_SHIFT),
      .out_RGB0       (w_HUB75_RGB0),
      .out_RGB1       (w_HUB75_RGB1),
      .out_R          (w_PLANES_CACHE_RED),
      .out_G          (w_PLANES_CACHE_GREEN),
      .out_B          (w_PLANES_CACHE_BLUE),
      .out_ADDR       (w_MEM_MANG_ADDR),
      .out_RD         (w_MEM_MANG_RD)
  );
  HUB75 u_HUB75 (
      .clk              (clk),
      .rst              (w_HUB75_RST),
      .in_INIT          (w_HUB75_INIT),
      .in_RGB0          (w_HUB75_RGB0),
      .in_RGB1          (w_HUB75_RGB1),
      .in_ROW           (w_ROW),
      .in_SHOW          (w_HUB75_SHOW),
      .in_BRIGHT_DIM    (w_BRIGH_DIM),
      .ctl_CLOKER_ITER  (w_HUB75_ITER),
      .ctl_HUB75_WAITING(w_HUB75_WAITING),
      .w_RGB0           (to_screen_RGB0),
      .w_RGB1           (to_screen_RGB1),
      .w_SCREEN_CLOCK   (to_screen_CLK),
      .w_ABCDE          (to_screen_ABCDE),
      .w_LATCH          (to_screen_LATCH),
      .w_nOE            (to_screen_nOE)
  );
  planes_cache u_planes_cache (
      .clk      (clk),
      .in_R     (w_PLANES_CACHE_RED),
      .in_G     (w_PLANES_CACHE_GREEN),
      .in_B     (w_PLANES_CACHE_BLUE),
      .in_LOAD0 (w_PLANES_CACHE_LOAD0),
      .in_LOAD1 (w_PLANES_CACHE_LOAD1),
      .in_SHIFT (w_PLANES_CACHE_SHIFT),
      .out_RGB01(w_PLANES_CACHE_RGB01)
  );
  VRAM u_VRAM (
      .clk     (clk),
      .wr      (1'b0),
      .wr_addr (12'b0),
      .in_data (8'b0),
      .rd      (w_MEM_MANG_RD),
      .rd_addr (w_MEM_MANG_ADDR),
      .out_data(w_VRAM_DATA)
  );

endmodule
