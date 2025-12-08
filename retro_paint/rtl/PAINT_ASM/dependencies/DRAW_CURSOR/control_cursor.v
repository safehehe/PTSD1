module control_cursor(
    clk,
    rst,
    init,
    px_data,
    in_x,
    in_y,
    out_x,
    out_y,
    paint,
    Contar_Blanco_S,
    Contar_Negro_S,
    CB,
    CN,
    out_rst,
    cursor_done
);

    input clk;
    input rst;
    input init;
    input CB;
    input CN;
    input [5:0] in_x;
    input [5:0] in_y;

    wire [5:0] out_x;
    wire [5:0] out_y;
    
    output reg Contar_Blanco_S;
    output reg Contar_Negro_S;
    output reg out_rst;
    output reg cursor_done;
    output reg [7:0] px_data;
    output reg paint;

    parameter START = 3'b000;
    parameter PAINT_W = 3'b001;
    parameter CONTAR_BLANCO = 3'b010;
    parameter PAINT_B = 3'b011;
    parameter CONTAR_NEGRO = 3'b100;
    parameter DONE = 3'b101;

    reg [2:0] state;
    
    parameter [4:0] ST_TIMER_DONE = 5'd24;
    reg [4:0] timer_done;

    always @(posedge clk) begin
        if (rst) begin
            out_x = in_x;
            out_y = in_y;
            state = START;
            timer_done = ST_TIMER_DONE;
        end else begin

            case (state)

                START: begin
                    out_x = in_x;
                    out_y = in_y;
                    px_data = 8'b11111111;
                    timer_done = ST_TIMER_DONE;
                    state = init ? PAINT_W : START;
                end

                PAINT_W: begin
                    state = CONTAR_BLANCO;
                end

                CONTAR_BLANCO: begin
                    px_data = 8'b0;
                    state = CB ? PAINT_B : CONTAR_BLANCO;
                end

                PAINT_B: begin
                    px_data = 8'b0;
                    state = CONTAR_NEGRO;
                end

                CONTAR_NEGRO: begin
                    state = CN ? DONE : CONTAR_NEGRO;
                end

                DONE: begin
                    if (timer_done == 0) begin
                        state = START;
                    end else begin
                        timer_done = timer_done - 1;
                        state = DONE;
                    end
                end
            endcase 
        end
    end

    always @(*) begin
        case (state) 

            START: begin
                out_rst = 1;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                paint = 0;
                cursor_done = 0;
            end

            PAINT_W: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                paint = 1;
                cursor_done = 0;
            end

            CONTAR_BLANCO: begin
                out_rst = 0;
                Contar_Blanco_S = 1;
                Contar_Negro_S = 0;
                paint = 0;
                cursor_done = 0;
            end

            PAINT_B: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                paint = 1;
                cursor_done = 0;
            end

            CONTAR_NEGRO: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 1;
                paint = 0;
                cursor_done = 0;
            end

            DONE: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                paint = 0;
                cursor_done = 1;
            end
        endcase 
    end



endmodule