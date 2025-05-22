//-------------------------
// Data Memory Unit
//-------------------------
// 16-word data memory. Supports load and store
module memory_unit(clk,isLd,isSt,address,data_in,data_out);
input clk,isLd,isSt;
input [31:0]address,data_in;
output [31:0]data_out;

reg [31:0] data_registers[25:0];
/*initial
begin
    // Initialize data memory
    data_registers[0] = 0;
    data_registers[1] = 8;
    data_registers[2] = 4;
    data_registers[3] = 6;
    data_registers[4] = 2;
    data_registers[5] = 3;
    data_registers[6] = 9;
    data_registers[7] = 10;
    data_registers[8] = 22;
    data_registers[9] = 7;
    data_registers[10] =8;
    data_registers[11] = 11;
    data_registers[12] = 13;
    data_registers[13] = 15;
    data_registers[14] = 20;
    data_registers[15] = 1;
    data_registers[16] = 10;
    data_registers[17] = 22;
    data_registers[18] = 7;
    data_registers[19] =8;
    data_registers[20] = 11;
    data_registers[21] = 13;
    data_registers[22] = 15;
    data_registers[23] = 20;
    data_registers[24] = 1;
    data_registers[25] = 1;
    
end*/

always @(*)
begin
    
    if(isSt)
    begin
        data_registers[address] <= data_in; // Store, Write to data memory on clock edge if enabled  
    end
end

assign data_out = (isLd)? data_registers[address] : 32'h00000000;  // load ,Read from data memory if enabled
endmodule
