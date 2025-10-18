module peripheral_BCD (
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
  output reg [31:0] d_out;

  //------------------------------inputs--------------------------------
  reg [5:0] select;
  reg [8:0] in_BIN;
  reg init;

  //------------------------------outputs-------------------------------
  wire [31:0] out_UND;
  wire [31:0] out_DEC;
  wire [31:0] out_CEN;
  wire out_done;

  //--------------------------address_decoder---------------------------
  always @(*) begin
    if (cs) begin
      case (addr)
        6'h04:   select = 6'b000001;  // in_BIN
        6'h08:   select = 6'b000010;  // init
        6'h0C:   select = 6'b000100;  // out_UND
        6'h10:   select = 6'b001000;  // out_DEC
        6'h14:   select = 6'b010000;  // out_CEN
        6'h18:   select = 6'b100000;  // done
        default: select = 6'b000000;
      endcase
    end else select = 6'b000000;
  end

  always @(posedge clk) begin  //-------------------- escritura de registros
    if (rst) begin
      init   = 0;
      in_BIN = 0;
    end else begin
      if (cs && wr) begin
        in_BIN = select[0] ? d_in : in_BIN;
        init   = select[1] ? d_in[0] : init;
      end
    end
  end

  always @(posedge clk) begin  //-----------------------mux_4 :  multiplexa salidas del periferico
    if (rst) d_out = 0;
    else if (cs) begin
      case (select[5:2])
        4'b0001: d_out = out_UND;
        4'b0010: d_out = out_DEC;
        4'b0100: d_out = out_CEN;
        4'b1000: d_out = {31'b0, out_done};
      endcase
    end
  end

  BIN_TO_BCD bcd1 (
      .rst(rst),
      .clk(clk),
      .init(init),
      .out_DONE(out_done),
      .out_UND(out_UND),
      .out_DEC(out_DEC),
      .out_CEN(out_CEN),
      .in_BIN(in_BIN)
  );


endmodule
