module paint (
    input wire clk,
    input wire rst,
    
    input wire [5:0] x_in,      
    input wire [5:0] y_in,     
    input wire [7:0] button_keyboard,  
    
    input wire VRAM_AVAILABLE,        
    

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


    wire w_VRAM;
    wire w_C;
    wire w_OS;



    check #(
        .WIDTH(1)
    ) checkVRAM(
        .data_in(VRAM_AVAILABLE),
        .comparador(1'b0),
        .checkout(w_VRAM)
    );

    check #(
        .WIDTH(8)
    ) checkC(
        .data_in(button),
        .comparador(8'h43),
        .checkout(w_C)
    );
    

    overlay_selector overlay_selector(
        .C(w_C),
        .OS(OS)
    );

    check #(
        .WIDTH(1)
    ) checkOS(
        .data_in(OS),
        .comparador(1'b0),
        .checkout(w_OS)
    );

    

















endmodule