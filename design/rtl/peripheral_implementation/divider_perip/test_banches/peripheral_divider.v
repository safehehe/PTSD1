module peripheral_divider (
    clk,
    reset,
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
  reg [15:0] A; 
  reg [15:0] B;  
  reg init;

  //-------------------------------outputs-------------------------------------
  wire [15:0] Result;  
  wire done;


  always @(*) begin  //------address_decoder------------------------------
    if (cs) begin
      case (addr)
        5'h04:   s = 5'b00001;  // A 
        5'h08:   s = 5'b00010;  // B
        5'h0C:   s = 5'b00100;  // init
        5'h10:   s = 5'b01000;  // Result
        5'h14:   s = 5'b10000;  // done
        default: s = 5'b00000;
      endcase
    end else s = 5'b00000;
  end  //------------------address_decoder--------------------------------




  always @(posedge clk) begin  //-------------------- escritura de registros 

    if (reset) begin
      init  = 0;
      A = 0;
      B = 0;
    end else begin
      if (cs && wr) begin
        A = s[0] ? d_in    : A; //Write Registers
        B = s[1] ? d_in    : B;
        init  = s[2] ? d_in[0] : init;
      end
    end

  end  //------------------------------------------- escritura de registros


  always @(posedge clk) begin  //-----------------------mux_4 :  multiplexa salidas del periferico
    if (reset) d_out = 0;
    else if (cs) begin
      case (s[4:0])
        5'b00100: d_out = Result;
        5'b01000: d_out = {31'b0, done};
      endcase
    end
  end  //-----------------------------------------------mux_4




  divider divider1 (
      .reset(reset),
      .clk(clk),
      .init(init),
      .done(done),
      .result(Result),
  );

endmodule
