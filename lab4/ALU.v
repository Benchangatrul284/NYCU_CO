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
  reg [32-1:0] result;
  reg zero;
  reg overflow;

  //Main function
  /*your code here*/
  parameter AND_ALU = 4'b0000,
            OR_ALU = 4'b0001,
            ADD_ALU = 4'b0010,
            SUB_ALU = 4'b0110,
            SLT_ALU = 4'b0111,
            NOR_ALU = 4'b1100;

  always @(*) begin
    result = 0;
    overflow = 0;
    zero = (aluSrc1 == aluSrc2);
    case (ALU_operation_i)
    AND_ALU: 
      result = aluSrc1 & aluSrc2;
    OR_ALU:
      result = aluSrc1 | aluSrc2;
    ADD_ALU: begin
      result = aluSrc1 + aluSrc2;
      overflow = (aluSrc1[31]==0 && aluSrc2[31]==0 && result[31]==1) || (aluSrc1[31]==1 && aluSrc2[31]==1 && result[31]==0);
    end
    SUB_ALU: begin
      result = aluSrc1 - aluSrc2;
      overflow= (aluSrc1[31]==0 && aluSrc2[31]==1 && result[31]==1) || (aluSrc1[31]==1 && aluSrc2[31]==0 && result[31]==0);
    end
    SLT_ALU:
      result = ($signed(aluSrc1) < $signed(aluSrc2))? 1:0;
    NOR_ALU:
      result = ~(aluSrc1 | aluSrc2);
    endcase
  end
endmodule
