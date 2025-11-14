`timescale 1ns / 1ps
module GPU_TB;
  reg clk;
  reg rst_n;

  wire [2:0] screen_RGB0;
  wire [2:0] screen_RGB1;
  wire screen_CLK;
  wire [4:0] screen_ABCDE;
  wire screen_LATCH;
  wire screen_nOE;
  GPU u_GPU (
      .clk            (clk),
      .rstn           (rst_n),
      .to_screen_RGB0 (screen_RGB0),
      .to_screen_RGB1 (screen_RGB1),
      .to_screen_CLK  (screen_CLK),
      .to_screen_ABCDE(screen_ABCDE),
      .to_screen_LATCH(screen_LATCH),
      .to_screen_nOE  (screen_nOE)
  );


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("GPU_TB.vcd");
    $dumpvars(0, GPU_TB);
  end

  initial begin
    #1 rst_n <= 1'bx;
    clk <= 1'bx;
    #(CLK_PERIOD * 3) rst_n <= 1;
    #(CLK_PERIOD * 3) rst_n <= 0;
    clk <= 0;
    repeat (5) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);
    repeat (2) @(posedge clk);
    #(CLK_PERIOD * 100_000) $finish(2);
  end

endmodule
