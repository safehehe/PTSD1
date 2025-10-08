`timescale 1us / 1ns

module BCD_TO_7SEG_TB;

  parameter PERIOD = 1;

  // Señales de registro para las entradas del DUT
  reg [3:0] in_BCD;
  reg clk;
  reg [8*10-1:0] seg_name;
  wire [7:0] out_7SEG;

  BCD_TO_7SEG uut (
      .in_BCD  (in_BCD),
      .out_7SEG(out_7SEG)
  );

  initial begin
    clk = 1'b0;  // Inicializar clk en bajo
    forever begin
      #(PERIOD) clk = ~clk;  // Alternar el estado cada 'PERIOD' (1us)
    end
  end


  initial begin

    // Inicialización de la entrada a un valor conocido y reset
    in_BCD = 4'b0000;

    // Esperar a 2 flancos de subida del reloj (2 ciclos completos de 2us)
    repeat (2) @(posedge clk);

    // Prueba de los dígitos BCD conocidos (0 a 9)
    for (integer i = 0; i < 10; i = i + 1) begin
      // El cambio de la entrada ocurre en el flanco de subida
      @(posedge clk) in_BCD = i;

      // La entrada se mantiene durante 2 ciclos de reloj (2 * @(posedge clk))
      repeat (2) @(posedge clk);
    end

    // Prueba de un caso de dígito no conocido (Default: 4'b1010)
    @(posedge clk) in_BCD = 4'b1010;

    // Mantener por dos ciclos más
    repeat (2) @(posedge clk);

    $finish;
  end

  always @(out_7SEG) begin
    case (out_7SEG)
      // Patrones de 7-segmentos (a, b, c, d, e, f, g, dp)
      8'b1111_1100 : seg_name = "CERO";
      8'b0110_0000 : seg_name = "UNO";
      8'b1101_1010 : seg_name = "DOS";
      8'b1111_0010 : seg_name = "TRES";
      8'b0110_0110 : seg_name = "CUATRO";
      8'b1011_0110 : seg_name = "CINCO";
      8'b1011_1110 : seg_name = "SEIS";
      8'b1110_0000 : seg_name = "SIETE";
      8'b1111_1110 : seg_name = "OCHO";
      8'b1110_0110 : seg_name = "NUEVE";
      8'b0110_1101 : seg_name = "NODEF";
      default: seg_name = "ERROR";
    endcase
  end

  initial begin : TEST_CASE
    $dumpfile("BCD_TO_7SEG_TB.vcd");
    $dumpvars(0, BCD_TO_7SEG_TB);
  end

endmodule
