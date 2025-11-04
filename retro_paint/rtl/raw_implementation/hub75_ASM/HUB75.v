module HUB75 (
    input clk,
    input rstn,

    output wire out_R0,
    output wire out_G0,
    output wire out_B0,
    output wire out_R1,
    output wire out_G1,
    output wire out_B1,
    output wire S_CLOCK
);







  reg  reg_CLOCKER_RST;
  reg  reg_CLOCKER_INIT;
  wire w_CLOCKER_FINISH;
  wire w_CLOCKER_ITER;
  RGB_clocker CLOCKER (
      .clk       (clk),
      .rst       (reg_CLOCKER_RST),
      .in_INIT   (reg_CLOCKER_INIT),
      .in_R0     (in_R0),
      .in_G0     (in_G0),
      .in_B0     (in_B0),
      .in_R1     (in_R1),
      .in_G1     (in_G1),
      .in_B1     (in_B1),
      .out_FINISH(w_CLOCKER_FINISH),
      .out_ITER  (w_CLOCKER_ITER),
      .out_R0    (out_R0),
      .out_G0    (out_G0),
      .out_B0    (out_B0),
      .out_R1    (out_R1),
      .out_G1    (out_G1),
      .out_B1    (out_B1),
      .S_CLOCK   (S_CLOCK)
  );

endmodule
