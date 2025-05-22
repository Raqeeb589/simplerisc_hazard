
// Pipeline Execute Stage Module
// Handles ALU operations, branch resolution, and data forwarding

module execute_cycle(clk,rst,add_stall,memory_data_out,memory_unit_data,data_RW_E,data_M_E,forwardA_E,forwardB_E,forwardA,RS1_E,RS2_E,RD_E,ra_E,pc_E,branch_target_E,b_E,a_E,rd2_E,instruction_E,isRet_E,isSt_E,isWb_E,isImmediate_E,isBeq_E,isBgt_E,isUbranch_E,isLd_E,isCall_E,alusignals_E,isbranchtaken_E,pc_branch_E,pc_M,alu_result_M,rd2_M,instruction_M,isRet_M,isSt_M,isWb_M,isImmediate_M,isBeq_M,isBgt_M,isUbranch_M,isLd_M,isCall_M,alusignals_M,RS1_M,RS2_M,RD_M,ra_M);
input clk,rst;
input [31:0]data_RW_E,data_M_E;
input [1:0]forwardA_E,forwardB_E;
input [1:0]forwardA;
input add_stall;
input [31:0]memory_unit_data,memory_data_out;
input [3:0]RS1_E,RS2_E,RD_E,ra_E;
input  [31:0]pc_E,branch_target_E,b_E,a_E,rd2_E,instruction_E;
input  isRet_E,isSt_E,isWb_E,isImmediate_E,isBeq_E,isBgt_E,isUbranch_E,isLd_E,isCall_E;
input  [4:0]alusignals_E;
output isbranchtaken_E;
output [31:0]pc_branch_E;
output  [31:0]pc_M,alu_result_M,rd2_M,instruction_M;
output  isRet_M,isSt_M,isWb_M,isImmediate_M,isBeq_M,isBgt_M,isUbranch_M,isLd_M,isCall_M;
output  [4:0]alusignals_M;
output [3:0]RS1_M,RS2_M,RD_M,ra_M;


// Pipeline registers (E-M buffer)
reg  [31:0]pc_e,alu_result_e,rd2_e,instruction_e;
reg  isRet_e,isSt_e,isWb_e,isImmediate_e,isBeq_e,isBgt_e,isUbranch_e,isLd_e,isCall_e;
reg  [4:0]alusignals_e;
reg [3:0]RS1_e,RS2_e,RD_e,ra_e;
wire [31:0]rd2_mux;
// Internal execution signals
wire [31:0]aluresult_top;
wire [1:0]flags_top;
wire GT_flag_top,EQ_flag_top;
wire [31:0]a_alu_top,b_alu_top;
wire [31:0]sel_alu_mem;

assign sel_alu_mem = ((instruction_e[31:27] == 5'b01110) &(((instruction_e[25:22] == instruction_E[21:18]) | (instruction_e[25:22] == instruction_E[17:14])) & (isWb_E))) ? memory_data_out : data_M_E; 


 // Return address selection: Choose between branch target or register value   
mux2x1 m7(.x(branch_target_E),.z(a_E),.sel(isRet_E),.rst(rst),.y(pc_branch_E));
// Operand A Forwarding MUX (3:1)
mux3x1_2sel m22(.x(a_E),.y(data_RW_E),.z(data_M_E),.sel(forwardA_E),.out(a_alu_top)); // for a
// Operand B Forwarding MUX (3:1)
mux3x1_2sel m23(.x(b_E),.y(data_RW_E),.z(data_M_E),.sel(forwardB_E),.out(b_alu_top));  //for b
mux3x1_2sel m57(.x(rd2_E),.y(memory_unit_data),.z(data_M_E),.sel(forwardA),.out(rd2_mux));  //for b
//mux2x1 m57(.x(rd2_E),.z(),.sel(forwardA),.rst(rst),.y(rd2_mux)); //for rd2 
// Arithmetic Logic Unit
ALU alu(.a(a_alu_top),.b(b_alu_top),.alusignals(alusignals_E),.result(aluresult_top),.flags(flags_top));
// Flag Processing Unit
flag f(.isCMP(alusignals_E),.flags_in(flags_top),.GT_flag(GT_flag_top),.EQ_flag(EQ_flag_top));
// Branch Resolution Unit
branch_unit bu(.EQ_flag(EQ_flag_top),.GT_flag(GT_flag_top),.isBgt(isBgt_E),.isBeq(isBeq_E),.isUbranch(isUbranch_E),.isBranchtaken(isbranchtaken_E));

// Pipeline Register Update
always @(posedge clk)
begin
    if(rst)
    begin
    pc_e <=32'b0;
    alu_result_e <= 32'b0;
    rd2_e <= 32'b0; 
    instruction_e <= 32'b01101000000000000000000000000000;
    isRet_e <= 1'b0;
    isSt_e <= 1'b0;
    isWb_e <= 1'b0;
    isImmediate_e <= 1'b0;
    isBeq_e <= 1'b0;
    isBgt_e <= 1'b0;
    isUbranch_e <=1'b0;
    isLd_e <= 1'b0;
    isCall_e <= 1'b0;
    alusignals_e <=5'b0;
    RS1_e <= 4'bx;
    RS2_e <= 4'bx;
    RD_e <= 4'bx;
    ra_e <= 4'bx;
    end
    else
    begin
    pc_e <=pc_E;
    alu_result_e <= aluresult_top ;
    rd2_e <= rd2_mux; 
    instruction_e <= instruction_E;
    isRet_e <= isRet_E;
    isSt_e <= isSt_E;
    isWb_e <= isWb_E;
    isImmediate_e <= isImmediate_E;
    isBeq_e <= isBeq_E;
    isBgt_e <=isBgt_E;
    isUbranch_e <= isUbranch_E;
    isLd_e <= isLd_E;
    isCall_e <= isCall_E;
    alusignals_e <= alusignals_E;
    RS1_e <= RS1_E ;
    RS2_e <= RS2_E;
    RD_e <= RD_E;
    ra_e <= ra_E;
    end
end
// Output assignments to MEM stage
assign   pc_M = pc_e;
assign   alu_result_M = alu_result_e;
assign    rd2_M = rd2_e;
assign    instruction_M = instruction_e;
assign    isRet_M = isRet_e;
assign    isSt_M=isSt_e;
assign    isWb_M = isWb_e;
assign    isImmediate_M = isImmediate_e;
assign    isBeq_M = isBeq_e;
assign   isBgt_M = isBgt_e;
assign    isUbranch_M =isUbranch_e;
assign   isLd_M = isLd_e;
assign    isCall_M = isCall_e;
assign   alusignals_M =alusignals_e;
assign  RS1_M = RS1_e;
assign  RS2_M = RS2_e;
assign  RD_M = RD_e;
assign  ra_M = ra_e;
endmodule
