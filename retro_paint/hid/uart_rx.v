// Receptor UART, sincroniza y reconstruye bytes desde la línea RX.
// UART Receiver 115200 baudios @50 MHz
// Compatible con HC-05, HC-06, ESP32-BT

module uart_rx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire reset,
    input  wire rx,
    output reg  rx_valid,
    output reg [7:0] rx_byte
);

    localparam integer BAUD_CNT_MAX = CLK_FREQ / BAUD_RATE;
    localparam integer MID_SAMPLE   = BAUD_CNT_MAX / 2;

    reg [15:0] baud_cnt = 0;
    reg [3:0]  bit_idx  = 0;

    reg [7:0] byte_shift = 8'd0;
    reg       rx_sync1, rx_sync2;
    reg       receiving = 0;

    // Sincroniza la señal rx
    always @(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end

    always @(posedge clk) begin
        if (reset) begin
            rx_valid   <= 0;
            receiving  <= 0;
            bit_idx    <= 0;
            baud_cnt   <= 0;
        end else begin
            rx_valid <= 0;

            if (!receiving) begin
                if (rx_sync2 == 0) begin
                    receiving <= 1;
                    baud_cnt  <= 0;
                    bit_idx   <= 0;
                end

            end else begin
                baud_cnt <= baud_cnt + 1;

                // Mid sample para bits
                if (baud_cnt == MID_SAMPLE) begin
                    
                    if (bit_idx < 8) begin
                        byte_shift[bit_idx] <= rx_sync2;
                        bit_idx <= bit_idx + 1;
                    end

                end

                // Final de bit
                if (baud_cnt >= BAUD_CNT_MAX) begin
                    baud_cnt <= 0;

                    if (bit_idx == 8) begin
                        rx_byte  <= byte_shift;
                        rx_valid <= 1;
                        receiving <= 0;
                    end
                end
            end
        end 
    end

endmodule
