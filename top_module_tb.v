`timescale 1ns / 1ps

module top_module_tb;

    reg clk;
    reg rst;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period (100MHz)
    always #5 clk = ~clk;
  

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;

        // Hold reset for a few cycles
        #6;
        rst = 0;

        // Let the simulation run for 200ns
        #2000000 $finish;

   
    end

endmodule
