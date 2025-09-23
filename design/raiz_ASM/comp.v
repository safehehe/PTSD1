module comp (
    in_AUX,
    in_Q,
    out_Q
);

  input [15:0] in_AUX;
  input [15:0] in_Q;
  output reg [15:0] out_Q;


  always @(*) begin
    out_Q = in_Q + (~in_AUX+1);
  end
endmodule
