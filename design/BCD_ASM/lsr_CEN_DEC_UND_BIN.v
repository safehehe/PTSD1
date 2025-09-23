module lsr_CEN_DEC_UND_BIN (
	clk,
	load_BIN,
	shift,
	load_UND,
	load_DEC,
	in_BIN,
	in_UND,
	in_DEC,
	out_UND,
	out_DEC,
	out_CEN
);
input clk;
input load_BIN;
input shift;
input load_UND;
input load_DEC;
input [7:0] in_BIN;
input [3:0] in_UND;
input [3:0] in_DEC;
output reg [3:0] out_UND;
output reg [3:0] out_DEC;
output reg [3:0] out_CEN;
reg [3:0] reg_BIN;
always @(negedge clk) begin
	if (load_BIN) begin
		reg_BIN = in_BIN;
		out_UND = 4'h0;
		out_DEC = 4'h0;
		out_CEN = 4'h0;
	end else begin
		if (shift) {out_CEN,out_DEC,out_UND,reg_BIN} = {out_CEN,out_DEC,out_UND,reg_BIN} << 1;
		else begin
			if (load_UND) out_UND = in_UND;
			if (load_DEC) out_DEC = in_DEC;
			else begin
				reg_BIN = reg_BIN;
				out_UND = out_UND;
				out_DEC = out_DEC;
				out_CEN = out_CEN;
			end
		end
	end
end


endmodule