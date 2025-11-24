module peripheral_div (
    clk,
    rst,
    d_in,
    cs,
    addr,
    rd,
    wr,
    d_out
);

  input clk;
  input rst;
  input [15:0] d_in;
  input cs;
  input [4:0] addr;
  input rd;
  input wr;
  output reg [15:0] d_out;


  reg [4:0] select_reg;
  reg [15:0] in_A;
  reg [15:0] in_B;
  reg init;


  wire [15:0] out_R;
  wire out_done;


  always @(*) begin 
    if (cs) begin
      case (addr)
        5'h04:   select_reg = 5'b00001;  // in_A
        5'h08:   select_reg = 5'b00010;  // in_B
        5'h0C:   select_reg = 5'b00100;  // init
        5'h10:   select_reg = 5'b01000;  // out_R
        5'h14:   select_reg = 5'b10000;  // done
        default: select_reg = 5'b00000;
      endcase
    end else select_reg = 5'b00000;
  end  




  always @(posedge clk) begin  

    if (rst) begin
      init = 0;
      in_A = 0;
    end else begin
      if (cs && wr) begin
        in_A = select_reg[0] ? d_in : in_A; 
        in_B = select_reg[1] ? d_in : in_B;
        init = select_reg[2] ? d_in[0] : init;
      end
    end

  end  


  always @(posedge clk) begin 
    if (rst) d_out = 0;
    else if (cs) begin
      case (select_reg[4:0])
        5'b01000: d_out = out_R;
        5'b10000: d_out = {31'b0, out_done};
      endcase
    end
  end  




  div_16 div_16 (
      .rst    (rst),
      .clk    (clk),
      .init_in(init),
      .A      (in_A),
      .B      (in_B),
      .R      (out_R),
      .done   (out_done)
  );

endmodule
