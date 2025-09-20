module comp (
    in_AUX,
    in_Q,
    z
);

input [31:0] in_AUX;
input [31:0] in_Q;
output z;
reg tmp;
initial tmp = 0;
assign z = tmp;
    always @(*)
        tmp = in_Q >= in_AUX;
endmodule
