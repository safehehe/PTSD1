module acc (
    clk,
    rst,
    add,
    out_K
);
  input rst;
  input clk;
  input add;
  output out_k;
  reg [15:0] N;
  reg tmp;
  initial tmp = 0;
  assign out_k = tmp;

  always @(negedge clk) begin
    if (rst) N = 16'd16;
    else begin
      if (add) N = N - 2;
      else begin
        N = N;
      end
    end
  end

  always @(*) out_k = N == 0;
endmodule
