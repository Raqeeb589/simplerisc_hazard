// Writeback Stage Module
// Handles final data selection and register file update
module writeback_cycle(clk,rst,RS1_RW,RS2_RW,RD_RW,ra_RW,pc_RW,alu_result_RW,instruction_RW,ldresult_RW,isRet_RW,isSt_RW,isWb_RW,isImmediate_RW,isBeq_RW,isBgt_RW,isUbranch_RW,isLd_RW,isCall_RW,alusignals_RW,data_RW,iswb_RW_D,reg_RW );
input clk,rst;
input [3:0]RS1_RW,RS2_RW,RD_RW,ra_RW;
input  [31:0]pc_RW,alu_result_RW,instruction_RW,ldresult_RW;
input  isRet_RW,isSt_RW,isWb_RW,isImmediate_RW,isBeq_RW,isBgt_RW,isUbranch_RW,isLd_RW,isCall_RW;
input  [4:0]alusignals_RW;
output [31:0]data_RW;
output iswb_RW_D;
output [3:0]reg_RW;
// Internal signals
wire [31:0]pcplus4_top1;
reg iswb_rw;  // Registered write-back enable
// Calculate next sequential address (PC + 4)
pc_plus4 p4(.pc(pc_RW),.pcplus4(pcplus4_top1));
// Data Source Selection MUX (3:1)
// 00: ALU result (normal operations)
// 01: Load data (memory read)
// 10: PC+4 (call/return address)
// 11: Undefined (defaults to ALU)
mux3x1 m10(.in0(alu_result_RW),.in1(ldresult_RW),.in2(pcplus4_top1),.sel({isCall_RW,isLd_RW}), .out(data_RW) );
// Destination Register Selection MUX (2:1)
mux2x1_4bit m15(.x(RD_RW),.z(ra_RW),.sel(isCall_RW),.rst(rst),.y(reg_RW));


// Output assignments
assign iswb_RW_D = isWb_RW;

endmodule
