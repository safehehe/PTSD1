module draw_engine (
    input  wire        clk,
    input  wire        reset,

    // decoded command inputs
    input  wire        cmd_valid,
    input  wire [3:0]  cmd_id,
    input  wire [6:0]  x_in,
    input  wire [6:0]  y_in,

    // outputs to the drawing/pixel engine
    output reg         mode, // 0 = DRAW, 1 = PALETTE
    output reg [6:0]   cursor_x,
    output reg [6:0]   cursor_y,

    // palette cursor (only valid in mode==1)
    output reg [3:0]   p_px,
    output reg [3:0]   p_py,

    // write outputs (pulse)
    output reg         write_strobe,
    output reg [6:0]   write_x,
    output reg [6:0]   write_y,
    output reg [7:0]   write_color,

    // currently selected color index (0..255)
    output reg [7:0]   selected_color
);

// command encoding (mirror these with your command_decoder)
localparam CMD_NONE         = 4'd0;
localparam CMD_UP           = 4'd1;
localparam CMD_DOWN         = 4'd2;
localparam CMD_LEFT         = 4'd3;
localparam CMD_RIGHT        = 4'd4;
localparam CMD_ENTER        = 4'd5;
localparam CMD_COLOR        = 4'd6;
localparam CMD_PALETTE_MOVE = 4'd7;
localparam CMD_PALETTE_SEL  = 4'd8;
localparam CMD_RETURN_DRAW  = 4'd9;

reg [6:0] saved_x, saved_y;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        mode <= 0;
        cursor_x <= 0;
        cursor_y <= 0;
        p_px <= 0;
        p_py <= 0;
        saved_x <= 0;
        saved_y <= 0;
        write_strobe <= 0;
        write_x <= 0;
        write_y <= 0;
        write_color <= 0;
        selected_color <= 0;
    end else begin
        // default outputs
        write_strobe <= 0;

        if (cmd_valid) begin
            case (cmd_id)
                CMD_UP: begin
                    if (!mode) begin // DRAW mode
                        if (cursor_y > 0) cursor_y <= cursor_y - 1;
                    end else begin // PALETTE mode
                        if (p_py > 0) p_py <= p_py - 1;
                    end
                end

                CMD_DOWN: begin
                    if (!mode) begin
                        if (cursor_y < 7'd63) cursor_y <= cursor_y + 1;
                    end else begin
                        if (p_py < 4'd15) p_py <= p_py + 1;
                    end
                end

                CMD_LEFT: begin
                    if (!mode) begin
                        if (cursor_x > 0) cursor_x <= cursor_x - 1;
                    end else begin
                        if (p_px > 0) p_px <= p_px - 1;
                    end
                end

                CMD_RIGHT: begin
                    if (!mode) begin
                        if (cursor_x < 7'd63) cursor_x <= cursor_x + 1;
                    end else begin
                        if (p_px < 4'd15) p_px <= p_px + 1;
                    end
                end

                CMD_ENTER: begin
                    if (!mode) begin
                        // paint pixel at cursor using selected_color
                        write_x <= cursor_x;
                        write_y <= cursor_y;
                        write_color <= selected_color;
                        write_strobe <= 1;
                    end else begin
                        // in palette, ENTER can be used to select color as well
                        selected_color <= {4'b0, p_py} << 4 | p_px; // (py*16)+px
                        // exit palette
                        mode <= 0;
                        cursor_x <= saved_x;
                        cursor_y <= saved_y;
                    end
                end

                CMD_COLOR: begin
                    // open palette: save current position and move to palette origin (0,0)
                    saved_x <= cursor_x;
                    saved_y <= cursor_y;
                    mode <= 1;
                    p_px <= 0;
                    p_py <= 0;
                end

                CMD_PALETTE_MOVE: begin
                    // Some decoders will pass x_in/y_in with new palette coords
                    // If your command_decoder sends the palette position in x_in,y_in then:
                    if (x_in[3:0] <= 4'd15) p_px <= x_in[3:0];
                    if (y_in[3:0] <= 4'd15) p_py <= y_in[3:0];
                    // otherwise, use arrows PALETTE_MOVE as directional -> no-op here
                end

                CMD_PALETTE_SEL: begin
                    // select current p_px,p_py
                    selected_color <= {4'b0, p_py} << 4 | p_px;
                    // exit palette and restore position
                    mode <= 0;
                    cursor_x <= saved_x;
                    cursor_y <= saved_y;
                end

                CMD_RETURN_DRAW: begin
                    // explicit return: restore position and exit palette
                    mode <= 0;
                    cursor_x <= saved_x;
                    cursor_y <= saved_y;
                end

                default: begin
                    // NOP / unknown
                end
            endcase
        end
    end
end

endmodule
