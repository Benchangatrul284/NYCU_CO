module Decoder (
    instr_op_i,
    funct_field_i,
    RegWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RegDst_o,
    Jump_o,
    Branch_o,
    BranchType_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o,
    JrSrc_o
);

  //I/O ports
  input [6-1:0] instr_op_i;
  input [5:0] funct_field_i; // stupid HW

  output RegWrite_o;
  output [3-1:0] ALUOp_o;
  output ALUSrc_o;
  output RegDst_o;
  output Jump_o;
  output Branch_o;
  output BranchType_o;
  output MemRead_o;
  output MemWrite_o;
  output MemtoReg_o;
  output JrSrc_o;
  //Internal Signals
  wire RegWrite_o;
  wire [3-1:0] ALUOp_o;
  wire ALUSrc_o;
  wire RegDst_o;
  wire Jump_o;
  wire Branch_o;
  wire BranchType_o;
  wire MemRead_o;
  wire MemWrite_o;
  wire MemtoReg_o;
  wire JrSrc_o;

  //Main function
  /*your code here*/
  reg RegWrite_o_reg;
  reg [3-1:0] ALUOp_o_reg;
  reg ALUSrc_o_reg;
  reg RegDst_o_reg;
  reg Jump_o_reg;
  reg Branch_o_reg;
  reg BranchType_o_reg;
  reg MemRead_o_reg;
  reg MemWrite_o_reg;
  reg MemtoReg_o_reg;
  reg JrSrc_o_reg;

  assign RegWrite_o = RegWrite_o_reg;
  assign ALUOp_o = ALUOp_o_reg;
  assign ALUSrc_o = ALUSrc_o_reg;
  assign RegDst_o = RegDst_o_reg;
  assign Jump_o = Jump_o_reg;
  assign Branch_o = Branch_o_reg;
  assign BranchType_o = BranchType_o_reg;
  assign MemRead_o = MemRead_o_reg;
  assign MemWrite_o = MemWrite_o_reg;
  assign MemtoReg_o = MemtoReg_o_reg;
  assign JrSrc_o = JrSrc_o_reg;

  parameter R_TYPE_OP = 6'b000000,
            ADDI_OP = 6'b010011,
            LW_OP = 6'b011000,
            SW_OP = 6'b101000,
            BEQ_OP = 6'b011001,
            BNE_OP = 6'b011010,
            JUMP_OP = 6'b001100,
            BLT_OP = 6'b011100,
            BNEZ_OP = 6'b011101,
            BGEZ_OP = 6'b011110,
            JAL_OP = 6'b001111;

  // special handling due to stupid HW
  parameter JR_funct = 6'b000001;

  always @(*) begin
    RegWrite_o_reg = 0; // whether to write register
    ALUOp_o_reg = 3'b000; // ADD = 3'b000, SUB = 3'b001, FUNCT = 3'b010;
    ALUSrc_o_reg = 0; // ALU source is register (0) or imm (1)
    RegDst_o_reg = 0; // write to rt (0) or rd (1)
    Jump_o_reg = 0; // whether to jump
    Branch_o_reg = 0; // whether to branch
    BranchType_o_reg = 0; // beq(0) or bne(1)
    MemRead_o_reg = 0; // whether to read memory (lw)
    MemWrite_o_reg = 0; // whether to write memory (sw)
    MemtoReg_o_reg = 0; // when WB to register: use memory (1) (lw) or ALU (0)
    JrSrc_o_reg = 0; // whether to use rs to jump
    case (instr_op_i)
      R_TYPE_OP: begin
        RegWrite_o_reg = 1; //write to register
        ALUOp_o_reg = 3'b010; // FUNCT field
        ALUSrc_o_reg = 0; // ALU source is register
        RegDst_o_reg = 1; // write to rd
        Jump_o_reg = 0; // don't jump (?)
        Branch_o_reg = 0; // don't branch
        BranchType_o_reg = 0; // don't care
        MemRead_o_reg = 0; // don't read memory (lw)
        MemWrite_o_reg = 0; // don't write memory (sw)
        MemtoReg_o_reg = 0; // use ALU (0)
      end

      ADDI_OP: begin
        RegWrite_o_reg = 1; // write to register
        ALUOp_o_reg = 3'b000; // ADD
        ALUSrc_o_reg = 1; // ALU source is imm
        RegDst_o_reg = 0; // write to rt
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 0; // don't branch
        BranchType_o_reg = 0; // don't care
        MemRead_o_reg = 0; // don't read memory (lw)
        MemWrite_o_reg = 0; // don't write memory (sw)
        MemtoReg_o_reg = 0; // use ALU (0)
      end
      LW_OP: begin
        RegWrite_o_reg = 1; //write to register
        ALUOp_o_reg = 3'b000; // ADD
        ALUSrc_o_reg = 1; // ALU source is imm
        RegDst_o_reg = 0; // write to rt (0)
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 0; // don't branch
        BranchType_o_reg = 0; // don't care
        MemRead_o_reg = 1; // read memory (lw)
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 1; // use memory (1)
      end
      SW_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b000; // ADD
        ALUSrc_o_reg = 1; // ALU source is imm
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 0; // don't branch
        BranchType_o_reg = 0; // don't care
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 1; // write memory (sw)
        MemtoReg_o_reg = 0; // don't care
      end
      BEQ_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b001; // SUB
        ALUSrc_o_reg = 0; // ALU source is rt
        RegDst_o_reg = 1; // don't care
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 1; // branch
        BranchType_o_reg = 0; // beq(0)
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
      BNE_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b001; // SUB
        ALUSrc_o_reg = 0; // ALU source is rt
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 1; // branch
        BranchType_o_reg = 1; // bne(1)
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
      BLT_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b001; // SUB (actually don't care)
        ALUSrc_o_reg = 0; // ALU source is rt (actually don't care)
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 1; // branch
        BranchType_o_reg = 0; // bne(0): do not negate
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
      BNEZ_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b001; // SUB (actually don't care)
        ALUSrc_o_reg = 0; // ALU source is rt (actually don't care)
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 1; // branch
        BranchType_o_reg = 0; // bne(0): do not negate
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
      BGEZ_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b001; // SUB (actually don't care)
        ALUSrc_o_reg = 0; // ALU source is rt (actually don't care)
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 0; // don't jump
        Branch_o_reg = 1; // branch
        BranchType_o_reg = 0; // bne(0): do not negate
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
      JUMP_OP: begin
        RegWrite_o_reg = 0; // don't write to register
        ALUOp_o_reg = 3'b000; // don't care
        ALUSrc_o_reg = 0; // don't care
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 1; // jump
        Branch_o_reg = 0; // don't branch
        BranchType_o_reg = 0; // don't care
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
      JAL_OP: begin
        RegWrite_o_reg = 1; // write to register ($31)
        ALUOp_o_reg = 3'b000; // don't care
        ALUSrc_o_reg = 0; // don't care
        RegDst_o_reg = 0; // don't care
        Jump_o_reg = 1; // jump
        Branch_o_reg = 0; // don't branch
        BranchType_o_reg = 0; // don't care
        MemRead_o_reg = 0; // don't read memory
        MemWrite_o_reg = 0; // don't write memory
        MemtoReg_o_reg = 0; // don't care
      end
    endcase
    // special handling due to this stupid HW
    if (funct_field_i == JR_funct && instr_op_i == R_TYPE_OP) begin
      Jump_o_reg = 1;
      RegWrite_o_reg = 0; //don't write to register
      JrSrc_o_reg = 1; // use rs as jump target
    end
  end
endmodule
