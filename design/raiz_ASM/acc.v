module acc (
    clk,
    rst,
    add,
    out_K
);
  input rst;
  input clk;
  input add;
  output reg out_K;
  reg [15:0] N;

  always @(negedge clk) begin
    if (rst) N = 16'd16;
    else begin
      if (add) N = N - 2;
      else begin
        N = N;
      end
    end
  end

  always @(*) out_K = N == 0;
endmodule
