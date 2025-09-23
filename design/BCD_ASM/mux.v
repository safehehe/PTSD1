module mux(SELECT,out);
input SELECT;
output reg out;
//                              -5         3
always @(*) out = SELECT ? 4'b1011 : 4'b0011;

endmodule