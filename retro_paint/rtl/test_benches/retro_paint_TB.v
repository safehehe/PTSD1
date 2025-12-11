`timescale 1ns / 1ps
module retro_paint_TB;
  reg clk;
  reg rst_n;
  reg [7:0] air_byte;
  reg wireless_bt_tx;
  wire LED;
  wire [2:0] wire_to_screen_RGB0;
  wire [2:0] wire_to_screen_RGB1;
  wire wire_to_screen_CLK;
  wire [4:0] wire_to_screen_ABCDE;
  wire wire_to_screen_LATCH;
  wire wire_to_screen_nOE;
  wire bluetooth_energy;
  retro_paint u_retro_paint (
      .clk                 (clk),
      .rstn                (rst_n),
      .bluetooth_tx        (wireless_bt_tx),
      .LED                 (LED),
      .wire_to_screen_RGB0 (wire_to_screen_RGB0),
      .wire_to_screen_RGB1 (wire_to_screen_RGB1),
      .wire_to_screen_CLK  (wire_to_screen_CLK),
      .wire_to_screen_ABCDE(wire_to_screen_ABCDE),
      .wire_to_screen_LATCH(wire_to_screen_LATCH),
      .wire_to_screen_nOE  (wire_to_screen_nOE),
      .bluetooth_energy    (bluetooth_energy)
  );

  localparam CLKS_PER_BIT = 25_000_000 / 9600;
  localparam CLK_PERIOD = 40;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("retro_paint_TB.vcd");
    $dumpvars(0, retro_paint_TB);
  end
  integer i;
  initial begin
    #1 rst_n <= 1'bx;
    clk <= 1'bx;
    wireless_bt_tx = 1'b1;
    air_byte = 8'h00;
    #(CLK_PERIOD * 3) rst_n <= 1;
    #(CLK_PERIOD * 3) rst_n <= 0;
    clk <= 0;
    repeat (5) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);
    repeat (100_000) @(posedge clk);
    repeat (2) @(posedge clk);
    air_byte = 8'h00;
    wireless_bt_tx = 1;
    @(posedge clk);
    air_byte = 8'hC1;  //comando mover
    wireless_bt_tx = 0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    for (i = 0; i < 8; i = i + 1) begin
      wireless_bt_tx = air_byte[i];
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
    air_byte = 8'h00;
    wireless_bt_tx = 1;
    @(posedge clk);
    repeat (CLKS_PER_BIT) @(posedge clk);
    air_byte = 8'h00;  //x = 00
    wireless_bt_tx = 0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    for (i = 0; i < 8; i = i + 1) begin
      wireless_bt_tx = air_byte[i];
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
    air_byte = 8'h00;
    wireless_bt_tx = 1;
    @(posedge clk);
    repeat (CLKS_PER_BIT) @(posedge clk);
    air_byte = 8'h09;  //y = 09
    wireless_bt_tx = 0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    for (i = 0; i < 8; i = i + 1) begin
      wireless_bt_tx = air_byte[i];
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
    air_byte = 8'h00;
    wireless_bt_tx = 1;
    repeat (CLKS_PER_BIT) @(posedge clk);

    repeat (10_000_000) @(posedge clk);
    $finish(2);
  end

endmodule
`default_nettype wire
