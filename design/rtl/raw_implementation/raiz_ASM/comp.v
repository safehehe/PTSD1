module comp (
    in_AUX,
    in_Q,
    out_comp_Q
);

  input [15:0] in_AUX;
  input [15:0] in_Q;
  output reg [15:0] out_comp_Q;


  always @(*) begin
    out_comp_Q = in_Q + (~in_AUX + 1);
  end
endmodule
