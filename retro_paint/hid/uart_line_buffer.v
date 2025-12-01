module uart_line_buffer(
    input  wire clk,
    input  wire data_ready,
    input  wire [7:0] data_in,
    output reg  line_ready,
    output reg [127:0] line
);

reg [7:0] index = 0;

always @(posedge clk) begin
    line_ready <= 0;

    if (data_ready) begin
        if (data_in == 8'h0A) begin  // salto de línea "\n"
            line_ready <= 1;
            index <= 0;
        end else begin
            line[index*8 +: 8] <= data_in;
            index <= index + 1;
        end
    end
end

endmodule
