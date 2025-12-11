`timescale 1ns/1ps
module HID_TB;
  reg clk;
  reg rst_n;

  reg to_uart_rx;
  reg [7:0] data_byte;

  wire to_decoder_rx_valid;
  wire [7:0] to_decoder_rx_byte;
  uart_rx u_uart_rx (
      .clk     (clk),
      .reset   (!rst_n),
      .rx      (to_uart_rx),
      .rx_valid(to_decoder_rx_valid),
      .rx_byte (to_decoder_rx_byte)
  );

  wire [2:0] out_command_id;
  wire [5:0] out_x_out;
  wire [5:0] out_y_out;
  wire out_data_ready;
  bt_decoder u_bt_decoder (
      .clk       (clk),
      .reset     (!rst_n),
      .rx_valid  (to_decoder_rx_valid),
      .rx_byte   (to_decoder_rx_byte),
      .command_id(out_command_id),
      .x_out     (out_x_out),
      .y_out     (out_y_out),
      .data_ready(out_data_ready)
  );

  localparam CLKS_PER_BIT = 25_000_000 / 9600;
  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("HID_TB.vcd");
    $dumpvars(0, HID_TB);
  end
  integer i;
  initial begin
    #1 rst_n <= 1'bx;
    clk <= 1'bx;
     to_uart_rx = 1;
    #(CLK_PERIOD * 3) rst_n <= 1;
    #(CLK_PERIOD * 3) rst_n <= 0;
    clk <= 0;
    repeat (5) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);
    repeat (2) @(posedge clk);
    data_byte  = 8'h00;
    to_uart_rx = 1;
    @(posedge clk);
    data_byte  = 8'hC1;  //comando mover
    to_uart_rx = 0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    for (i = 0; i < 8; i = i + 1) begin
      to_uart_rx = data_byte[i];
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
    data_byte  = 8'h00;
    to_uart_rx = 1;
    @(posedge clk);
    repeat (CLKS_PER_BIT) @(posedge clk);
    data_byte  = 8'h23;  //x = 35
    to_uart_rx = 0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    for (i = 0; i < 8; i = i + 1) begin
      to_uart_rx = data_byte[i];
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
    data_byte  = 8'h00;
    to_uart_rx = 1;
    @(posedge clk);
    repeat (CLKS_PER_BIT) @(posedge clk);
    data_byte  = 8'h32;  //y = 50
    to_uart_rx = 0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    for (i = 0; i < 8; i = i + 1) begin
      to_uart_rx = data_byte[i];
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
    data_byte  = 8'h00;
    to_uart_rx = 1;
    repeat (CLKS_PER_BIT) @(posedge clk);

    repeat (2*CLKS_PER_BIT) @(posedge clk);

    $finish(2);
  end

endmodule
