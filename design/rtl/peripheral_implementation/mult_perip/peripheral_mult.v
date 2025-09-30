module peripheral_mult (
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
  reg [4:0] reg_s;
  reg [15:0] reg_A;
  reg [15:0] reg_B;
  reg reg_init;
  wire [31:0] w_result;
  wire w_done;

  always @(*) begin
    if (cs) begin
      case (addr)
        5'h01:   s = 5'b00001;  // A
        5'h02:   s = 5'b00010;  // B
        5'h04:   s = 5'b00100;  // init
        5'h08:   s = 5'b01000;  // result
        5'h10:   s = 5'b10000;  // done
        default: s = 5'b00000;
      endcase
    end else s = 5'b00000;
  end

  always @(posedge clk) begin
    if (rst) begin
      reg_init  = 0;
      reg_A = 0;
      reg_B = 0;
    end else begin
      if (cs && wr) begin
        reg_A = s[0] ? d_in : reg_A;  //Write Registers
        reg_B = s[1] ? d_in : reg_B;  //Write Registers
        reg_init  = s[2] ? {31'b0, d_in[0]} : reg_init;
      end
    end
  end

  always @(posedge clk) begin
    if (rst) d_out = 0;
    else if (cs & rd) begin
      case (s[4:3])
        2'b01: d_out = w_result;
        2'b10: d_out = {31'b0, w_done};
        default:  d_out = 32'z;
      endcase
    end
  end

  mult_32 mult_32 (
      .rst (rst),
      .clk (clk),
      .init(reg_init),
      .A   (reg_A),
      .B   (reg_B),
      .pp  (w_result),
      .done(w_done)
  );

endmodule
