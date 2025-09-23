module sum (A,B, out);
input [3:0] A;
input [3:0] B;
output reg [3:0] out;

always @(*) out = A + B;

endmodule