module check #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] data_in,
    input rst,
    input comparar,
    input [WIDTH-1:0] comparador,
    output reg checkout
);

  always @(*) begin
    if (rst) begin
      checkout = 0;
    end else begin
      if (comparar) begin
        checkout = (data_in == comparador);
      end
    end
  end

endmodule
