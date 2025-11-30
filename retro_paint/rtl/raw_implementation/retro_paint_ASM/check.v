module comparator #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] data_in,
    input  wire [WIDTH-1:0] comparador,
    output wire checkout
);

assign checkout = (data_in == comparador);

endmodule
