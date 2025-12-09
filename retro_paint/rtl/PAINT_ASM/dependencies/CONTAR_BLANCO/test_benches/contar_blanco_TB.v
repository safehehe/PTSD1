`timescale 1ns / 1ps
module contar_blanco_TB;
  reg  clk;
  reg  rst;
  reg  reg_init = 0;
  wire CB;

  contar_blanco u_contar_blanco (
      .clk (clk),
      .rst (rst),
      .init(reg_init),
      .CB  (CB)
  );


  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("contar_blanco_TB.vcd");
    $dumpvars(0, contar_blanco_TB);
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
    repeat (25_000_000) @(negedge clk);
    $finish(2);
  end

endmodule
`default_nettype wire
