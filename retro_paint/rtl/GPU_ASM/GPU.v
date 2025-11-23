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
  wire w_ROW_CACHE_ROW_LOAD0;
  wire w_ROW_CACHE_ROW_LOAD1;

  wire [511:0] w_FRAME_DATA;
  wire [511:0] w_ROW0_DATA;
  wire [511:0] w_ROW1_DATA;

  wire w_VRAM_SIGNAL;
  wire w_VRAM_AVAILABLE;
  image_select u_image_select (
      .clk              (clk),
      .rst              (!rstn),
      .in_ADDR          (w_MEM_MANG_ADDR),
      .in_rd            (w_MEM_MANG_RD),
      .in_VRAM_AVAILABLE(w_VRAM_AVAILABLE),
      .out_data         (w_FRAME_DATA),
      .out_VRAM_SIGNAL  (w_VRAM_SIGNAL),
  );


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
      .out_ROW                 (w_ROW)
  );

  memory_management u_memory_management (
      .clk               (clk),
      .rst               (w_HUB75_RST),
      .in_CACHE          (w_CONTROL_CACHE),
      .in_ROW            (w_ROW),
      .in_PLANE_SELECT   (w_CONTROL_PLANE_SELECT),
      .in_SHIFT_PLANE    (w_CONTROL_SHIFT_PLANE),
      .in_RGB01          (w_PLANES_CACHE_RGB01),
      .in_ROW0_DATA      (w_ROW0_DATA),
      .in_ROW1_DATA      (w_ROW1_DATA),
      .in_VRAM_DONE_READ (w_VRAM_SIGNAL),
      .out_PLANE_READY   (w_CONTROL_PLANE_READY),
      .out_PLANE_LOAD0   (w_PLANES_CACHE_LOAD0),
      .out_PLANE_LOAD1   (w_PLANES_CACHE_LOAD1),
      .out_PLANE_SHIFT   (w_PLANES_CACHE_SHIFT),
      .out_ROW_LOAD0     (w_ROW_CACHE_ROW_LOAD0),
      .out_ROW_LOAD1     (w_ROW_CACHE_ROW_LOAD1),
      .out_RGB0          (w_HUB75_RGB0),
      .out_RGB1          (w_HUB75_RGB1),
      .out_R             (w_PLANES_CACHE_RED),
      .out_G             (w_PLANES_CACHE_GREEN),
      .out_B             (w_PLANES_CACHE_BLUE),
      .out_ADDR          (w_MEM_MANG_ADDR),
      .out_RD            (w_MEM_MANG_RD),
      .out_VRAM_AVAILABLE(w_VRAM_AVAILABLE)
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

  row_cache u_row_cache0 (
      .clk     (clk),
      .in_data (w_FRAME_DATA),
      .in_load (w_ROW_CACHE_ROW_LOAD0),
      .out_data(w_ROW0_DATA)
  );

  row_cache u_row_cache1 (
      .clk     (clk),
      .in_data (w_FRAME_DATA),
      .in_load (w_ROW_CACHE_ROW_LOAD1),
      .out_data(w_ROW1_DATA)
  );

endmodule
