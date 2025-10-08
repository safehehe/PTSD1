module peripheral_raiz (
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

  //-------------------------------inputs-------------------------------
  reg [4:0] select_reg;
  reg [15:0] in_RR;
  reg init;

  //-------------------------------outputs-------------------------------------
  wire [15:0] out_R;
  wire [15:0] out_Q;
  wire done;


  always @(*) begin  //------address_decoder------------------------------
    if (cs) begin
      case (addr)
        5'h04:   select_reg = 5'b00001;  // in_RR
        5'h08:   select_reg = 5'b00010;  // init
        5'h0C:   select_reg = 5'b00100;  // out_R
        5'h10:   select_reg = 5'b01000;  // out_Q
        5'h14:   select_reg = 5'b10000;  // done
        default: select_reg = 5'b00000;
      endcase
    end else select_reg = 5'b00000;
  end  //------------------address_decoder--------------------------------




  always @(posedge clk) begin  //-------------------- escritura de registros 

    if (rst) begin
      init  = 0;
      in_RR = 0;
    end else begin
      if (cs && wr) begin
        in_RR = select_reg[0] ? d_in : in_RR;  //Write Registers
        init  = select_reg[1] ? d_in[0] : init;
      end
    end

  end  //------------------------------------------- escritura de registros


  always @(posedge clk) begin  //-----------------------mux_4 :  multiplexa salidas del periferico
    if (rst) d_out = 0;
    else if (cs) begin
      case (select_reg[4:0])
        5'b00100: d_out = out_R;
        5'b01000: d_out = out_Q;
        5'b10000: d_out = {31'b0, done};
      endcase
    end
  end  //-----------------------------------------------mux_4




  raiz_16 raiz1 (
      .rst(rst),
      .clk(clk),
      .init(init),
      .out_DONE(done),
      .out_R(out_R),
      .out_Q(out_Q),
      .in_RR(in_RR)
  );

endmodule
