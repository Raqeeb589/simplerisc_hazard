//-------------------------
// Immediate Generator
//-------------------------
// Generates sign-extended immediate and branch target address from instruction.
module immediate_generator(pc,instruction,immx,branch_target);
input [31:0]pc,instruction;
output reg [31:0]immx,branch_target;

always @(*)
begin
    immx <= {{14{instruction[17]}},instruction[17:0]};
    branch_target <= pc + ({{5{instruction[26]}}, instruction[26:0]} << 2);
end
endmodule