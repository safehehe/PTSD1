`timescale 1ns/1ps

module paint_TB;
  reg clk;
  reg rst_n;

  reg [5:0] in_x = 0;
  reg [5:0] in_y = 0;
  reg [2:0] in_button = 0;
  wire [5:0] out_x;
  wire [5:0] out_y;
  wire paint;
  wire paleta;
  wire selector;
  wire [7:0] px_data;

  paint u_paint (
      .clk      (clk),
      .rst      (!rst_n),
      .init     (rst_n),
      .in_x     (in_x),
      .in_y     (in_y),
      .in_button(in_button),
      .out_x    (out_x),
      .out_y    (out_y),
      .paint    (paint),
      .paleta   (paleta),
      .selector (selector),
      .px_data  (px_data)
  );


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("paint_TB.vcd");
    $dumpvars(0, paint_TB);
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
    repeat (5) @(posedge clk);
    in_x = 2;
    in_y = 4;
    repeat (5) @(posedge clk);
    in_button = 4;
    in_x = 5;
    in_y = 7;
    repeat (5) @(posedge clk);
    in_button = 3;
    repeat (100_000) @(posedge clk);
    $finish(2);
  end

endmodule
`default_nettype wire
