`timescale 1ns / 1ps
`define SIMULATION

module BIN_TO_BCD_TB;

  reg clk;
  reg rst;
  reg start;
  reg [8:0] BIN;
  wire [3:0] UND;
  wire [3:0] DEC;
  wire [3:0] CEN;
  wire done;

  BIN_TO_BCD uut (
      .rst     (rst),
      .clk     (clk),
      .init    (start),
      .in_BIN  (BIN),
      .out_UND (UND),
      .out_DEC (DEC),
      .out_CEN (CEN),
      .out_DONE(DONE)
  );

  parameter PERIOD = 40;
  parameter real DUTY_CYCLE = 0.5;
  parameter OFFSET = 0;
  reg [20:0] i;
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
  initial begin  //Initialize inputs
    clk   = 0;
    //rst = 1;
    start = 0;
    BIN   = 9'd299;
  end
  initial begin  //Process for clk
    #OFFSET;
    forever begin
      clk = 1'b0;
      #(PERIOD - (PERIOD * DUTY_CYCLE)) clk = 1'b1;
      #(PERIOD * DUTY_CYCLE);
    end
  end

  initial begin
    #10->reset_trigger;
    @(reset_done_trigger);
    @(posedge clk);
    start = 0;
    @(posedge clk);
    start = 1;

    repeat (2) @(posedge clk);
    start = 0;

    for (i = 0; i < 17; i = i + 1) begin
      @(posedge clk);
    end
  end

  initial begin : TEST_CASE
    $dumpfile("BIN_TO_BCD_TB.vcd");
    $dumpvars(-1, uut);
    #((PERIOD * DUTY_CYCLE) * 120) $finish;
  end

endmodule
