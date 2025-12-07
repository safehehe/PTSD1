module cursor_paleta(
    clk,
    rst,
    init,
    cursor_paleta_done,
    paint,
    px_data
);
    input clk;
    input rst;
    input init;

    output cursor_paleta_done;
    output paint;
    output px_data;

    wire Contar_Blanco_S;
    wire Contar_Negro_S;
    wire CB;
    wire CN;
    wire [2:0] C;
    wire Change_X;
    wire Change_Y;
    wire sum;
    wire plus;
    wire rst_cont;
    wire cambiar_color_cursor;

    control_cursor_paleta control_cursor_paleta(
        .clk(clk),
        .init(init),
        .rst(rst),
        .CB(CB),
        .C(C),
        .plus(plus),
        .paint(paint),
        .Change_X(Change_X),
        .Change_Y(Change_Y),
        .sum(sum),
        .out_rst(rst_cont),
        .cursor_paleta_done(cursor_paleta_done),
        .cambiar_color_cursor(cambiar_color_cursor),
        .Contar_Blanco_S(Contar_Blanco_S),
        .Contar_Negro_S(Contar_Negro_S)
    );

    CONTAR_BLANCO CONTAR_BLANCO(
        .clk(clk),
        .rst(rst),
        .init(Contar_Blanco_S),
        .CB(CB)
    );

    CONTAR_NEGRO CONTAR_NEGRO(
        .clk(clk),
        .init(Contar_Negro_S),
        .rst(rst),
        .CN(CN)
    );

    

    

endmodule