`timescale 1ns / 1ps
module VRAM_TB;
  reg clk;
  reg [5:0] rd_addr = 6'b0;
  wire [511:0] read_data;

  VRAM u_VRAM (
      .clk     (clk),
      .wr      (1'b0),
      .wr_addr (10'b0),
      .in_data (32'b0),
      .rd      (1'b1),
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

    for (i = 0; i < 16; i = i + 1) begin
      repeat (5) @(posedge clk);
      @(negedge clk);
      rd_addr = rd_addr + 1;
      repeat (2) @(posedge clk);
    end

    $finish(2);
  end

endmodule
