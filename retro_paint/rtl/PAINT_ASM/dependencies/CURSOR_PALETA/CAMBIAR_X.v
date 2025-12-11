module CAMBIAR_X(
    clk,
    rst,
    in_x,
    loadx,
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
    output reg [5:0] out_x;

    reg [5:0] x;

    always @(negedge clk) begin
        if (loadx) begin
            x = in_x;
        end else begin
            x = x;
        end
        if (rst) begin
            out_x = 0;
        end else begin
            
            if (plus) begin
                out_x = sum ? 4*x + C : 4*x + 3 - C;
            end 
        end
    end
    

endmodule
