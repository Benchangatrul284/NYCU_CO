module Shifter (
    result,
    leftRight,
    shamt,
    sftSrc
);

  //I/O ports
  output [32-1:0] result;

  input leftRight;
  input [5-1:0] shamt;
  input [32-1:0] sftSrc;

  //Internal Signals
  wire [32-1:0] result;
  //Main function
  /*your code here*/
  reg [31:0] result_reg;
  assign result = result_reg;
  
  always @(*) begin
    result_reg = (leftRight == 1'b1) ? (sftSrc << $unsigned(shamt)) : (sftSrc >> $unsigned(shamt));
  end

endmodule
