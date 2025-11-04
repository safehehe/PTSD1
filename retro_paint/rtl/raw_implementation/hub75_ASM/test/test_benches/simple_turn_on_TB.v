module simple_turn_on_TB;
  reg clk;
  reg rst_n;

  wire A, B, C, D, E;
  wire R0, G0, B0;
  wire R1, G1, B1;
  wire LATCH, nOE, S_CLK;
  wire LEDS;
  simple_turn_on uut (
      .clk  (clk),
      .resetn  (rst_n),
      .A    (A),
      .B    (B),
      .C    (C),
      .D    (D),
      .E    (E),
      .R0   (R0),
      .G0   (G0),
      .B0   (B0),
      .R1   (R1),
      .G1   (G1),
      .B1   (B1),
      .LATCH(LATCH),
      .nOE  (nOE),
      .S_CLK(S_CLK),
      .LEDS(LEDS)
  );


  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("simple_turn_on_TB.vcd");
    $dumpvars(0, simple_turn_on_TB);
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
    repeat (70) @(posedge clk);
    $finish;
  end

endmodule
