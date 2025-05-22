//-------------------------
// PC + 4 Adder
//-------------------------
module pc_plus4(pc,pcplus4);
input [31:0] pc;
output reg [31:0] pcplus4;
always @(*)
begin
    pcplus4 = pc + 4; // Computes pcplus4 = pc + 4 (next sequential instruction)
end
endmodule
