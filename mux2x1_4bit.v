// 4-bit 2:1 Multiplexer with Asynchronous Reset
// Selects between two 4-bit inputs with reset override
module mux2x1_4bit(x,z,sel,rst,y );
input [3:0]x,z;
input sel,rst;
output [3:0]y;
 
assign y = ( rst )? 0 : 
            (sel == 0)? x : z; //sel=1->z, sel=0->x
endmodule
