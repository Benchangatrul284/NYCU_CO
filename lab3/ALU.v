module ALU (
    aluSrc1,
    aluSrc2,
    ALU_operation_i,
    result,
    zero,
    overflow
);

  //I/O ports
  input [32-1:0] aluSrc1;
  input [32-1:0] aluSrc2;
  input [4-1:0] ALU_operation_i;

  output [32-1:0] result;
  output zero;
  output overflow;

  //Internal Signals
  wire [32-1:0] result;
  wire zero;
  wire overflow;
  //Main function

  /*your code here*/
  reg [32-1:0] result_reg;
  reg zero_reg;
  reg overflow_reg;

  assign result = result_reg;
  assign zero = zero_reg;
  assign overflow = overflow_reg;
  
  parameter AND_ALU = 4'b0000,
            OR_ALU = 4'b0001,
            ADD_ALU = 4'b0010,
            SUB_ALU = 4'b0110,
            SLT_ALU = 4'b0111,
            NOR_ALU = 4'b1100,
            SLLV_ALU = 4'b0011,
            SLRV_ALU = 4'b1010,
            BLT_ALU = 4'b1111,
            BNEZ_ALU = 4'b1110,
            BGEZ_ALU = 4'b1101;

  always @(*) begin
    result_reg = 0;
    overflow_reg = 0;
    zero_reg = (aluSrc1 == aluSrc2);
    case (ALU_operation_i)
    AND_ALU: 
      result_reg = aluSrc1 & aluSrc2;
    OR_ALU:
      result_reg = aluSrc1 | aluSrc2;
    ADD_ALU: begin
      result_reg = aluSrc1 + aluSrc2;
      overflow_reg = (aluSrc1[31]==0 && aluSrc2[31]==0 && result[31]==1) || (aluSrc1[31]==1 && aluSrc2[31]==1 && result[31]==0);
    end
    SUB_ALU: begin
      result_reg = aluSrc1 - aluSrc2;
      overflow_reg = (aluSrc1[31]==0 && aluSrc2[31]==1 && result[31]==1) || (aluSrc1[31]==1 && aluSrc2[31]==0 && result[31]==0);
    end
    SLT_ALU:
      result_reg = ($signed(aluSrc1) < $signed(aluSrc2))? 1:0;
    NOR_ALU:
      result_reg = ~(aluSrc1 | aluSrc2);
    // several special handling due to stupid HW
    SLLV_ALU:
      result_reg = $unsigned(aluSrc2) << $unsigned(aluSrc1);
    SLRV_ALU:
      result_reg = $unsigned(aluSrc2) >> $unsigned(aluSrc1);
    BLT_ALU:
      zero_reg = ($signed(aluSrc1) < $signed(aluSrc2))? 1:0;
    BNEZ_ALU:
      zero_reg = (aluSrc1 == 0)? 0:1;
    BGEZ_ALU:
      zero_reg = (aluSrc1 >= 0)? 1:0;
    endcase
    
    
    
    
  end

endmodule
