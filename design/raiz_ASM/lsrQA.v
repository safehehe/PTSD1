module lsrQA (
    clk,
    load,
    shift,
    add,
    in_AUX,
    in_RR,
    out_Q
);
  input clk;
  input load;
  input shift;
  input add;
  input [15:0] in_AUX;
  input [15:0] in_RR;
  output reg [15:0] out_Q;
  reg [15:0] reg_A;
  always @(negedge clk) begin
    if (load) begin
      out_Q = 15'b0;
      reg_A = in_RR;
    end else begin
      if (shift) {out_Q, reg_A} = ({out_Q, reg_A} << 2);
      else begin
        if (add) out_Q = out_Q + (~in_AUX + 1);
        else begin
          out_Q = out_Q;
          reg_A = reg_A;
        end
      end
    end
  end
endmodule
