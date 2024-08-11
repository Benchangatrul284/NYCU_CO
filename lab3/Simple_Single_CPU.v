`include "Program_Counter.v"
`include "Adder.v"
`include "Instr_Memory.v"
`include "Mux2to1.v"
`include "Mux3to1.v"
`include "Reg_File.v"
`include "Decoder.v"
`include "ALU_Ctrl.v"
`include "Sign_Extend.v"
`include "Zero_Filled.v"
`include "ALU.v"
`include "Shifter.v"
`include "Data_Memory.v"

module Simple_Single_CPU (
    clk_i,
    rst_n
);

  //I/O port
  input clk_i;
  input rst_n;

  //Internal Signles

  // PC
  wire [31:0] pc_in;
  wire [31:0] pc_out;
  wire [31:0] pc_add4;
  wire [31:0] branch_addr;
  wire [31:0] PC_NJ;

  // instruction
  wire [31:0] instruction;
  // branch
  wire do_branch;

  // control signal
  wire Jump;
  wire [2:0] ALUOp;
  wire ALUSrc;
  wire Branch;
  wire BranchType;
  wire MemWrite;
  wire MemRead;
  wire MemtoReg;
  wire RegWrite;
  wire RegDst;
  
  wire PCSrc;
  wire JrSrc;
  // register
  wire [4:0] Write_Register_Temp;
  wire [4:0] Write_Register;
  wire [31:0] Write_Data_Temp;
  wire [31:0] Write_Data;
  wire [31:0] Read_Data1;
  wire [31:0] Read_Data2;
  wire [31:0] pc_jump;
  // ALU
  wire [3:0] ALU_operation;
  wire [1:0] FURslt;
  wire leftRight;

  wire [31:0] sign_extended;
  wire [31:0] zero_fill;
  wire [31:0] ALU_Operand2;
  wire ALU_zero;
  wire [31:0] ALU_Result;
  wire ALU_Overflow;

  // shifter 
  wire [31:0] Shifter_Result;


  wire [31:0] Final_Result;

  // memory
  wire [31:0] MEM_Data;
  //modules 
  Program_Counter PC (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .pc_in_i(pc_in),
      .pc_out_o(pc_out)
  );
  
  // add PC + 4
  Adder Adder1 (
      .src1_i(pc_out),
      .src2_i(32'd4),
      .sum_o (pc_add4)
  );

  // calculate branching
  Adder Adder2 (
      .src1_i(pc_add4),
      .src2_i(sign_extended << 2),
      .sum_o (branch_addr)
  );

  // use branch addr or pc_add4
  Mux2to1 #(
      .size(32)
  ) Mux_branch (
      .data0_i (pc_add4),
      .data1_i (branch_addr),
      .select_i(PCSrc),
      .data_o  (PC_NJ)
  );

  // branch type selection
  Mux2to1 #(
      .size(1)
  ) Mux_branch_type (
      .data0_i (ALU_zero),
      .data1_i (!ALU_zero),
      .select_i(BranchType),
      .data_o  (do_branch)
  );

  assign PCSrc = do_branch & Branch;

  Mux2to1 #(
      .size(32)
  ) Mux_jump1 (
      .data0_i ({pc_add4[31:28],instruction[25:0], 2'b00}),
      .data1_i (Read_Data1),
      .select_i(JrSrc),
      .data_o  (pc_jump)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_jump2 (
      .data0_i (PC_NJ),
      .data1_i (pc_jump),
      .select_i(Jump),
      .data_o  (pc_in)
  );

 

  Instr_Memory IM (
      .pc_addr_i(pc_out),
      .instr_o  (instruction)
  );

  // decide which register to write before considering jump instruction
  Mux2to1 #(
      .size(5)
  ) Mux_Write_Reg1 (
      .data0_i (instruction[20:16]),
      .data1_i (instruction[15:11]),
      .select_i(RegDst),
      .data_o  (Write_Register_Temp)
  );

    // decide which register to write considering jump instruction
  Mux2to1 #(
      .size(5)
  ) Mux_Write_Reg2 (
      .data0_i (Write_Register_Temp),
      .data1_i (5'b11111),
      .select_i(Jump),
      .data_o  (Write_Register)
  );

  Reg_File RF (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .RSaddr_i(instruction[25:21]),
      .RTaddr_i(instruction[20:16]),
      .RDaddr_i(Write_Register),
      .RDdata_i(Write_Data),
      .RegWrite_i(RegWrite),
      .RSdata_o(Read_Data1),
      .RTdata_o(Read_Data2)
  );

  Decoder Decoder (
      .instr_op_i(instruction[31:26]),
      .funct_field_i(instruction[5:0]),
      .RegWrite_o(RegWrite),
      .ALUOp_o(ALUOp),
      .ALUSrc_o(ALUSrc),
      .RegDst_o(RegDst),
      .Jump_o(Jump),
      .Branch_o(Branch),
      .BranchType_o(BranchType),
      .MemRead_o(MemRead),
      .MemWrite_o(MemWrite),
      .MemtoReg_o(MemtoReg),
      .JrSrc_o(JrSrc)
  );

  ALU_Ctrl AC (
      .instr_op_i(instruction[31:26]),
      .funct_i(instruction[5:0]),
      .ALUOp_i(ALUOp),
      .ALU_operation_o(ALU_operation),
      .FURslt_o(FURslt),
      .leftRight_o(leftRight)
  );

  Sign_Extend SE (
      .data_i(instruction[15:0]),
      .data_o(sign_extended)
  );

  Zero_Filled ZF (
      .data_i(instruction[15:0]),
      .data_o(zero_fill)
  );

  // select the source of ALU
  Mux2to1 #(
      .size(32)
  ) ALU_src2Src (
      .data0_i (Read_Data2),
      .data1_i (sign_extended),
      .select_i(ALUSrc),
      .data_o  (ALU_Operand2)
  );

  // ALU
  ALU ALU (
      .aluSrc1(Read_Data1),
      .aluSrc2(ALU_Operand2),
      .ALU_operation_i(ALU_operation),
      .result(ALU_Result),
      .zero(ALU_zero),
      .overflow(ALU_Overflow)
  );

  // shifter under the ALU
  Shifter shifter (
      .result(Shifter_Result),
      .leftRight(leftRight),
      .shamt(instruction[10:6]),
      .sftSrc(ALU_Operand2)
  );

  // select which to write
  Mux3to1 #(
      .size(32)
  ) RDdata_Source (
      .data0_i (ALU_Result),
      .data1_i (Shifter_Result),
      .data2_i (zero_fill),
      .select_i(FURslt),
      .data_o  (Final_Result)
  );

  // data memory
  Data_Memory DM (
      .clk_i(clk_i),
      .addr_i(Final_Result),
      .data_i(Read_Data2),
      .MemRead_i(MemRead),
      .MemWrite_i(MemWrite),
      .data_o(MEM_Data)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_Write1 (
      .data0_i(Final_Result),
      .data1_i(MEM_Data),
      .select_i(MemtoReg),
      .data_o(Write_Data_Temp)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_Write2 (
      .data0_i (Write_Data_Temp),
      .data1_i (pc_add4),
      .select_i(Jump),
      .data_o  (Write_Data)
  );

endmodule



