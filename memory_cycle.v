// Pipeline Memory Stage Module
// Handles data memory operations and pipeline propagation

module memory_cycle(clk,rst,forward_RW_M,RS1_M,RS2_M,RD_M,ra_M,pc_M,alu_result_M,rd2_M,instruction_M,isRet_M,isSt_M,isWb_M,isImmediate_M,isBeq_M,isBgt_M,isUbranch_M,isLd_M,isCall_M,alusignals_M,pc_RW,alu_result_RW,instruction_RW,ldresult_RW,isRet_RW,isSt_RW,isWb_RW,isImmediate_RW,isBeq_RW,isBgt_RW,isUbranch_RW,isLd_RW,isCall_RW,alusignals_RW,RS1_RW,RS2_RW,RD_RW,ra_RW,memory_data_out);
input clk,rst;
input forward_RW_M;
input [31:0]pc_M,alu_result_M,rd2_M,instruction_M;
input  isRet_M,isSt_M,isWb_M,isImmediate_M,isBeq_M,isBgt_M,isUbranch_M,isLd_M,isCall_M;
input  [4:0]alusignals_M;
input [3:0]RS1_M,RS2_M,RD_M,ra_M;
output  [31:0]pc_RW,alu_result_RW,instruction_RW,ldresult_RW;
output  isRet_RW,isSt_RW,isWb_RW,isImmediate_RW,isBeq_RW,isBgt_RW,isUbranch_RW,isLd_RW,isCall_RW;
output  [4:0]alusignals_RW;
output [3:0]RS1_RW,RS2_RW,RD_RW,ra_RW;
output [31:0]memory_data_out;

// Memory interface signals
wire [31:0]data_out_top;
wire [31:0]data_in_top;
// MEM-WB pipeline registers
reg  [31:0]pc_m,alu_result_m,instruction_m,ldresult_m;
reg  isRet_m,isSt_m,isWb_m,isImmediate_m,isBeq_m,isBgt_m,isUbranch_m,isLd_m,isCall_m;
reg  [4:0]alusignals_m;
reg  [3:0]RS1_m,RS2_m,RD_m,ra_m;
// MEM-WB pipeline registers
mux2x1 m60(.x(rd2_M),.z(ldresult_RW),.sel(forward_RW_M),.rst(rst),.y(data_in_top));
memory_unit mu(.clk(clk),.isLd(isLd_M),.isSt(isSt_M),.address(alu_result_M),.data_in(data_in_top),.data_out(data_out_top));
// Pipeline Register Update
assign memory_data_out = data_out_top; 
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
    pc_m <=32'b0;
    alu_result_m <= 32'b0;
    ldresult_m <= 32'b0; 
    instruction_m <= 32'b0;
    isRet_m <= 1'b0;
    isSt_m <= 1'b0;
    isWb_m <= 1'b0;
    isImmediate_m <= 1'b0;
    isBeq_m <= 1'b0;
    isBgt_m <= 1'b0;
    isUbranch_m <=1'b0;
    isLd_m <= 1'b0;
    isCall_m <= 1'b0;
    alusignals_m <=5'b0;
    RS1_m <= 4'bx;
    RS2_m <= 4'bx;
    RD_m <= 4'bx;
    ra_m <= 4'bx;
    end
    else
    begin
    pc_m <=pc_M;
    alu_result_m <= alu_result_M ;
    ldresult_m <= data_out_top;
    instruction_m <= instruction_M;
    isRet_m <= isRet_M;
    isSt_m <= isSt_M;
    isWb_m <= isWb_M;
    isImmediate_m <= isImmediate_M;
    isBeq_m <= isBeq_M;
    isBgt_m <=isBgt_M;
    isUbranch_m <= isUbranch_M;
    isLd_m <= isLd_M;
    isCall_m <= isCall_M;
    alusignals_m <= alusignals_M;
    RS1_m <= RS1_M ;
    RS2_m <= RS2_M;
    RD_m <= RD_M;
    ra_m <= ra_M;
    end
end
// Output assignments to Write-Back stage
assign   pc_RW = pc_m;
assign   alu_result_RW = alu_result_m;
assign    ldresult_RW = ldresult_m;
assign    instruction_RW = instruction_m;
assign    isRet_RW = isRet_m;
assign    isSt_RW=isSt_m;
assign    isWb_RW = isWb_m;
assign    isImmediate_RW = isImmediate_m;
assign    isBeq_RW = isBeq_m;
assign   isBgt_RW = isBgt_m;
assign    isUbranch_RW =isUbranch_m;
assign   isLd_RW = isLd_m;
assign    isCall_RW = isCall_m;
assign   alusignals_RW =alusignals_m;
assign RS1_RW = RS1_m;
assign RS2_RW = RS2_m;
assign RD_RW = RD_m;
assign ra_RW = ra_m;
endmodule
