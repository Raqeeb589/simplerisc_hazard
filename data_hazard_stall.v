module data_hazard_stall(clk,instruction_D,isWb_D,instruction_M,instruction_E,isWb_E,add_stall);
input clk;
input isWb_E;
input isWb_D;
input [31:0]instruction_M,instruction_E,instruction_D;
output add_stall;

assign add_stall = ((instruction_E[31:27] == 5'b01110) & ((instruction_E[25:22] == instruction_D[21:18]) | (instruction_E[25:22] == instruction_D[17:14])) &(isWb_D)) ? 1'b1 : 1'b0 ; 


endmodule
