module uart_rx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600 // OJO: Debe coincidir con ESP32
)(
    input  wire clk,
    input  wire reset,
    input  wire rx,
    output reg  rx_valid,
    output reg [7:0] rx_byte
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam IDLE=0, START=1, DATA=2, STOP=3;
    
    reg [2:0] state = IDLE;
    reg [15:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] shift_reg = 0;
    
    // Sincronizar RX para evitar metaestabilidad
    reg rx_sync1, rx_sync;
    always @(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync <= rx_sync1;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            rx_valid <= 0;
            rx_byte <= 0;
        end else begin
            rx_valid <= 0;
            case (state)
                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;
                    if (rx_sync == 0) state <= START; // Start bit detected
                end
                START: begin
                    if (clk_count == (CLKS_PER_BIT/2)) begin
                        if (rx_sync == 0) begin
                            clk_count <= 0;
                            state <= DATA;
                        end else state <= IDLE; // Falso start
                    end else clk_count <= clk_count + 1;
                end
                DATA: begin
                    if (clk_count == CLKS_PER_BIT) begin
                        clk_count <= 0;
                        shift_reg[bit_index] <= rx_sync;
                        if (bit_index == 7) state <= STOP;
                        else bit_index <= bit_index + 1;
                    end else clk_count <= clk_count + 1;
                end
                STOP: begin
                    if (clk_count == CLKS_PER_BIT) begin
                        state <= IDLE;
                        rx_valid <= 1; // Byte completo recibido
                        rx_byte <= shift_reg;
                    end else clk_count <= clk_count + 1;
                end
            endcase
        end
    end
endmodule