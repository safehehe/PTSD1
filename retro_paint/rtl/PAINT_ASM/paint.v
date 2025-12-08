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
    wire w_Enter
    wire rst_check;


    check #(
        .WIDTH(8)
    ) checkC( 
        .data_in(in_button),
        .rst(rst_check),
        .comparador(8'h43),
        .checkout(w_C)
    );
    
    acumulador 

    check #(
        .WIDTH(8)
    ) checkEnter(
        .data_in(in_button),
        .rst(rst_check),
        .comparador(8'h3D),
        .checkout(w_Enter)
    );

    CONTAR_BLANCO CONTAR_BLANCO(

    );


    control_paint control_paint(
        .clk(clk),
        .rst(rst),
        .in_init(rst),
        .w_C(w_C),
        .w_Enter(w_Enter)
    );









    

















endmodule