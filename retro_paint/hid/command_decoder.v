// parsea la línea ASCII y emite cmd_valid, cmd_id, x, y
module command_decoder(
    input  wire clk,
    input  wire [127:0] line,
    input  wire line_ready,

    output reg        cmd_valid,
    output reg [3:0]  cmd_id,
    output reg [6:0]  x,
    output reg [6:0]  y
);

    wire [7:0] c0 = line[7:0];
    wire [7:0] c1 = line[15:8];
    wire [7:0] c2 = line[23:16];
    wire [7:0] c3 = line[31:24];
    wire [7:0] c4 = line[39:32];
    wire [7:0] c5 = line[47:40];

    wire [7:0] d0 = line[55:48];
    wire [7:0] d1 = line[63:56];

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
                default        : cmd_hash = 4'd0;
            endcase
        end
    endfunction

    function automatic [6:0] ascii_to_num;
        input [7:0] a, b;
        reg [7:0] tens, ones;
        begin
            tens = (a >= "0" && a <= "9") ? a - "0" : 0;
            ones = (b >= "0" && b <= "9") ? b - "0" : 0;
            ascii_to_num = tens*10 + ones;
        end
    endfunction

    always @(posedge clk) begin
        cmd_valid <= 0;
        if (line_ready) begin
            cmd_id <= cmd_hash(c0,c1,c2);
            x <= ascii_to_num(c4, c5);
            y <= ascii_to_num(d0, d1);
            cmd_valid <= 1;
        end
    end
endmodule

