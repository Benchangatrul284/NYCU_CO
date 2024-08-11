module ALU_Ctrl (
    instr_op_i,
    funct_i,
    ALUOp_i,
    ALU_operation_o,
    FURslt_o,
    leftRight_o
);

  //I/O ports
  input [5:0] instr_op_i; // stupid HW (use Opcode to directly control ALU_Op)
  input [6-1:0] funct_i;
  input [3-1:0] ALUOp_i;

  output [4-1:0] ALU_operation_o;
  output [2-1:0] FURslt_o;
  output leftRight_o;

  //Internal Signals
  wire [4-1:0] ALU_operation_o;
  wire [2-1:0] FURslt_o;
  wire leftRight_o;

  //Main function
  /*your code here*/
  // ALU_operation_o
  // FURslt_o -> Function Unit Result
  // leftRight_o -> 1 bit to set whether left shift (1) or right shift (0)
  // this is the ALU Control module
  // input is ALUop (3 bits)
  // output:
  // ALU_operation_o (4 bits): ALU will follow this
  // FURslt_o (2 bits): select what as ALU result 0: ALU, 1: shifter, 2: zero filled
  // leftRight_o (1 bit): left shift or right shift
  
  reg [3:0] ALU_operation_o_reg;
  reg [1:0] FURslt_o_reg;
  reg leftRight_o_reg;

  assign ALU_operation_o = ALU_operation_o_reg;
  assign FURslt_o = FURslt_o_reg;
  assign leftRight_o = leftRight_o_reg;

  // ALU will do operation based on these table:
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
            
  // ALUOp_i table (6 bits -> 2 bits) pad zero left
  parameter ADD = 3'b000,
            SUB = 3'b001,
            FUNCT = 3'b010;

  // functional field table
  parameter ADD_funct = 6'b100011,
            SUB_funct = 6'b010011,
            AND_funct = 6'b011111,
            OR_funct = 6'b101111,
            NOR_funct = 6'b010000,
            SLT_funct = 6'b010100,
            SLL_funct = 6'b010010,
            SRL_funct = 6'b100010,
            SLLV_funct = 6'b011000, // advanced set: shift left logical variable
            SLRV_funct = 6'b101000; // advanced set: shift right logical variable

  // stupid HW (directly use OPcode)
  parameter BLT_OP = 6'b011100,
            BNEZ_OP = 6'b011101,
            BGEZ_OP = 6'b011110;

  always @(*) begin
    ALU_operation_o_reg = 4'b0;
    FURslt_o_reg = 2'b0;
    leftRight_o_reg = 1'b0;
    case (ALUOp_i)
    // I-type: lw, sw
    ADD: begin
      ALU_operation_o_reg = ADD_ALU;
    end
    // I-type: beq, bne (decoder have branch type, don't need to worry)
    SUB: begin
      ALU_operation_o_reg = SUB_ALU;
    end
    // R-type instruction go here
    FUNCT: begin
      case (funct_i)
        ADD_funct:
          ALU_operation_o_reg = ADD_ALU;
        SUB_funct:
          ALU_operation_o_reg = SUB_ALU;
        AND_funct:
          ALU_operation_o_reg = AND_ALU;
        OR_funct:
          ALU_operation_o_reg = OR_ALU;
        NOR_funct:
          ALU_operation_o_reg = NOR_ALU;
        SLT_funct:
          ALU_operation_o_reg = SLT_ALU;
        SLLV_funct: begin
          ALU_operation_o_reg = SLLV_ALU;
        end
        SLRV_funct: begin
          ALU_operation_o_reg = SLRV_ALU;
        end
        SLL_funct: begin
          FURslt_o_reg = 2'b01; // the result will come from shifter
          leftRight_o_reg = 1'b1; // shift left
        end
        SRL_funct: begin
          FURslt_o_reg = 2'b01; // the result will come from shifter
          leftRight_o_reg = 1'b0; // shift right
        end
      endcase
    end
    endcase

    // special handling for BLT, BNEZ, BGEZ
    case (instr_op_i)
    BLT_OP:
      ALU_operation_o_reg = BLT_ALU;
    BNEZ_OP:
      ALU_operation_o_reg = BNEZ_ALU;
    BGEZ_OP:
      ALU_operation_o_reg = BGEZ_ALU;
    endcase
  end
endmodule
