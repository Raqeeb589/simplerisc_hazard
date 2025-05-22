// SimpleRisc 5-Stage Pipeline Top Module
// Integrates fetch, decode, execute, memory, and writeback stages
// Implements data forwarding hazard resolution

module top_module(clk, rst);
    input clk, rst;
//==================================================================
// Inter-stage Connection Wires
//=================================================================
    // FETCH → DECODE wires
    wire isbranchtaken_E_top;
    wire [31:0] pc_branch_E_top, instruction_D_top, pc_D_top;

    // DECODE → EXECUTE wires
    wire [31:0] data_RW_top, pc_E_top, branch_target_E_top, b_E_top, a_E_top, rd2_E_top, instruction_E_top;
    wire [3:0] reg_RW_top;
    wire isRet_E_top, isSt_E_top, isWb_E_top, isImmediate_E_top, isBeq_E_top, isBgt_E_top, isUbranch_E_top, isLd_E_top, isCall_E_top;
    wire [4:0] alusignals_E_top;
    wire [3:0]RS1_E_top,RS2_E_top,RD_E_top,ra_E_top;

    // EXECUTE → MEMORY wires
    wire [31:0] pc_M_top, alu_result_M_top, rd2_M_top, instruction_M_top;
    wire isRet_M_top, isSt_M_top, isWb_M_top, isImmediate_M_top, isBeq_M_top, isBgt_M_top, isUbranch_M_top, isLd_M_top, isCall_M_top;
    wire [4:0] alusignals_M_top;
    wire [3:0]RS1_M_top,RS2_M_top,RD_M_top,ra_M_top;

    // MEMORY → WRITEBACK wires
    wire [31:0] pc_RW_top, alu_result_RW_top, instruction_RW_top, ldresult_RW_top;
    wire isRet_RW_top, isSt_RW_top, isWb_RW_top, isImmediate_RW_top, isBeq_RW_top, isBgt_RW_top, isUbranch_RW_top, isLd_RW_top, isCall_RW_top;
    wire [4:0] alusignals_RW_top;
    wire [3:0]RS1_RW_top,RS2_RW_top,RD_RW_top,ra_RW_top;

    // WRITEBACK → DECODE feedback
    wire iswb_RW_top;
    
    //datahazard --> execute 
    wire [1:0]forwardA_E_top,forwardB_E_top,forwardA_top;
    wire forward_RW_M_top;
    wire [31:0]memory_data_out_top;
    wire add_stall_top;
    wire isWb_D_hazard_top;
 //==================================================================
// Pipeline Stage Instances
//==================================================================
        // FETCH CYCLE
    fetch_cycle fc(
        .clk(clk),
        .rst(rst),
        .add_stall(add_stall_top),
        .isbranchtaken_E(isbranchtaken_E_top),
        .pc_branch_E(pc_branch_E_top),
        .instruction_D(instruction_D_top),
        .pc_D(pc_D_top)
    );

    // DECODE CYCLE
    decode_cycle dc(
        .clk(clk),
        .rst(rst),
        .add_stall(add_stall_top),
        .isbranch_taken_E(isbranchtaken_E_top),
        .pc_D(pc_D_top),
        .instruction_D(instruction_D_top),
        .reg_RW(reg_RW_top),
        .data_RW(data_RW_top),
        .iswb_RW(iswb_RW_top),
        .pc_E(pc_E_top),
        .branch_target_E(branch_target_E_top),
        .b_E(b_E_top),
        .a_E(a_E_top),
        .rd2_E(rd2_E_top),
        .instruction_E(instruction_E_top),
        .isRet_E(isRet_E_top),
        .isSt_E(isSt_E_top),
        .isWb_E(isWb_E_top),
        .isImmediate_E(isImmediate_E_top),
        .isBeq_E(isBeq_E_top),
        .isBgt_E(isBgt_E_top),
        .isUbranch_E(isUbranch_E_top),
        .isLd_E(isLd_E_top),
        .isCall_E(isCall_E_top),
        .alusignals_E(alusignals_E_top),
        .RS1_E(RS1_E_top),
        .RS2_E(RS2_E_top),
        .RD_E(RD_E_top),
        .ra_E(ra_E_top),
        .iswb_D_hazard(isWb_D_hazard_top)
    );

    // EXECUTE CYCLE
    execute_cycle ec(
        .clk(clk),
        .rst(rst),
        .add_stall(add_stall_top),
        .memory_unit_data(alu_result_RW_top),
        .memory_data_out(memory_data_out_top),
        .data_RW_E(data_RW_top),
        .data_M_E(alu_result_M_top),
        .forwardA_E(forwardA_E_top),
        .forwardB_E(forwardB_E_top),
        .forwardA(forwardA_top),
         .RS1_E(RS1_E_top),
         .RS2_E(RS2_E_top),
         .RD_E(RD_E_top),
         .ra_E(ra_E_top),
        .pc_E(pc_E_top),
        .branch_target_E(branch_target_E_top),
        .b_E(b_E_top),
        .a_E(a_E_top),
        .rd2_E(rd2_E_top),
        .instruction_E(instruction_E_top),
        .isRet_E(isRet_E_top),
        .isSt_E(isSt_E_top),
        .isWb_E(isWb_E_top),
        .isImmediate_E(isImmediate_E_top),
        .isBeq_E(isBeq_E_top),
        .isBgt_E(isBgt_E_top),
        .isUbranch_E(isUbranch_E_top),
        .isLd_E(isLd_E_top),
        .isCall_E(isCall_E_top),
        .alusignals_E(alusignals_E_top),
        .isbranchtaken_E(isbranchtaken_E_top),
        .pc_branch_E(pc_branch_E_top),
        .pc_M(pc_M_top),
        .alu_result_M(alu_result_M_top),
        .rd2_M(rd2_M_top),
        .instruction_M(instruction_M_top),
        .isRet_M(isRet_M_top),
        .isSt_M(isSt_M_top),
        .isWb_M(isWb_M_top),
        .isImmediate_M(isImmediate_M_top),
        .isBeq_M(isBeq_M_top),
        .isBgt_M(isBgt_M_top),
        .isUbranch_M(isUbranch_M_top),
        .isLd_M(isLd_M_top),
        .isCall_M(isCall_M_top),
        .alusignals_M(alusignals_M_top),
        .RS1_M(RS1_M_top),
        .RS2_M(RS2_M_top),
        .RD_M(RD_M_top),
        .ra_M(ra_M_top)
    );

    // MEMORY CYCLE
    memory_cycle mc(
        .clk(clk),
        .rst(rst),
        .forward_RW_M(forward_RW_M_top),
        .RS1_M(RS1_M_top),
        .RS2_M(RS2_M_top),
        .RD_M(RD_M_top),
        .ra_M(ra_M_top),
        .pc_M(pc_M_top),
        .alu_result_M(alu_result_M_top),
        .rd2_M(rd2_M_top),
        .instruction_M(instruction_M_top),
        .isRet_M(isRet_M_top),
        .isSt_M(isSt_M_top),
        .isWb_M(isWb_M_top),
        .isImmediate_M(isImmediate_M_top),
        .isBeq_M(isBeq_M_top),
        .isBgt_M(isBgt_M_top),
        .isUbranch_M(isUbranch_M_top),
        .isLd_M(isLd_M_top),
        .isCall_M(isCall_M_top),
        .alusignals_M(alusignals_M_top),
        .pc_RW(pc_RW_top),
        .alu_result_RW(alu_result_RW_top),
        .instruction_RW(instruction_RW_top),
        .ldresult_RW(ldresult_RW_top),
        .isRet_RW(isRet_RW_top),
        .isSt_RW(isSt_RW_top),
        .isWb_RW(isWb_RW_top),
        .isImmediate_RW(isImmediate_RW_top),
        .isBeq_RW(isBeq_RW_top),
        .isBgt_RW(isBgt_RW_top),
        .isUbranch_RW(isUbranch_RW_top),
        .isLd_RW(isLd_RW_top),
        .isCall_RW(isCall_RW_top),
        .alusignals_RW(alusignals_RW_top),
        .RS1_RW(RS1_RW_top),
        .RS2_RW(RS2_RW_top),
        .RD_RW(RD_RW_top),
        .ra_RW(ra_RW_top),
        .memory_data_out(memory_data_out_top)
        
    );

    // WRITEBACK CYCLE
    writeback_cycle wc(
        .clk(clk),
        .rst(rst),
        .RS1_RW(RS1_RW_top),
        .RS2_RW(RS2_RW_top),
        .RD_RW(RD_RW_top),
        .ra_RW(ra_RW_top),
        .pc_RW(pc_RW_top),
        .alu_result_RW(alu_result_RW_top),
        .instruction_RW(instruction_RW_top),
        .ldresult_RW(ldresult_RW_top),
        .isRet_RW(isRet_RW_top),
        .isSt_RW(isSt_RW_top),
        .isWb_RW(isWb_RW_top),
        .isImmediate_RW(isImmediate_RW_top),
        .isBeq_RW(isBeq_RW_top),
        .isBgt_RW(isBgt_RW_top),
        .isUbranch_RW(isUbranch_RW_top),
        .isLd_RW(isLd_RW_top),
        .isCall_RW(isCall_RW_top),
        .alusignals_RW(alusignals_RW_top),
        .data_RW(data_RW_top),
        .iswb_RW_D(iswb_RW_top),
        .reg_RW(reg_RW_top)
    );
    // Data Hazard Resolution Unit
 data_hazard_unit dhu(
         .rst(rst),
         .isWb_M(isWb_M_top),
         .instruction_m(instruction_M_top),
         .instruction_rw(instruction_RW_top),
         .instruction_e(instruction_E_top),
         .isWb_RW(isWb_RW_top),
         .RD_E(RD_E_top),
         .RD_M(RD_M_top),
         .RD_RW(RD_RW_top),
         .RS1_E(RS1_E_top),
         .RS2_E(RS2_E_top),
         .forwardA_E(forwardA_E_top),
         .forwardB_E(forwardB_E_top),
         .forwardA_M_E(forwardA_top),
         .forward_RW_M(forward_RW_M_top)
         );
     
  data_hazard_stall dhs(
                .clk(clk),
                .instruction_M(instruction_M_top),
                .instruction_E(instruction_E_top),
                .instruction_D(instruction_D_top),
                .isWb_E(isWb_E_top),
                .isWb_D(isWb_D_hazard_top),
                .add_stall(add_stall_top)
                );

endmodule

