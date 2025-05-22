// Data Hazard Unit for a 5-stage RISC-V pipeline
// Handles forwarding from MEM and WB stages to EX stage

module data_hazard_unit(rst,isWb_M,instruction_m,instruction_rw,instruction_e,isWb_RW,RD_E,RD_M,RD_RW,RS1_E,RS2_E,forwardA_E,forwardB_E,forwardA_M_E,forward_RW_M);
    input  rst;        // reset
    input  isWb_M;      // Write-back signal from MEM stage (1 if instruction writes to register)
    input  isWb_RW;     // Write-back signal from WB stage (1 if instruction writes to register)
    input [3:0]RD_E;
    input [31:0] instruction_m,instruction_rw,instruction_e;
    input  [3:0] RD_M;  // Destination register in MEM stage (4-bit register address)
    input  [3:0] RD_RW; // Destination register in WB stage (4-bit register address)
    input  [3:0] RS1_E; // Source register 1 in EX stage (4-bit register address)
    input  [3:0] RS2_E; // Source register 2 in EX stage (4-bit register address)
    output [1:0] forwardA_E; // Forwarding control for operand A (EX stage)
    output [1:0] forwardB_E ; // Forwarding control for operand B (EX stage)
    output [1:0]forwardA_M_E;
    output forward_RW_M ;

// Forwarding logic for operand A (RS1)
assign forwardA_E = (rst == 1'b1) ? 2'b00 : //RD_M
                       ((isWb_M == 1'b1) /*&(instruction_m[25:22] !=4'b0)*/ & (instruction_m[25:22] == instruction_e[21:18]) & (instruction_m != 5'b01110)) ? 2'b10 ://Forward from MEM stage
                       ((isWb_RW == 1'b1) /*&(instruction_m[25:22] !=4'b0)*/ & (instruction_rw[25:22] == instruction_e[21:18]) )? 2'b01 : //Forward from WB stage
                        2'b00;
// Forwarding logic for operand B (RS2                                RD_M == RS2_E
assign forwardB_E = (rst == 1'b1) ? 2'b00 : 
                       ((isWb_M == 1'b1)  /*&(instruction_rw[25:22]!=4'b0) */& (instruction_m[25:22] == instruction_e[17:14]) & (instruction_e[31:27] != 5'b00101)) ? 2'b10 : // Forward from MEM stage
                       ((isWb_RW == 1'b1) /*&(instruction_rw[25:22]!=4'b0)&*/ & (instruction_rw[25:22] == instruction_e[17:14])) ? 2'b01 : //Forward from WB stage if
                        2'b00;                                    //RD_RW == RS2_E
                     
assign forwardA_M_E = (rst == 1'b1) ? 2'b00 : 
                  ((isWb_M == 1'b1) &/*(RD_M !=4'b0) & */(instruction_m[25:22] == instruction_e[25:22]) ) ? 2'b10 : 
                   (instruction_rw[25:22] == instruction_e[25:22]) ?  2'b01 : 2'b00;
                   
assign forward_RW_M = (rst == 1'b1) ? 1'b0 :
                     ((isWb_RW == 1'b1) /*&(RD_M !=4'b0)*/& (instruction_rw[25:22] == instruction_m[25:22]) &&(instruction_m[31:27] ==5'b01111) &&(instruction_rw[31:27] ==5'b01110)) ? 1'b1: 1'b0; 
endmodule

