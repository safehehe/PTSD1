`timescale 1ns / 1ps
module BCD2BIN_TB;
  reg clk;
  reg rst_n;

  reg [3:0] DEC = 0;
  reg [3:0] UND = 0;
  reg INIT = 0;
  wire [7:0] BIN;
  wire DONE;

  BCD2BIN u_BCD2BIN (
      .clk     (clk),
      .rst     (!rst_n),
      .in_DEC  (DEC),
      .in_UND  (UND),
      .in_INIT (INIT),
      .out_BIN (BIN),
      .out_DONE(DONE)
  );


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("BCD2BIN_TB.vcd");
    $dumpvars(0, BCD2BIN_TB);
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
    @(negedge clk);
    DEC = 8;
    UND = 5;
    @(negedge clk);
    INIT = 1;
    @(negedge clk);
    INIT = 0;
    repeat (30) @(posedge clk);
    $finish(2);
  end

endmodule
