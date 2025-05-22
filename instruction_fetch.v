// Pipeline Fetch Stage Module
// Handles instruction fetching and branch redirection
module fetch_cycle(clk,rst,add_stall,isbranchtaken_E,pc_branch_E,instruction_D,pc_D);
input clk,rst;
input isbranchtaken_E;
input add_stall;
input [31:0]pc_branch_E;
output  [31:0]instruction_D,pc_D;
// Internal signals
wire [31:0]pcnext_top,pc_top,instruction_top,pc_plus4_top;
wire [3:0]RS1_top,RS2_top,RD_top,ra_top;

// Pipeline registers
reg [31:0]instruction_f,pc_f;

// PC Selection MUX: Choose between sequential flow and branch target
mux2x1 m1(.x(pc_plus4_top),.z(pc_branch_E),.sel(isbranchtaken_E),.rst(rst),.y(pcnext_top) );
// Program Counter Register
program_counter pc(.clk(clk),.rst(rst),.add_stall(add_stall),.pcnext(pcnext_top),.pc(pc_top));
// PC Increment Unit
pc_plus4 pcplus4(.pc(pc_top),.pcplus4(pc_plus4_top));
// Instruction Memory Interface
instruction_memory im(.address(pc_top),.instruction(instruction_top));
// Pipeline Register Update
always @(posedge clk)
begin
    if(rst | isbranchtaken_E)
    begin
    pc_f <= 32'b0;
    instruction_f <= 32'b01101000000000000000000000000000;
    end
    else
    begin
    pc_f <= pc_top;
    instruction_f <= instruction_top;  
    end
end

// Output assignments with asynchronous reset override
assign instruction_D = (rst == 1'b1) ? 32'b01101000000000000000000000000000 : instruction_f;
assign pc_D = (rst == 1'b1) ? 32'h00000000 : pc_f;
endmodule
