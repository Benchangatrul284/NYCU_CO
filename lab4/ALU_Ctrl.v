module ALU_Ctrl (
    funct_i,
    ALUOp_i,
    ALU_operation_o,
    FURslt_o,
    leftRight_o
);

  //I/O ports
  input [6-1:0] funct_i;
  input [2-1:0] ALUOp_i;

  output [4-1:0] ALU_operation_o;
  output  FURslt_o;
  output leftRight_o;

  //Internal Signals
  reg [4-1:0] ALU_operation_o;
  reg  FURslt_o;
  reg leftRight_o;

  //Main function

  /*your code here*/
  // input: ALUOp_i table (6 bits -> 2 bits)
  parameter ADD = 2'b00,
            SUB = 2'b01,
            FUNCT = 2'b10;

  // input: functional field table
  parameter ADD_funct = 6'b100011,
            SUB_funct = 6'b010011,
            AND_funct = 6'b011111,
            OR_funct = 6'b101111,
            NOR_funct = 6'b010000,
            SLT_funct = 6'b010100,
            SLL_funct = 6'b010010, 
            SRL_funct = 6'b100010;

  // output: ALU will do operation based on these table (ALU_operation_o)
  parameter AND_ALU = 4'b0000,
            OR_ALU = 4'b0001,
            ADD_ALU = 4'b0010,
            SUB_ALU = 4'b0110,
            SLT_ALU = 4'b0111,
            NOR_ALU = 4'b1100;

  

  always @(*) begin
    ALU_operation_o = 4'b0000;
    FURslt_o = 1'b0;
    leftRight_o = 1'b0;
    case (ALUOp_i)
    // I-type: lw, sw
    ADD: begin
      ALU_operation_o = ADD_ALU;
    end
    // I-type: beq, bne (decoder have branch type, don't need to worry)
    SUB: begin
      ALU_operation_o = SUB_ALU;
    end
    // R-type instruction go here
    FUNCT: begin
      case (funct_i)
        ADD_funct:
          ALU_operation_o = ADD_ALU;
        SUB_funct:
          ALU_operation_o = SUB_ALU;
        AND_funct:
          ALU_operation_o = AND_ALU;
        OR_funct:
          ALU_operation_o = OR_ALU;
        NOR_funct:
          ALU_operation_o = NOR_ALU;
        SLT_funct:
          ALU_operation_o = SLT_ALU;
      endcase
    end
    endcase
  end
endmodule
