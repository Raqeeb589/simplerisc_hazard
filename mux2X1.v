// 2:1 Multiplexer with Asynchronous Reset
// Selects between two 32-bit inputs with priority on reset
module mux2x1(x,z,sel,rst,y );
input [31:0]x,z;
input sel,rst;
output [31:0]y;

assign y = ( rst )? 0 : 
            (sel == 0)? x : z; // sel=0 selects x, sel=1 selects z
endmodule
