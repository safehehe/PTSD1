// acumula los bytes hasta encontrar terminador (\n o \r) y emite line[127:0] + line_ready.
module line_buffer (
    input wire clk,
    input wire [7:0] rx_char,
    input wire       rx_valid,

    output reg [127:0] line,
    output reg         line_ready
);

    reg [6:0] index = 0;

    always @(posedge clk) begin
        line_ready <= 0;

        if (rx_valid) begin
            if (rx_char == 8'h0A) begin
                line_ready <= 1;
                index <= 0;
            end else begin
                line[index*8 +: 8] <= rx_char;
                index <= index + 1;
            end
        end
    end
endmodule
