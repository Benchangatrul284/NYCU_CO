`include "ALU_1bit.v"
module ALU (
    aluSrc1,
    aluSrc2,
    invertA,
    invertB,
    operation,
    result,
    zero,
    overflow
);

  //I/O ports
  input [32-1:0] aluSrc1;
  input [32-1:0] aluSrc2;
  input invertA;
  input invertB;
  input [2-1:0] operation;

  output [32-1:0] result;
  output zero;
  output overflow;

  //Internal Signals
  wire [31:0] result;
  wire zero;
  wire overflow;
  wire [31:0] carry;

  wire set;
  assign set = result[31];
  // assign set = aluSrc1[31] ^ (aluSrc2[31]) ^ carry[31];
  assign overflow = carry[31] ^ carry[30];
  assign zero = ~(|result);

  ALU_1bit ALU0 (.a(aluSrc1[0]),.b(aluSrc2[0]),
                .invertA(invertA),.invertB(invertB),
                .operation(operation),.carryIn(invertB),
                .less(set),.result(result[0]),.carryOut(carry[0]));

  ALU_1bit ALU1 (.a(aluSrc1[1]),.b(aluSrc2[1]), 
        .invertA(invertA),.invertB(invertB), 
        .operation(operation),.carryIn(carry[0]),
        .less(1'b0),.result(result[1]),.carryOut(carry[1]));
  ALU_1bit ALU2 (.a(aluSrc1[2]),.b(aluSrc2[2]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[1]),
          .less(1'b0),.result(result[2]),.carryOut(carry[2]));
  ALU_1bit ALU3 (.a(aluSrc1[3]),.b(aluSrc2[3]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[2]),
          .less(1'b0),.result(result[3]),.carryOut(carry[3]));
  ALU_1bit ALU4 (.a(aluSrc1[4]),.b(aluSrc2[4]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[3]),
          .less(1'b0),.result(result[4]),.carryOut(carry[4]));
  ALU_1bit ALU5 (.a(aluSrc1[5]),.b(aluSrc2[5]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[4]),
          .less(1'b0),.result(result[5]),.carryOut(carry[5]));
  ALU_1bit ALU6 (.a(aluSrc1[6]),.b(aluSrc2[6]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[5]),
          .less(1'b0),.result(result[6]),.carryOut(carry[6]));
  ALU_1bit ALU7 (.a(aluSrc1[7]),.b(aluSrc2[7]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[6]),
          .less(1'b0),.result(result[7]),.carryOut(carry[7]));
  ALU_1bit ALU8 (.a(aluSrc1[8]),.b(aluSrc2[8]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[7]),
          .less(1'b0),.result(result[8]),.carryOut(carry[8]));
  ALU_1bit ALU9 (.a(aluSrc1[9]),.b(aluSrc2[9]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[8]),
          .less(1'b0),.result(result[9]),.carryOut(carry[9]));
  ALU_1bit ALU10 (.a(aluSrc1[10]),.b(aluSrc2[10]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[9]),
          .less(1'b0),.result(result[10]),.carryOut(carry[10]));
  ALU_1bit ALU11 (.a(aluSrc1[11]),.b(aluSrc2[11]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[10]),
          .less(1'b0),.result(result[11]),.carryOut(carry[11]));
  ALU_1bit ALU12 (.a(aluSrc1[12]),.b(aluSrc2[12]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[11]),
          .less(1'b0),.result(result[12]),.carryOut(carry[12]));
  ALU_1bit ALU13 (.a(aluSrc1[13]),.b(aluSrc2[13]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[12]),
          .less(1'b0),.result(result[13]),.carryOut(carry[13]));
  ALU_1bit ALU14 (.a(aluSrc1[14]),.b(aluSrc2[14]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[13]),
          .less(1'b0),.result(result[14]),.carryOut(carry[14]));
  ALU_1bit ALU15 (.a(aluSrc1[15]),.b(aluSrc2[15]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[14]),
          .less(1'b0),.result(result[15]),.carryOut(carry[15]));
  ALU_1bit ALU16 (.a(aluSrc1[16]),.b(aluSrc2[16]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[15]),
          .less(1'b0),.result(result[16]),.carryOut(carry[16]));
  ALU_1bit ALU17 (.a(aluSrc1[17]),.b(aluSrc2[17]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[16]),
          .less(1'b0),.result(result[17]),.carryOut(carry[17]));
  ALU_1bit ALU18 (.a(aluSrc1[18]),.b(aluSrc2[18]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[17]),
          .less(1'b0),.result(result[18]),.carryOut(carry[18]));
  ALU_1bit ALU19 (.a(aluSrc1[19]),.b(aluSrc2[19]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[18]),
          .less(1'b0),.result(result[19]),.carryOut(carry[19]));
  ALU_1bit ALU20 (.a(aluSrc1[20]),.b(aluSrc2[20]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[19]),
          .less(1'b0),.result(result[20]),.carryOut(carry[20]));
  ALU_1bit ALU21 (.a(aluSrc1[21]),.b(aluSrc2[21]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[20]),
          .less(1'b0),.result(result[21]),.carryOut(carry[21]));
  ALU_1bit ALU22 (.a(aluSrc1[22]),.b(aluSrc2[22]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[21]),
          .less(1'b0),.result(result[22]),.carryOut(carry[22]));
  ALU_1bit ALU23 (.a(aluSrc1[23]),.b(aluSrc2[23]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[22]),
          .less(1'b0),.result(result[23]),.carryOut(carry[23]));
  ALU_1bit ALU24 (.a(aluSrc1[24]),.b(aluSrc2[24]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[23]),
          .less(1'b0),.result(result[24]),.carryOut(carry[24]));
  ALU_1bit ALU25 (.a(aluSrc1[25]),.b(aluSrc2[25]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[24]),
          .less(1'b0),.result(result[25]),.carryOut(carry[25]));
  ALU_1bit ALU26 (.a(aluSrc1[26]),.b(aluSrc2[26]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[25]),
          .less(1'b0),.result(result[26]),.carryOut(carry[26]));
  ALU_1bit ALU27 (.a(aluSrc1[27]),.b(aluSrc2[27]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[26]),
          .less(1'b0),.result(result[27]),.carryOut(carry[27]));
  ALU_1bit ALU28 (.a(aluSrc1[28]),.b(aluSrc2[28]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[27]),
          .less(1'b0),.result(result[28]),.carryOut(carry[28]));
  ALU_1bit ALU29 (.a(aluSrc1[29]),.b(aluSrc2[29]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[28]),
          .less(1'b0),.result(result[29]),.carryOut(carry[29]));
  ALU_1bit ALU30 (.a(aluSrc1[30]),.b(aluSrc2[30]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[29]),
          .less(1'b0),.result(result[30]),.carryOut(carry[30]));
  ALU_1bit ALU31 (.a(aluSrc1[31]),.b(aluSrc2[31]), 
          .invertA(invertA),.invertB(invertB), 
          .operation(operation),.carryIn(carry[30]),
          .less(1'b0),.result(result[31]),.carryOut(carry[31]));

endmodule

