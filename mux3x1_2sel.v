// 3:1 Multiplexer with 2-bit Select
// Selects one of three 32-bit inputs based on a 2-bit select signal
module mux3x1_2sel(x,y,z,sel,out);
input [31:0]x,y,z;
input [1:0]sel;
output [31:0]out;
// Multiplexer logic:
// - sel == 2'b00: output x
// - sel == 2'b01: output y
// - sel == 2'b10: output z
assign out = (sel == 2'b00) ? x : (sel == 2'b01) ? y : (sel == 2'b10) ? z : 32'b0 ; 

endmodule
