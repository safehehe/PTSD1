`timescale 1ns / 1ps
module DRAW_CURSOR_TB;
  reg  clk;
  reg  rst;
  reg  reg_init = 0;
  wire cursor_done;
  reg [5:0] in_x = 0;
  reg [5:0] in_y = 0;
  wire [7:0] out_x;
  wire [7:0] out_y;
  wire paint;
  wire [7:0] px_data;

  DRAW_CURSOR u_draw_cursor (
    .clk(clk),
    .rst(rst),
    .init(reg_init),
    .cursor_done(cursor_done),
    .paint(paint),
    .px_data(px_data),
    .in_x(in_x),
    .in_y(in_y),
    .out_x(out_x),
    .out_y(out_y)
);


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("DRAW_CURSOR_TB.vcd");
    $dumpvars(0, DRAW_CURSOR_TB);
  end

  initial begin
    #1 rst <= 1'bx;
    clk <= 1'bx;
    #(CLK_PERIOD * 3) rst <= 0;
    #(CLK_PERIOD * 3) rst <= 1;
    clk <= 0;
    repeat (5) @(posedge clk);
    rst <= 0;
    @(posedge clk);
    repeat (2) @(negedge clk);
    in_x = 10;
    in_y = 20;
    reg_init = 1;
    @(negedge clk);
    reg_init = 0;
    repeat (20_000_000) @(negedge clk);
    $finish(2);
  end

endmodule
`default_nettype wire
