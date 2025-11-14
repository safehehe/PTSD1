`timescale 1ns / 1ps
module memory_management_TB;
  reg clk;
  reg rst_n;
  reg in_signal_CACHE;
  reg [4:0] in_signal_ROW;
  reg [1:0] in_signal_PLANE_SELECT;
  reg in_signal_SHIFT_PLANE;
  wire [5:0] data_RGB01;
  wire [511:0] data_FUSED;
  wire signal_PLANE_READY;
  wire signal_PLANE_LOAD0;
  wire signal_PLANE_LOAD1;
  wire signal_PLANE_SHIFT;
  wire [2:0] data_RGB0;
  wire [2:0] data_RGB1;
  wire [63:0] data_R;
  wire [63:0] data_G;
  wire [63:0] data_B;
  wire [5:0] signal_ADDR;
  wire signal_RD;


  VRAM u_VRAM (
      .clk     (clk),
      .wr      (1'b0),
      .wr_addr (12'b0),
      .in_data (8'b0),
      .rd      (signal_RD),
      .rd_addr (signal_ADDR),
      .out_data(data_FUSED)
  );

  planes_cache u_planes_cache (
      .clk      (clk),
      .in_R     (data_R),
      .in_G     (data_G),
      .in_B     (data_B),
      .in_LOAD0 (signal_PLANE_LOAD0),
      .in_LOAD1 (signal_PLANE_LOAD1),
      .in_SHIFT (signal_PLANE_SHIFT),
      .out_RGB01(data_RGB01)
  );

  memory_management u_memory_management (
      .clk            (clk),
      .rst            (!rst_n),
      .in_CACHE       (in_signal_CACHE),
      .in_ROW         (in_signal_ROW),
      .in_PLANE_SELECT(in_signal_PLANE_SELECT),
      .in_SHIFT_PLANE (in_signal_SHIFT_PLANE),
      .in_RGB01       (data_RGB01),
      .in_FUSED_DATA  (data_FUSED),
      .out_PLANE_READY(signal_PLANE_READY),
      .out_PLANE_LOAD0(signal_PLANE_LOAD0),
      .out_PLANE_LOAD1(signal_PLANE_LOAD1),
      .out_PLANE_SHIFT(signal_PLANE_SHIFT),
      .out_RGB0       (data_RGB0),
      .out_RGB1       (data_RGB1),
      .out_R          (data_R),
      .out_G          (data_G),
      .out_B          (data_B),
      .out_ADDR       (signal_ADDR),
      .out_RD         (signal_RD)
  );


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("memory_management_TB.vcd");
    $dumpvars(0, memory_management_TB);
  end

  initial begin
    #1 rst_n <= 1'bx;
    in_signal_CACHE = 0;
    in_signal_ROW = 0;
    in_signal_PLANE_SELECT = 0;
    in_signal_SHIFT_PLANE = 0;
    clk <= 1'bx;
    #(CLK_PERIOD * 3) rst_n <= 1;
    #(CLK_PERIOD * 3) rst_n <= 0;
    clk <= 0;
    repeat (5) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);
    in_signal_CACHE = 1;
    in_signal_ROW   = 5'd1;
    @(posedge clk);
    in_signal_CACHE = 0;
    repeat (10) @(posedge clk);
    in_signal_SHIFT_PLANE = 1;
    repeat (6) @(posedge clk);
    in_signal_SHIFT_PLANE = 0;
    repeat (5) @(posedge clk);
    $finish(2);
  end

endmodule
