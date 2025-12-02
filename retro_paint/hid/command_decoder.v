// -----------------------------------------------------------------------------
// command_decoder.v
// Decodifica mensajes ASCII tipo:  CMD,XX,YY\n
// Ejemplo:  UP,12,4
// -----------------------------------------------------------------------------

module command_decoder(
    input  wire clk,
    input  wire [127:0] line,
    input  wire line_ready,

    output reg        cmd_valid,
    output reg [3:0]  cmd_id,
    output reg [6:0]  x,
    output reg [6:0]  y
);

    // Extraer primeros caracteres como string
    wire [7:0] c0 = line[7:0];
    wire [7:0] c1 = line[15:8];
    wire [7:0] c2 = line[23:16];
    wire [7:0] c3 = line[31:24];
    wire [7:0] c4 = line[39:32];
    wire [7:0] c5 = line[47:40];

    // Señales internas
    reg [31:0] num1, num2;

    // Conversión ASCII decimal → número
    function automatic [31:0] atoi;
        input [7:0] a, b;
        begin
            if (b >= "0" && b <= "9")
                atoi = (a - "0")*10 + (b - "0");
            else
                atoi = (a - "0");
        end
    endfunction

    // HASH simple para comandos
    function automatic [3:0] cmd_hash;
        input [7:0] a, b, c;
        begin
            case ({a,b,c})
                {"U","P",","} : cmd_hash = 4'd1;
                {"D","O","W"} : cmd_hash = 4'd2;
                {"L","E","F"} : cmd_hash = 4'd3;
                {"R","I","G"} : cmd_hash = 4'd4;
                {"E","N","T"} : cmd_hash = 4'd5;
                {"C","O","L"} : cmd_hash = 4'd6;
                {"P","A","L"} : cmd_hash = 4'd7;
                default       : cmd_hash = 4'd0;
            endcase
        end
    endfunction

    // Lógica principal
    always @(posedge clk) begin
        cmd_valid <= 0;

        if (line_ready) begin
            // Identificar comando
            cmd_id <= cmd_hash(c0,c1,c2);

            // Extraer números: formato "CMD,XY,ZZ"
            num1 = atoi(c4, c5);
            num2 = atoi(line[55:48], line[63:56]);

            x <= num1[6:0];
            y <= num2[6:0];

            cmd_valid <= 1;
        end
    end

endmodule
