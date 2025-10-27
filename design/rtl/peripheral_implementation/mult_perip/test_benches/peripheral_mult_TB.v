`timescale 1ns / 1ps
`define SIMULATION
module peripheral_mult_TB;
  reg clk;
  reg rst;
  reg [15:0] d_in;
  reg cs;
  reg [4:0] addr;
  reg rd;
  reg wr;
  wire [31:0] d_out;

  peripheral_mult uut (
      .clk  (clk),
      .rst  (rst),
      .d_in (d_in),
      .cs   (cs),
      .addr (addr),
      .rd   (rd),
      .wr   (wr),
      .d_out(d_out)
  );

  parameter PERIOD = 20;
  initial begin
    clk  = 0;
    rst  = 0;
    d_in = 0;
    addr = 16'h0000;
    cs   = 0;
    rd   = 0;
    wr   = 0;
  end
  initial clk <= 0;
  always #(PERIOD / 2) clk <= ~clk;

  initial begin
    forever begin
      @(negedge clk);
      rst = 1;
      @(negedge clk);
      rst = 0;
      #(PERIOD * 4);
      //Ingreso A
      cs   = 1;
      rd   = 0;
      wr   = 1;
      d_in = 16'h0005;
      addr = 16'h0001;
      #(PERIOD);
      cs = 0;
      rd = 0;
      wr = 0;
      #(PERIOD * 3);
      //Ingreso B
      cs   = 1;
      rd   = 0;
      wr   = 1;
      d_in = 16'h000F;
      addr = 16'h0002;
      #(PERIOD);
      cs = 0;
      rd = 0;
      wr = 0;
      #(PERIOD*3);
      //Ingreso init
      cs   = 1;
      rd   = 0;
      wr   = 1;
      d_in = 16'h0001;
      addr = 16'h0004;
      #(PERIOD);
      cs = 0;
      rd = 0;
      wr = 0;
      #(PERIOD*6);
      cs = 1;
      rd = 0;
      wr = 1;
      d_in = 16'h0000;
      addr = 16'h0004;
      #(PERIOD);
      cs = 0;
      rd = 0;
      wr = 0;
      //Espero
      #(PERIOD * 17);
      //Leo done
      cs   = 1;
      rd   = 1;
      wr   = 0;
      addr = 16'h0010;
      #(PERIOD);
      cs = 0;
      rd = 0;
      wr = 0;
      #(PERIOD);
      //Leo result
      cs   = 1;
      rd   = 1;
      wr   = 0;
      addr = 16'h0008;
      #(PERIOD);
      cs = 0;
      rd = 0;
      wr = 0;
      #(PERIOD * 20);
    end
  end

  initial begin : TEST_CASE
  $dumpfile("peripheral_mult_TB.vcd");
  $dumpvars(-1,peripheral_mult_TB);
  #(PERIOD*50) $finish;
  end

endmodule
