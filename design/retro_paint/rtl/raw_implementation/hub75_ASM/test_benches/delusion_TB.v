`timescale 1ns / 1ps
`define SIMULATION

module delusion_TB;
  reg clk;
  reg rst;
  wire w_out_ch;
  reg shift;
  delusion uut(
    .rst(rst),
    .clk(clk),
    .out_channel(w_out_ch),
    .shift(shift)
  );

  parameter PERIOD = 20;
  parameter real DUTY_CYCLE = 0.5;
  event reset_trigger;
  event reset_done_trigger;

  initial begin
    forever begin
      @(reset_trigger);
      @(negedge clk);
      rst = 1;
      repeat (2) @(negedge clk);
      rst = 0;
      ->reset_done_trigger;
    end
  end
  initial begin
    clk = 0;
    rst = 1;
  end
  initial begin
    forever begin
      clk = 0;
      #(PERIOD - (PERIOD*DUTY_CYCLE)) clk = 1;
      #(PERIOD*DUTY_CYCLE);
    end
  end
  initial begin
    #10 -> reset_trigger;
    @(reset_done_trigger);
    repeat(64) begin
      @(negedge clk);
      shift=1;
      @(negedge clk);
      shift=0;
    end
  end
  initial begin : TEST_CASE
    $dumpfile("delusion_TB.vcd");
    $dumpvars(-1,uut);
    #((PERIOD*DUTY_CYCLE)*65) $finish;
  end
endmodule
