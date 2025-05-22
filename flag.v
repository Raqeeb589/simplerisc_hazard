
//-------------------------
// Flag Extraction Module
//-------------------------
// Extracts GT and EQ flags if instruction is CMP.
module flag(isCMP,flags_in,GT_flag,EQ_flag);
input [1:0]flags_in;
input [4:0]isCMP;
output reg GT_flag;
output reg EQ_flag;

always @(*)
begin
    if(isCMP == 5'b00101)
    begin
         GT_flag <= flags_in[1] ;
         EQ_flag <= flags_in[0];
    end
    else
    begin
        GT_flag <= GT_flag ; // Else retain previous values
        EQ_flag <= EQ_flag;   
    end
    
end
 endmodule 