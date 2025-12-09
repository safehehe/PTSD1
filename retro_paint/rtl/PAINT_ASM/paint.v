module paint (
    clk, 
    rst, 
    init,
    in_button,
    in_x,
    in_y,
    out_x,
    out_y,
    paint,
    px_data,
    paleta,
    selector
);
    input clk,
    input rst,
    input init,
    input [5:0] in_x;
    input [5:0] in_y;

    wire out_x;
    wire out_y;
    output paint;
    output paleta;
    output selector;
    output reg [5:0] px_data;
    
    reg [7:0] color;
    reg [23:0] cont_cursor;
    reg [5:0] x;
    reg [5:0] y;
    reg [7:0] button;

    wire w_C;
    wire w_Enter;
    wire w_Enter_Paleta;
    wire rst_check;
    wire out_rst;
    wire compC;
    wire compEnt;
    wire compPal;
    wire cursor_done;
    wire cursor_paleta_done;
    wire Cursor_S;
    wire Cursor_Paleta_S;


    check #(
        .WIDTH(8)
    ) checkC( 
        .data_in(in_button),
        .rst(rst_check),
        .comparar(compC),
        .comparador(3'b100),
        .checkout(w_C)
    );
    

    check #(
        .WIDTH(8)
    ) checkEnter(
        .data_in(in_button),
        .rst(rst_check),
        .comparar(compEnt),
        .comparador(3'b010),
        .checkout(w_Enter)
    );

    check #(
        .WIDTH(8)
    ) checkEnterPaleta(
        .data_in(in_button),
        .rst(rst_check),
        .comparar(compPal),
        .comparador(3'b011),
        .checkout(w_Enter_Paleta)
    );

    DRAW_CURSOR DRAW_CURSOR(
        .clk(clk),
        .rst(out_rst),
        .init(Cursor_S),
        .in_x(in_x),
        .in_y(in_y),
        .out_x(out_x),
        .out_y(out_y),
        .paint(paint),
        .px_data(px_data),
        .cursor_done(cursor_done)
    );

    cursor_paleta cursor_paleta(
        .clk(clk),
        .rst(out_rst),
        .init(Cursor_Paleta_S),
        .cursor_paleta_done(cursor_paleta_done),
        .paint(paint),
        .px_data(px_data),
        .in_x(in_x),
        .in_y(in_y),
        .out_x(out_x),
        .out_y(out_y)
    );




    control_paint control_paint(
        .clk(clk),
        .rst(rst),
        .init(init),
        .in_x(in_x),
        .in_y(in_y),
        .out_x(out_x),
        .out_y(out_y),
        .w_C(w_C),
        .w_Enter(w_Enter),
        .w_Enter_Paleta(w_Enter_Paleta),
        .out_rst(out_rst);
        .rst_check(rst_check),
        .px_data(px_data),
        .cursor_done(cursor_done),
        .cursor_paleta_done(cursor_paleta_done),
        .Cursor_S(Cursor_S),
        .Cursor_Paleta_S(Cursor_Paleta_S),
        .compEnt(compEnt),
        .compC(compC),
        .compPal(compPal),
        .paint(paint),
        .selector(selector),
        .paleta(paleta)
    );









    

















endmodule