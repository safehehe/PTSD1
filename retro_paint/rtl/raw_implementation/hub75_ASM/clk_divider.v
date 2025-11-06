module clk_divider #(
    parameter COUNTER_WIDTH = 12
) (
    input  clk,
    output out_clk
);
  reg [COUNTER_WIDTH-1:0] counter = 0;
  assign out_clk = counter[COUNTER_WIDTH-1];
  always @(negedge clk) counter = counter + 1;
endmodule
