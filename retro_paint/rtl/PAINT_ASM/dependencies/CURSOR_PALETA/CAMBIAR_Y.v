module CAMBIAR_Y(
    clk,
    rst,
    in_y,
    out_y,
    plus,
    sum,
    C
);
    input clk;
    input rst;
    input plus;
    input sum;
    input [2:0] C;
    input [5:0] in_y;
    output reg [8:0] out_y;

    always @(negedge clk) begin
        if (rst) begin
            out_y = 0;
        end else begin
            if (plus) begin
                out_y = sum ? 4*in_y + C : 4*in_y - C;
            end 
        end
    end
    

endmodule
