module comparator #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] data_in,
    input rst;
    input  [WIDTH-1:0] comparador,
    output wire checkout
);

    if (rst) begin
        assign checkout = 0;
    end else begin
        assign checkout = (data_in == comparador);
    end

endmodule
