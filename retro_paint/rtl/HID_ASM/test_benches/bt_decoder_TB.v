`timescale 1ns / 1ps
module bt_decoder_TB;
  reg clk;
  reg rst_n;
  reg rx_valid;
  reg [7:0] rx_byte;
  wire [2:0] command_id;
  wire [5:0] x_out;
  wire [5:0] y_out;
  wire data_ready;
  bt_decoder u_bt_decoder (
      .clk       (clk),
      .reset     (!rst_n),
      .rx_valid  (rx_valid),
      .rx_byte   (rx_byte),
      .command_id(command_id),
      .x_out     (x_out),
      .y_out     (y_out),
      .data_ready(data_ready)
  );

  localparam CLKS_PER_BIT = 25_000_000 / 9600;

  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("bt_decoder_TB.vcd");
    $dumpvars(0, bt_decoder_TB);
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
    repeat (2) @(negedge clk);
    rx_byte = 8'h00;
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'hC1;//command move
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h2D;//x = 45
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h25;//y = 37
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h25;//no debe funcionar
    rx_valid = 1;
    repeat(5) @(negedge clk);
    @(negedge clk);
    rx_byte = 8'hC2;//command draw
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h2D;//x = 45
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h25;//y = 37
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h43;//no debe funcionar
    rx_valid = 1;
    repeat(5) @(negedge clk);
    @(negedge clk);
    rx_byte = 8'hC3;//command pickcolor
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h0F;//x = 15
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h04;//y = 4
    rx_valid = 1;
    @(negedge clk);
    rx_valid = 0;
    @(negedge clk);
    rx_byte = 8'h43;//no debe funcionar
    rx_valid = 1;
    repeat(5) @(negedge clk);
    $finish(2);
  end

endmodule
