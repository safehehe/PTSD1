module control_paint(
    clk,
    rst,
    in_init,
    w_C,
    w_Enter,
    x_out,
    y_out,
    in_C,
    paleta,
    pixel_data,
    paint,
    selector,
    out_PAINT,
    out_DRAW_CURSOR,
    out_CURSOR_PALETA,

);

    input clk;
    input rst;
    input in_init;

    input w_C;
    input w_Enter;

    parameter START = 4'b0000;
    parameter CHECK_VRAM = 4'b0001;
    parameter CHECK_C = 4'b0010;
    parameter CHECK_ENTER = 4'b0011;
    parameter CHECK_ENTER_PALETA = 4'b0100;
    parameter CURSOR_PALETA = 4'b0101;
    parameter CHANGE_COLOR = 4'b0110;
    parameter DRAW_CURSOR = 4'b0111;
    parameter PAINT = 4'b1000;
    parameter DONE = 4'b1001;

    reg [3:0] state;

    always @(negedge clk) begin
        if (rst) begin
            state <= START;
        end else begin
            case (state)

                START: begin
                    state <= in_init ? CHECK_C : START;
                end

                CHECK_C: begin
                    state <= w_C ? CURSOR_PALETA : CHECK_ENTER;
                end

                CURSOR_PALETA: state  <= CHECK_ENTER_PALETA;

                CHECK_ENTER: begin
                    state <= w_Enter ? PAINT :  DRAW_CURSOR;
                end 

                PAINT: state <= DONE;
                
                DRAW_CURSOR: state <= DONE;

                CHECK_ENTER_PALETA: begin
                    state <= w_Enter ?  CHANGE_COLOR : DONE;
                end 

                CHANGE_COLOR: state <= DONE; 

                DONE: state <= START;

                default: state <= START;

            endcase 
        end
    end


    always @(posedge clk) begin
        if (rst) begin 

    end









endmodule