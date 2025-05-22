//-------------------------
// Register File
//-------------------------
// 16-register file, 32-bit each.
// Supports two reads and one write per cycle
module register__file(clk,rs1,rs2,rd_ra,isWb,data,rd1,rd2);
input clk,isWb;
input [3:0]rs1,rs2,rd_ra;
input [31:0]data;
output  [31:0]rd1,rd2;

reg [31:0]register[15:0];  
        
initial
begin
// Initialize registers
    register[0]=3;
    register[1]=2;
    register[2]=5;
    register[3]=7;
    register[4]=3;
    register[5]=4;
    register[6]=8;
    register[7]=10;
    register[8]=10;
    register[9]=3;
    register[10]=1;
    register[11]=1;
    register[12]=35;
    register[13]=42;
    register[14]=11;
    register[15]=12;
end

assign rd1 = register[rs1];
assign rd2 = register[rs2];

always @(*)
begin
    
     if(isWb )
        begin
            register[rd_ra] <= data; //writing to register file if enabled 
        end
end
endmodule