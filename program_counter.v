///////////////////////////////////////////////////////////////////////////////
// Program Counter Module
///////////////////////////////////////////////////////////////////////////////
// Holds the current program counter value.
// Updates to pcnext on clock edge, resets to 0 on rst
module program_counter(clk,add_stall,rst,pcnext,pc);
input [31:0]pcnext;
input clk,rst,add_stall;
output reg [31:0]pc;

always@(posedge clk )
begin
    if(rst)
        begin
            pc <= 32'h00000000; 
        end
    else if(!add_stall)
        begin
            pc <= pcnext;   
        end
    else if(add_stall)
        begin
            pc <= pc - 4 ;
        end
        
end

    
endmodule
