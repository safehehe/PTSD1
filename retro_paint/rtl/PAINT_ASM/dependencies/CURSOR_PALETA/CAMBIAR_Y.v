module CAMBIAR_Y(
    clk,
    rst,
    in_y,
    loady,
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
    output reg [5:0] out_y;

    reg [5:0] y;

    always @(negedge clk) begin
        if (loady) begin
            y = in_y;
        end else begin
            y = y;
        end
        if (rst) begin
            out_y = 0;
        end else begin
            
            if (plus) begin
                out_y = sum ? 4*y + C : 4*y  + 3 - C;
            end 
        end
    end
    

endmodule
