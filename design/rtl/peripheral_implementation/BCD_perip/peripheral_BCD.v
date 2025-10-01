module peripheral_BCD (
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
  input reset;
  input [15:0] d_in;
  input cs;
  input [4:0] addr;
  input rd;
  input wr;
  output reg [31:0] d_out;

  //------------------------------inputs--------------------------------
  reg [5:0] s; 
  reg [15:0] in_BIN;  
  reg init;

  //------------------------------outputs-------------------------------
  wire [31:0] out_UND;
  wire [31:0] out_DEC;
  wire [31:0] out_CEN;
  wire done;

  //--------------------------address_decoder---------------------------
  always @(*) begin  
    if (cs) begin
      case (addr)
        6'h04:   s = 6'b000001;  // in_BIN 
        6'h08:   s = 6'b000010;  // init
        6'h0C:   s = 6'b000100;  // out_UND
        6'h10:   s = 6'b001000;  // out_DEC
        6'h14:   s = 6'b010000;  // out_CEN
        6'h18:   s = 6'b100000;  // done
        default: s = 6'b000000;
      endcase
    end else s = 6'b000000;
  end

  always @(posedge clk) begin  //-------------------- escritura de registros 

    if (reset) begin
      init  = 0;
      in_BIN = 0;
    end else begin
      if (cs && wr) begin
        in_BIN = s[0] ? d_in    : in_BIN;
        init  = s[2] ? d_in[0] : init;
      end
    end
  end

  always @(posedge clk) begin  //-----------------------mux_4 :  multiplexa salidas del periferico
    if (reset) d_out = 0;
    else if (cs) begin
      case (s[4:0])
        6'b000100: d_out = out_UND;
        6'b001000: d_out = out_DEC;
        6'b010000: d_out = out_CEN;
        6'b100000: d_out = {31'b0, done};
      endcase
    end
  end

  bcd bcd1 (
      .reset(reset),
      .clk(clk),
      .init(init),
      .done(done),
      .und(out_UND),
      .cen(out_CEN),
      .dec(out_DEC),
      .in_BIN(in_BIN)
  );
 

endmodule