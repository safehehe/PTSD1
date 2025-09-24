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
  reg [3:0] N;

  always @(negedge clk) begin
    if (rst) N = 4'h8;
    else begin
      if (add) N = N - 1;
      else begin
        N = N;
      end
    end
  end

  always @(*) out_K = N == 0;
endmodule
