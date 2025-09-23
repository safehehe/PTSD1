module control_BCD (
clk,
rst,
in_init,
in_K,
in_sum_UND,
in_sum_DEC,
out_S1,
    out_S2,
    out_S3,
    out_S4,
out_S5,
    out_RST,
    out_DONE
);
input clk;
input rst;
input in_init;
input in_K;
input [3:0] in_sum_UND;
input [3:0] in_sum_DEC;
  output reg out_S1;
  output reg out_S2;
  output reg out_S3;
  output reg out_S4;
output reg out_S5;
  output reg out_RST;
  output reg out_DONE;

parameter START =4'b0000; 
parameter SHIFT =4'b0001;
parameter CHECK_NEG =4'b0010;
parameter PRE_LOAD =4'b0011;
parameter LOAD_UND =4'b0100;
parameter LOAD_DEC =4'b0101;
parameter LOAD_ALL =4'b0110;
parameter ITERATE =4'b0111;
parameter DONE =4'b1000;
reg [3:0] state;

parameter GE_NEG_UND = 2'b10;//Negate Great Equal  UND 0 if UND>=5
parameter GE_NEG_DEC = 2'b01;//Negate Great Equal  DEC 0 if UND>=5
parameter GE_NEG_ALL = 2'b00;//MSB:DEC, LBS:UND
reg [1:0] state_comp; //Guarda los valores de comparación mayor o igual

always @(posedge clk) begin
	if (rst) state = START;
	else begin
		case(state)
		START: state = in_init ? SHIFT : START;
		SHIFT: state = CHECK_NG;
		CHECK_NG : begin
		state_comp = {in_sum_DEC[3],in_sum_UND[3]};
		state = PRE_LOAD;
		end
		PRE_LOAD:begin
		if (GE_NEG_ALL) state = LOAD_ALL;
		else if (GE_NEG_DEC) state = LOAD_DEC;
		else if (GE_NEG_UND) state = LOAD_UND;
		end
		LOAD_UND,LOAD_DEC,LOAD_ALL: state = ITERATE;
		ITERATE: state = in_K ? DONE : SHIFT;
		DONE : state = START;
		default : state = START;
		endcase	
	end
end




always @(*) begin
	case (state)
	START:begin
		out_RST=1;
		out_S1=0;
		out_S2=0;
		out_S3=0;
		out_S4=0;
		out_S5=0;
		out_DONE=0;
	end
	SHIFT:begin
		out_RST=0;
		out_S1=1;
		out_S2=0;
		out_S3=0;
		out_S4=0;
		out_S5=0;
		out_DONE=0;
	end
	CHECK_NEG:begin
		out_RST=0;
		out_S1=0;
		out_S2=1;
		out_S3=0;
		out_S4=0;
		out_S5=0;
		out_DONE=0;
	end
	PRE_LOAD:begin
		out_RST=0;
		out_S1=0;
		out_S2=0;
		out_S3=0;
		out_S4=0;
		out_S5=0;
		out_DONE=0;
	end
	LOAD_UND:begin
		out_RST=0;
		out_S1=0;
		out_S2=0;
		out_S3=1;
		out_S4=0;
		out_S5=0;
		out_DONE=0;
	end
	LOAD_DEC:begin
		out_RST=1;
		out_S1=0;
		out_S2=0;
		out_S3=0;
		out_S4=1;
		out_S5=0;
		out_DONE=0;
	end
	LOAD_ALL:begin
		out_RST=1;
		out_S1=0;
		out_S2=0;
		out_S3=1;
		out_S4=1;
		out_S5=0;
		out_DONE=0;
	end
	ITERATE:begin
		out_RST=0;
		out_S1=0;
		out_S2=0;
		out_S3=0;
		out_S4=0;
		out_S5=1;
		out_DONE=0;
	end
	DONE:begin
		out_RST=0;
		out_S1=0;
		out_S2=0;
		out_S3=0;
		out_S4=0;
		out_S5=0;
		out_DONE=1;
	end
end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      SHIFT: state_name = "SHIFT";
      CHECK_NEG: state_name = "CHECK_NEG";
      PRE_LOAD: state_name = "PRE_LOAD";
      LOAD_UND: state_name = "LOAD_UND";
      LOAD_DEC: state_name = "LOAD_DEC";
      LOAD_ALL: state_name = "LOAD_ALL";
	ITERATE: state_nanme ="ITERATE";
	DONE: state_name = "DONE";
    endcase

  end
`endif

endmodule