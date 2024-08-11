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
`include "Pipe_Reg.v"

module Pipeline_CPU (
    clk_i,
    rst_n
);

  //I/O port
  input clk_i;
  input rst_n;
  
  // =================IF=====================
  wire [31:0] pc_in_if;
  wire [31:0] pc_out_if;
  wire [31:0] pc_add4_if;
  wire [31:0] instruction_if;
  
  Program_Counter PC (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .pc_in_i(pc_in_if),
      .pc_out_o(pc_out_if)
  );

  Adder Adder1 (
      .src1_i(pc_out_if),
      .src2_i(32'd4),
      .sum_o (pc_add4_if)
  );
  
  Instr_Memory IM (
      .pc_addr_i(pc_out_if),
      .instr_o  (instruction_if)
  );

  assign pc_in_if = pc_add4_if;

  //===============IF/ID================
  // 32 bits
  wire [31:0] instruction_ifid;

  Pipe_Reg #(
    .size(32)
  ) IF_ID (
    .clk_i(clk_i),
    .rst_n(rst_n),
    .data_i(instruction_if),
    .data_o(instruction_ifid)
  );

  //===============ID================
  // special wb signal
  wire [4:0] Write_Register_memwb; // 5 bit for register address
  wire RegWrite_memwb; // whether to write register
  wire MemtoReg_memwb; // what to write to register
  // id signal
  wire RegWrite_id;
  wire [1:0] ALUOp_id;
  wire ALUSrc_id;
  wire RegDst_id;
  wire MemRead_id;
  wire MemWrite_id;
  wire MemtoReg_id;
  wire [31:0] pc_add4_id;

  wire [31:0] Read_Data1_id;
  wire [31:0] Read_Data2_id;
  wire [31:0] sign_extended_id;
  
  wire [9:0] instruction_id;
  assign instruction_id = instruction_ifid[20:11];
  wire [4:0] shamt_id = instruction_ifid[10:6];

  Reg_File RF (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .RSaddr_i(instruction_ifid[25:21]),
      .RTaddr_i(instruction_ifid[20:16]),
      .RDaddr_i(Write_Register_memwb),
      .RDdata_i(Write_Data_wb),
      .RegWrite_i(RegWrite_memwb),
      .RSdata_o(Read_Data1_id),
      .RTdata_o(Read_Data2_id)
  );

  Sign_Extend SE (
      .data_i(instruction_ifid[15:0]),
      .data_o(sign_extended_id)
  );

  Decoder Decoder (
      .instr_op_i(instruction_ifid[31:26]),
      .RegWrite_o(RegWrite_id),
      .ALUOp_o(ALUOp_id),
      .ALUSrc_o(ALUSrc_id),
      .RegDst_o(RegDst_id),
      .MemRead_o(MemRead_id),
      .MemWrite_o(MemWrite_id),
      .MemtoReg_o(MemtoReg_id)
  );
  
  //===============ID/EX================
  wire RegWrite_idex;
  wire [1:0] ALUOp_idex;
  wire ALUSrc_idex;
  wire RegDst_idex;
  wire MemRead_idex;
  wire MemWrite_idex;
  wire MemtoReg_idex;
  wire [31:0] Read_Data1_idex;
  wire [31:0] Read_Data2_idex;
  wire [31:0] sign_extended_idex;
  
  wire [9:0] instruction_idex;
  wire [4:0] shamt_idex;
  // 8 + 64 + 32 + 10 + 5
  Pipe_Reg #(
    .size(119)
  ) ID_EX (
    .clk_i(clk_i),
    .rst_n(rst_n),
    .data_i({RegWrite_id,ALUOp_id,ALUSrc_id,RegDst_id,MemRead_id,MemWrite_id,MemtoReg_id,Read_Data1_id,Read_Data2_id,sign_extended_id,instruction_id,shamt_id}),
    .data_o({RegWrite_idex,ALUOp_idex,ALUSrc_idex,RegDst_idex,MemRead_idex,MemWrite_idex,MemtoReg_idex,Read_Data1_idex,Read_Data2_idex,sign_extended_idex,instruction_idex,shamt_idex})
  );
  //=======================EX====================
  wire [31:0] Read_Data2_ex; // intermediate value
  wire [4:0] Write_Register_ex; // 5 bit write register address
  wire [3:0] ALU_operation_ex; // intermediate value 4 bit alu operation
  wire [31:0] ALU_result_ex;// intermediate value, ALU output

  Mux2to1 #(
      .size(32)
  ) Mux_ALUSrc (
      .data0_i (Read_Data2_idex),
      .data1_i (sign_extended_idex),
      .select_i(ALUSrc_idex),
      .data_o  (Read_Data2_ex)
  );
  
  ALU_Ctrl AC (
      .funct_i(sign_extended_idex[5:0]),
      .ALUOp_i(ALUOp_idex),
      .ALU_operation_o(ALU_operation_ex),
      .FURslt_o(),
      .leftRight_o()
  );

  ALU ALU (
      .aluSrc1(Read_Data1_idex),
      .aluSrc2(Read_Data2_ex),
      .ALU_operation_i(ALU_operation_ex),
      .result(ALU_result_ex),
      .zero(),
      .overflow()
  );

  
  Mux2to1 #(
      .size(5)
  ) Mux_RegDst (
      .data0_i (instruction_idex[9:5]),
      .data1_i (instruction_idex[4:0]),
      .select_i(RegDst_idex),
      .data_o  (Write_Register_ex)
  );
  
  //=======================EX/MEM====================
  wire RegWrite_exmem; // WB
  wire MemtoReg_exmem; // WB
  wire MemRead_exmem; // MEM
  wire MemWrite_exmem;
  

  wire [31:0] ALU_result_exmem;
  wire [31:0] Read_Data2_exmem;
  wire [4:0] Write_Register_exmem;
  
  // 5 + 32 + 32 + 5
  Pipe_Reg #(
    .size(74)
  ) EX_MEM (
    .clk_i(clk_i),
    .rst_n(rst_n),
    .data_i({RegWrite_idex,MemtoReg_idex,MemRead_idex,MemWrite_idex,MemtoReg_idex,ALU_result_ex,Read_Data2_idex,Write_Register_ex}),
    .data_o({RegWrite_exmem,MemtoReg_exmem,MemRead_exmem,MemWrite_exmem,MemtoReg_exmem,ALU_result_exmem,Read_Data2_exmem,Write_Register_exmem})
  );

  //==========================MEM=======================
  wire [31:0] MEM_Data_mem; // data memory

  Data_Memory DM (
      .clk_i(clk_i),
      .addr_i(ALU_result_exmem),
      .data_i(Read_Data2_exmem),
      .MemRead_i(MemRead_exmem),
      .MemWrite_i(MemWrite_exmem),
      .data_o(MEM_Data_mem)
  );
  //=================MEM/WB=======================
//   wire MemtoReg_memwb;
//   wire RegWrite_memwb;
//   wire [4:0] Write_Register_memwb;
  wire [31:0] MEM_Data_memwb;
  wire [31:0] ALU_result_memwb;
 // 2 + 5 + 32 + 32
  Pipe_Reg #(
    .size(71)
  ) MEM_WB (
    .clk_i(clk_i),
    .rst_n(rst_n),
    .data_i({MemtoReg_exmem,RegWrite_exmem,MEM_Data_mem,ALU_result_exmem,Write_Register_exmem}),
    .data_o({MemtoReg_memwb,RegWrite_memwb,MEM_Data_memwb,ALU_result_memwb,Write_Register_memwb})
  );
  //=======================WB===============
  wire [31:0] Write_Data_wb;
  Mux2to1 #(
      .size(32)
  ) Mux_Write_Reg (
      .data0_i (ALU_result_memwb),
      .data1_i (MEM_Data_memwb),
      .select_i(MemtoReg_memwb),
      .data_o  (Write_Data_wb)
  );
endmodule



