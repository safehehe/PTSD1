module command_decoder(
    input  wire clk,
    input  wire line_ready,
    input  wire [127:0] line,

    output reg [3:0] cmd_id,
    output reg [6:0] x,
    output reg [6:0] y,
    output reg new_cmd
);

// IDs de comandos
localparam UP            = 1;
localparam DOWN          = 2;
localparam LEFT          = 3;
localparam RIGHT         = 4;
localparam ENTER         = 5;
localparam COLOR         = 6;
localparam PALETTE_MOVE  = 7;
localparam PALETTE_SELECT= 8;
localparam RETURN_DRAW   = 9;

integer i;
reg [7:0] c;

reg [31:0] token = 0;
reg [1:0] stage = 0; // 0=command,1=x,2=y
reg [6:0] temp_num = 0;

always @(posedge clk) begin
    new_cmd <= 0;

    if (line_ready) begin
        cmd_id <= 0;
        x <= 0;
        y <= 0;
        temp_num <= 0;
        token <= 0;
        stage <= 0;

        // Recorrer todos los caracteres
        for (i=0; i<128; i=i+8) begin
            c = line[i +: 8];

            if (c == 0) break;
            if (c == ",") begin
                if (stage == 0) begin
                    if (token == "UP") cmd_id = UP;
                    else if (token == "DOWN") cmd_id = DOWN;
                    else if (token == "LEFT") cmd_id = LEFT;
                    else if (token == "RIGHT") cmd_id = RIGHT;
                    else if (token == "ENTER") cmd_id = ENTER;
                    else if (token == "COLOR") cmd_id = COLOR;
                    else if (token == "PALETTE_MOVE") cmd_id = PALETTE_MOVE;
                    else if (token == "PALETTE_SELECT") cmd_id = PALETTE_SELECT;
                    else if (token == "RETURN_TO_DRAW") cmd_id = RETURN_DRAW;
                end else if (stage == 1) begin
                    x <= temp_num;
                end

                temp_num <= 0;
                token <= 0;
                stage <= stage + 1;
            end else begin
                if (stage == 0) begin
                    token = (token << 8) + c;
                end else begin
                    temp_num = temp_num * 10 + (c - "0");
                end
            end
        end

        y <= temp_num;
        new_cmd <= 1;
    end
end

endmodule
