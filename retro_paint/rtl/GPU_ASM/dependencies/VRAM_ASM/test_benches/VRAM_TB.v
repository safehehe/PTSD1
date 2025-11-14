`timescale 1ns / 1ps
module VRAM_TB;
  reg clk;
  reg [5:0] rd_addr = 6'b0;
  wire [511:0] read_data;
  reg rd;
  reg [11:0] wr_addr = 12'b0;
  reg wr;
  reg [7:0] in_data = 8'b11111111;
  VRAM u_VRAM (
      .clk     (clk),
      .wr      (wr),
      .wr_addr (wr_addr),
      .in_data (in_data),
      .rd      (rd),
      .rd_addr (rd_addr),
      .out_data(read_data)
  );


  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("VRAM_TB.vcd");
    $dumpvars(0, VRAM_TB);
  end
  integer i;
  initial begin
    clk <= 1'bx;
    #(CLK_PERIOD * 3);
    #(CLK_PERIOD * 3) clk <= 0;
    @(negedge clk);
    rd = 1;
    wr = 0;
    for (i = 0; i < 5; i = i + 1) begin
      repeat (5) @(posedge clk);
      @(negedge clk);
      rd_addr = rd_addr + 1;
      repeat (2) @(posedge clk);
    end
    @(negedge clk);
    rd = 0;
    wr = 1;
    rd_addr = 0;
    wr_addr = 63;
    repeat (5) @(posedge clk);
    @(negedge clk);
    rd = 1;
    wr = 0;
    rd_addr = 0;
    wr_addr = 0;
    repeat (5) @(posedge clk);
    $finish(2);
  end

endmodule
