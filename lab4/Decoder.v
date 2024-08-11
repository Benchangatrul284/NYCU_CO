module Decoder (
    instr_op_i,
    RegWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RegDst_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
);

  //I/O ports
  input [6-1:0] instr_op_i;

  output RegWrite_o;
  output [2-1:0] ALUOp_o;
  output ALUSrc_o;
  output RegDst_o;
  output MemRead_o;
  output MemWrite_o;
  output MemtoReg_o;

  //Internal Signals
  reg RegWrite_o;
  reg [2-1:0] ALUOp_o;
  reg ALUSrc_o;
  reg RegDst_o;
  reg MemRead_o;
  reg MemWrite_o;
  reg MemtoReg_o;

  //Main function
  /*your code here*/
  
  // decoding the instruction (6 bits)
  parameter R_TYPE_OP = 6'b000000,
            ADDI_OP = 6'b010011,
            LW_OP = 6'b011000,
            SW_OP = 6'b101000;

  always @(*) begin
    RegWrite_o = 0; // whether to write register
    ALUOp_o = 2'b00; // ADD = 2'b00, SUB = 2'b01, FUNCT = 2'b10;
    ALUSrc_o = 0; // ALU source is register (0) or imm (1)
    RegDst_o = 0; // write to rt (0) or rd (1)
    MemRead_o = 0; // whether to read memory (lw)
    MemWrite_o = 0; // whether to write memory (sw)
    MemtoReg_o = 0; // when WB to register: use memory (1) (lw) or ALU (0)

    case (instr_op_i)
      R_TYPE_OP: begin
        RegWrite_o = 1; //write to register
        ALUOp_o = 2'b10; // FUNCT field
        ALUSrc_o = 0; // ALU source is register
        RegDst_o = 1; // write to rd
        MemRead_o = 0; // don't read memory (lw)
        MemWrite_o = 0; // don't write memory (sw)
        MemtoReg_o = 0; // use ALU (0)
      end

      ADDI_OP: begin
        RegWrite_o = 1; // write to register
        ALUOp_o = 2'b00; // ADD
        ALUSrc_o = 1; // ALU source is imm
        RegDst_o = 0; // write to rt
        MemRead_o = 0; // don't read memory (lw)
        MemWrite_o = 0; // don't write memory (sw)
        MemtoReg_o = 0; // use ALU (0)
      end
      LW_OP: begin
        RegWrite_o = 1; //write to register
        ALUOp_o = 2'b00; // ADD
        ALUSrc_o = 1; // ALU source is imm
        RegDst_o = 0; // write to rt (0)
        MemRead_o = 1; // read memory (lw)
        MemWrite_o = 0; // don't write memory
        MemtoReg_o = 1; // use memory (1)
      end
      SW_OP: begin
        RegWrite_o = 0; // don't write to register
        ALUOp_o = 2'b00; // ADD
        ALUSrc_o = 1; // ALU source is imm
        RegDst_o = 0; // don't care
        MemRead_o = 0; // don't read memory
        MemWrite_o = 1; // write memory (sw)
        MemtoReg_o = 0; // don't care
      end
    endcase
  end
endmodule
