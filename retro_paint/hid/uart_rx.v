module uart_rx #(
    parameter CLK_FREQ = 50000000,    // reloj FPGA 50 MHz
    parameter BAUD     = 9600
)(
    input  wire clk,
    input  wire rx,
    output reg  data_ready,
    output reg [7:0] data_out
);

localparam integer DIV = CLK_FREQ / BAUD;

reg [15:0] counter = 0;
reg [3:0] bit_index = 0;
reg busy = 0;
reg [7:0] shift_reg = 0;

always @(posedge clk) begin
    data_ready <= 0;

    if (!busy) begin
        if (rx == 0) begin  // start bit detectado
            busy <= 1;
            counter <= DIV/2;
            bit_index <= 0;
        end
    end else begin
        if (counter == DIV) begin
            counter <= 0;
            bit_index <= bit_index + 1;

            if (bit_index >= 1 && bit_index <= 8)
                shift_reg[bit_index-1] <= rx;

            if (bit_index == 9) begin
                data_out <= shift_reg;
                data_ready <= 1;
                busy <= 0;
            end
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
