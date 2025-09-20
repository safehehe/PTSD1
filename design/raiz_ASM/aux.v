module aux (
    clk,
    load,
    in_R,
    out_AUX
);

input clk;
input load;
input [31:0] in_R;
output reg [31:0] out_AUX;

always @(negedge clk ) begin
    if (load) out_AUX = in_R << 1 + 1;
    else begin
        out_AUX = out_AUX;
    end
end
endmodule
