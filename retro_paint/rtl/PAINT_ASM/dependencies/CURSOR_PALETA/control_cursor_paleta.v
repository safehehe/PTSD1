module control_cursor_paleta(
    clk,
    init,
    rst,
    CB,
    C,
    plus,
    paint,
    Change_X,
    Change_Y,
    sum,
    out_rst,
    cursor_paleta_done,
    cambiar_color_cursor,
    Contar_Blanco_S,
    Contar_Negro_S
);

    input clk;
    input init;
    input rst;
    input CB;
    input [2:0] C;

    output reg Contar_Blanco_S;
    output reg Contar_Negro_S;
    output reg cursor_paleta_done;
    output reg out_rst;
    output reg plus;
    output reg paint;
    
    output reg cambiar_color_cursor;
    output reg sum;
    output reg Change_X;
    output reg Change_Y;
    reg Change_Color;

    parameter START = 4'b0000;
    parameter X_DERECHA = 4'b0001;
    parameter RST_CONT_1 = 4'b0010;
    parameter Y_ABAJO = 4'b0011;
    parameter RST_CONT_2 = 4'b0100;
    parameter X_IZQ = 4'b0101;
    parameter RST_CONT_3 = 4'b0110;
    parameter Y_ARRIBA = 4'b0111;
    parameter RST_CONT_4 = 4'b1000;
    parameter CONTAR_NEGRO = 4'b1001;
    parameter CONTAR_BLANCO = 4'b1010;
    parameter CHANGE_COLOR = 4'b1011;
    parameter DONE = 4'b1100;

    reg [3:0] state;
    reg [4:0] ST_TIMER_DONE;

    parameter timer = 5'd24;
    
    always @(posedge clk) begin
        if (rst) begin
            cambiar_color_cursor = 0;
            state = START;
            ST_TIMER_DONE = timer;
        end else begin
            if (CB) begin
                cambiar_color_cursor = 1;
            end
            case (state) 
                START: begin
                    ST_TIMER_DONE = timer;
                    state = init ? X_DERECHA : START;
                end
                X_DERECHA: begin
                    state = RST_CONT_1;
                end 
                RST_CONT_1: begin
                    state = Y_ABAJO;
                end
                Y_ABAJO: begin
                    state = RST_CONT_2;
                end 
                RST_CONT_2: begin
                    state = X_IZQ;
                end
                X_IZQ: begin
                    state = RST_CONT_3;
                end 
                RST_CONT_3: begin
                    state = Y_ARRIBA;
                end
                Y_ARRIBA: begin
                    state = RST_CONT_4;
                end 
                RST_CONT_4: begin
                    state = cambiar_color_cursor ? CONTAR_NEGRO : CONTAR_BLANCO;
                end
                CONTAR_BLANCO: begin
                    state = CHANGE_COLOR;
                end
                CHANGE_COLOR: begin
                    state = X_DERECHA;
                end 
                CONTAR_NEGRO: begin
                    state = DONE;
                end
                DONE: begin
                    if (ST_TIMER_DONE == 0) begin
                        state = START;
                    end
                    else begin
                        ST_TIMER_DONE = ST_TIMER_DONE - 1;
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
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end
            X_DERECHA: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 1;
                sum = 1;
                Change_X = 1;
                Change_Y = 0;
                paint = 1;
            end 
            RST_CONT_1: begin
                out_rst = 1;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end 
            Y_ABAJO: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 1;
                sum = 1;
                Change_X = 0;
                Change_Y = 1;
                paint = 1;
            end 
            RST_CONT_2: begin
                out_rst = 1;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end 
            X_IZQ: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 1;
                sum = 0;
                Change_X = 1;
                Change_Y = 0;
                paint = 1;
            end 
            RST_CONT_3: begin
                out_rst = 1;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end 
            Y_ARRIBA: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 1;
                sum = 0;
                Change_X = 0;
                Change_Y = 1;
                paint = 1;
            end 
            RST_CONT_4: begin
                out_rst = 1;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end 
            CONTAR_BLANCO: begin
                out_rst = 0;
                Contar_Blanco_S = 1;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end
            CHANGE_COLOR:begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 1;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end
            CONTAR_NEGRO: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 1;
                Change_Color = 0;
                cursor_paleta_done = 0;
                plus = 0;
                sum = 0;
                Change_X = 0;
                Change_Y = 0;
                paint = 0;
            end
            DONE: begin
                out_rst = 0;
                Contar_Blanco_S = 0;
                Contar_Negro_S = 0;
                Change_Color = 0;
                cursor_paleta_done = 1;
                plus = 0;
                sum = 0;
                Change_X  = 0;
                Change_Y  = 0;
                paint = 0;
            end
            
        endcase 

    end

    





endmodule