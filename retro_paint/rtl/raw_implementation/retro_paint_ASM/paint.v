module paint (
    input clk,
    input rst,
    input init,
    
    input wire [5:0] x_in,      
    input wire [5:0] y_in,     
    input wire [7:0] button_keyboard,        
    
    output reg paleta,                 // Señal para pintar paleta de colores
    output reg [5:0] x_out,            // Coordenada X 
    output reg [5:0] y_out,            // Coordenada Y 
    output reg [7:0] pixel_data,       // Color RGB de salida
    output reg paint,                  // Señal de escritura 
    output reg selector                // Selector de pantalla (0 o 1)
);
    
    reg [7:0] color;
    reg [23:0] cont_cursor;
    wire OS;
    reg [5:0] x;
    reg [5:0] y;
    reg [7:0] button;


    wire w_C;
    wire w_Enter


    check #(
        .WIDTH(8)
    ) checkC( 
        .data_in(button),
        .comparador(8'h43),
        .checkout(w_C)
    );
    

    check #(
        .WIDTH(8)
    ) checkEnter(
        .data_in(button),
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
    )









    

















endmodule