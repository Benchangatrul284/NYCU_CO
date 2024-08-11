`include "Full_adder.v"
module ALU_1bit (
    a,
    b,
    invertA,
    invertB,
    operation,
    carryIn,
    less,
    result,
    carryOut
);

  //I/O ports
  input a;
  input b;
  input invertA;
  input invertB;
  input [1:0] operation;
  input carryIn;
  input less;

  output result;
  output carryOut;

  //Internal Signals
  reg result;
  reg carryOut;
  reg a_inverted, b_inverted;
  //Main function
  /*your code here*/

  always @(*) begin
    a_inverted = (invertA)? ~a : a;
    b_inverted = (invertB)? ~b : b;
    carryOut = 0;
    result = 0;
    case (operation)
    2'b00: begin
      // (and / nor) operation
      result = a_inverted & b_inverted;
    end
    2'b01: begin
      // slt operation
      result = less;
    end
    2'b10: begin
      // (or/nand) operation
      result = a_inverted | b_inverted;
    end
    2'b11: begin
      // (add/sub) operation
      {carryOut,result} = a_inverted + b_inverted + carryIn;
    end

    endcase
  end
endmodule
