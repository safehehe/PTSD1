`timescale 1ns / 1ps
`define SIMULATION

module contar_blanco_TB;
    reg clk;
    reg rst;
    reg init;
    wire CB;



    contar_blanco uut(
      .clk (clk),
      .rst (rst),
      .init(init),
      .CB  (CB)
    );

    parameter PERIOD = 20;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 0;
    reg [20:0] i;
    event reset_trigger;
    event reset_done_trigger;

    initial begin
        forever begin
            @(reset_trigger);
            @(negedge clk);
            rst = 1;
            repeat (2) @(negedge clk);
            rst = 0;
            ->reset_done_trigger;
        end
    end

    initial begin
        clk = 0;
        rst = 1;
        init = 0;
    end

    initial begin
        #OFFSET;
        forever begin
        clk = 1'b0;
        #(PERIOD - (PERIOD * DUTY_CYCLE)) clk = 1'b1;
        #(PERIOD*DUTY_CYCLE);
        end
    end 

    initial begin
        #10 -> reset_trigger;
        @ (reset_done_trigger);
        @ (posedge clk);
        init = 0;
        @ (posedge clk);
        init = 1;

        repeat (2) @(posedge clk);
        init = 0;

        for (i = 0;i<17; i=i+1) begin
        @ (posedge clk);
        end
    end

    initial begin : TEST_CASE
        $dumpfile("contar_blanco_TB.vcd");
        $dumpvars(-1, uut);
        #((PERIOD*DUTY_CYCLE)*120) $finish;
    end


endmodule