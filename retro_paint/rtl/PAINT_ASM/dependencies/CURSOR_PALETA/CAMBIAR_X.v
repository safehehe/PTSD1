module CAMBIAR_X(
    clk,
    rst,
    in_x,
    out_x,
    plus,
    sum,
    C
);
    input clk;
    input rst;
    input plus;
    input sum;
    input [2:0] C;
    input [5:0] in_x;
    output reg [8:0] out_x;

    always @(negedge clk) begin
        if (rst) begin
            out_x = 0;
        end else begin
            if (plus) begin
                out_x = sum ? 4*in_x + C : 4*in_x - C;
            end 
        end
    end
    

endmodule
