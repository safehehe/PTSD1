`timescale 1ns/1ps

module tb_sistema();
    reg clk = 0;
    reg rx = 1;
    reg reset = 1;
    
    wire [2:0] cmd;
    wire [5:0] x, y;
    wire valid;

    // Generar reloj 50MHz (20ns)
    always #10 clk = ~clk;

    // Instanciar el TOP
    top_fpga dut (
        .clk(clk),
        .rx_pin(rx),
        .reset_btn(~reset), // El top invierte el reset
        .cmd_to_screen(cmd),
        .x_to_screen(x),
        .y_to_screen(y),
        .valid_pulse(valid)
    );

    // Tarea para enviar un byte serial (9600 baudios es muy lento para simular, 
    // así que simularemos un baudrate "falso" rápido o simplemente inyectaremos bytes
    // ajustando el parámetro BAUD_RATE en la instancia UART del testbench si fuera necesario.
    // Para simplificar, calcularemos el tiempo real de 9600: 1 bit = 104166 ns
    localparam BIT_TIME = 104166; 

    task send_byte(input [7:0] data);
        integer i;
        begin
            rx = 0; #BIT_TIME; // Start
            for(i=0; i<8; i=i+1) begin
                rx = data[i]; #BIT_TIME;
            end
            rx = 1; #BIT_TIME; // Stop
            #(BIT_TIME*2); // Espera entre bytes
        end
    endtask

    initial begin
        $dumpfile("simulacion.vcd");
        $dumpvars(0, tb_sistema);

        reset = 1; 
        #100 reset = 0; // Soltar reset
        #1000;

        // --- PRUEBA 1: MOVER A (10, 5) ---
        // Protocolo: Header(CMD=1) -> X -> Y
        // Header: 11000001 = 0xC1
        send_byte(8'hC1); 
        send_byte(8'd10);
        send_byte(8'd5);

        // --- PRUEBA 2: PINTAR EN (10, 5) ---
        // Header: 11000010 = 0xC2 (CMD=2 Draw)
        send_byte(8'hC2);
        send_byte(8'd10);
        send_byte(8'd5);

        #500000;
        $finish;
    end
endmodule