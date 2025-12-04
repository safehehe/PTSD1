// Receptor UART, sincroniza y reconstruye bytes desde la línea RX.
module uart_rx #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rx,

    output reg  [7:0] data_out,
    output reg        data_valid
);

    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0]  bit_index = 0;
    reg [7:0]  rx_shift  = 0;
    reg        busy      = 0;

    always @(posedge clk) begin
        data_valid <= 0;

        if (!busy) begin
            if (rx == 0) begin
                busy <= 1;
                clk_count <= CLKS_PER_BIT/2;
                bit_index <= 0;
            end
        end else begin
            if (clk_count == CLKS_PER_BIT) begin
                clk_count <= 0;

                if (bit_index < 8) begin
                    rx_shift[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                end else begin
                    data_out   <= rx_shift;
                    data_valid <= 1;
                    busy       <= 0;
                end
            end else begin
                clk_count <= clk_count + 1;
            end
        end
    end
endmodule

