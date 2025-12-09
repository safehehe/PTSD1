`timescale 1ns / 1ps
module CONTAR_BLANCO_TB;
  reg  clk;
  reg  rst;
  reg  reg_init = 0;
  wire CB;

  CONTAR_BLANCO u_CONTAR_BLANCO (
      .clk (clk),
      .rst (rst),
      .init(reg_init),
      .CB  (CB)
  );


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("CONTAR_BLANCO_TB.vcd");
    $dumpvars(0, CONTAR_BLANCO_TB);
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
    reg_init = 1;
    @(negedge clk);
    reg_init = 0;
    repeat (6_000_000) @(negedge clk);
    $finish(2);
  end

endmodule
`default_nettype wire
