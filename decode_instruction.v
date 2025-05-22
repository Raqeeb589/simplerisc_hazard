// Pipeline Decode Stage Module
// Handles instruction decoding, register fetching, and control signal generation
module decode_cycle(clk,rst,iswb_D_hazard,add_stall,isbranch_taken_E,pc_D,instruction_D,reg_RW,data_RW,iswb_RW,pc_E,
branch_target_E,b_E,a_E,rd2_E,instruction_E,isRet_E,isSt_E,isWb_E,isImmediate_E,isBeq_E,isBgt_E,isUbranch_E,isLd_E,isCall_E,alusignals_E,RS1_E,RS2_E,RD_E,ra_E);
input clk,rst;
input add_stall;
input isbranch_taken_E;
input [31:0]pc_D,instruction_D;
input [3:0]reg_RW;
input [31:0]data_RW;
input iswb_RW;
output  [31:0]pc_E,branch_target_E,b_E,a_E,rd2_E,instruction_E;
output  isRet_E,isSt_E,isWb_E,isImmediate_E,isBeq_E,isBgt_E,isUbranch_E,isLd_E,isCall_E;
output  [4:0]alusignals_E;
output [3:0]RS1_E,RS2_E,RD_E,ra_E;
output iswb_D_hazard;

 // Internal wires for decode logic
wire [3:0]RS1_top,RS2_top,RD_top,ra_top,rd_rs2_top,ra_rs1_top;
wire isbranchtaken_top,isRet_top,isSt_top,isWb_top,isImmediate_top,isBeq_top,isBgt_top,isUbranch_top,isLd_top,isCall_top;
wire [31:0]rd1_top,rd2_top,immx_top,branch_target_top,b_top;
wire [4:0]alusignals_top;

// Pipeline registers (D-E buffer)
reg [31:0]pc_d,branch_target_d,b_d,a_d,rd2_d,instruction_d;
reg  isRet_d,isSt_d,isWb_d,isImmediate_d,isBeq_d,isBgt_d,isUbranch_d,isLd_d,isCall_d;
reg  [4:0]alusignals_d;
reg [3:0]RS1_d,RS2_d,RD_d,ra_d;

// Instruction Decoding
instruction_decode id(.clk(clk),.rst(rst),.instruction(instruction_D),.RS1(RS1_top),.RS2(RS2_top),.RD(RD_top),.ra(ra_top));
// Store Instruction MUX: Select between RS2/RD for store operations
mux2x1_4bit m2(.x(RS2_top),.z(RD_top),.sel(isSt_top),.rst(rst),.y(rd_rs2_top));
// Return Address MUX: Select between RS1/ra for return instructions
mux2x1_4bit m3(.x(RS1_top),.z(ra_top),.sel(isRet_top),.rst(rst),.y(ra_rs1_top));
// Register File Access
register__file rf(.clk(clk),.rs1(ra_rs1_top),.rs2(rd_rs2_top),.rd_ra(reg_RW),.isWb(iswb_RW),.data(data_RW),.rd1(rd1_top),.rd2(rd2_top));
// Immediate Operand MUX
mux2x1 m4(.x(rd2_top),.z(immx_top),.sel(isImmediate_top),.rst(rst),.y(b_top));
// Immediate and Branch Target Generation
immediate_generator img(.pc(pc_D),.instruction(instruction_D),.immx(immx_top),.branch_target(branch_target_top));
// Control Unit
control_unit cu(.instruction(instruction_D),.isRet(isRet_top),.isSt(isSt_top),.isWb(isWb_top),.isImmediate(isImmediate_top),.alusignals(alusignals_top),.isBeq(isBeq_top),.isBgt(isBgt_top),.isUbranch(isUbranch_top),.isLd(isLd_top),.isCall(isCall_top));

assign iswb_D_hazard=isWb_top;
// Pipeline Register Update
always @(posedge clk )
begin
    if(rst | isbranch_taken_E | add_stall)
    begin
    pc_d <= 32'b0;
    branch_target_d <= 32'b0;
    b_d <= 32'b0;
    a_d <= 32'b0;
    rd2_d <= 32'b0;
    instruction_d <= 32'b01101000000000000000000000000000;
    isRet_d <= 1'b0;
    isSt_d <= 1'b0;
    isWb_d <= 1'b0;
    isImmediate_d <= 1'b0;
    isBeq_d <= 1'b0;
    isBgt_d <= 1'b0;
    isUbranch_d <=1'b0;
    isLd_d <= 1'b0;
    isCall_d <= 1'b0;
    alusignals_d <=5'b0;
    RS1_d <= 4'bx;
    RS2_d <= 4'bx;
    RD_d  <=4'bx;
    ra_d <=4'bx;
    end
    else
    begin
    pc_d <= pc_D;
    branch_target_d <= branch_target_top ;
    b_d <= b_top;
    a_d <= rd1_top;
    rd2_d <= rd2_top;
    instruction_d <= instruction_D;
    isRet_d <= isRet_top;
    isSt_d <=isSt_top;
    isWb_d <= isWb_top;
    isImmediate_d <= isImmediate_top;
    isBeq_d <= isBeq_top;
    isBgt_d <= isBgt_top;
    isUbranch_d <=isUbranch_top;
    isLd_d <= isLd_top;
    isCall_d <= isCall_top;
    alusignals_d <=alusignals_top;
    RS1_d <= RS1_top;
    RS2_d <= RS2_top;
    RD_d  <=RD_top;
    ra_d <=ra_top;  
    end
end
// Output assignments for Execute stage
 assign   pc_E = pc_d;
 assign    branch_target_E = branch_target_d ;
  assign   b_E = b_d;
  assign   a_E = a_d;
 assign    rd2_E = rd2_d;
 assign    instruction_E = instruction_d;
 assign    isRet_E = isRet_d;
 assign    isSt_E =isSt_d;
 assign    isWb_E = isWb_d;
 assign    isImmediate_E = isImmediate_d;
 assign    isBeq_E = isBeq_d;
  assign   isBgt_E = isBgt_d;
 assign    isUbranch_E =isUbranch_d;
  assign   isLd_E = isLd_d;
 assign    isCall_E = isCall_d;
  assign   alusignals_E =alusignals_d;
  assign    RS1_E = RS1_d;
  assign RS2_E = RS2_d;
  assign RD_E = RD_d;
  assign ra_E = ra_d;
endmodule
