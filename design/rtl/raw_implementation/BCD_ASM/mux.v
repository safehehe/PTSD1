module mux (
    SELECT,
    out
);
  input SELECT;
  output reg [3:0] out;
  //                              3         -5
  always @(*) out = SELECT ? 4'b0011 : 4'b1011;

endmodule
