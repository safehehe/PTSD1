`timescale 1ns / 1ps
module uart_rx_TB;
  reg  clk;
  reg  rst_n;
  reg  tx;
  wire rx_valid;
  wire [7:0] rx_byte;
  uart_rx  u_uart_rx (
      .clk     (clk),
      .reset   (!rst_n),
      .rx      (tx),
      .rx_valid(rx_valid),
      .rx_byte (rx_byte)
  );
  localparam CLKS_PER_BIT = 25_000_000 / 9600;

  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("uart_rx_TB.vcd");
    $dumpvars(0, uart_rx_TB);
  end

  initial begin
    #1 rst_n <= 1'bx;
    clk <= 1'bx;
    tx  <= 1;
    #(CLK_PERIOD * 3) rst_n <= 1;
    #(CLK_PERIOD * 3) rst_n <= 0;
    clk <= 0;
    repeat (5) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);
    repeat (2) @(posedge clk);
    tx <= 0;  //start bit2
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 1;  //byte[0]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 1;  //byte[1]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 0;  //byte[2]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 0;  //byte[3]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 1;  //byte[4]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 0;  //byte[5]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 1;  //byte[6]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 0;  //byte[7]
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 1;
    repeat (CLKS_PER_BIT) @(posedge clk);
    tx <= 1;
    $finish(2);
  end

endmodule
