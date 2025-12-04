module comparator #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] data_in,
    input  [WIDTH-1:0] comparador,
    output wire checkout
);

assign checkout = (data_in == comparador);

endmodule
