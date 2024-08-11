module Shifter (
    leftRight,
    shamt,
    sftSrc,
    result
);

  //I/O ports
  input leftRight;
  input [5-1:0] shamt;
  input [32-1:0] sftSrc;

  output [32-1:0] result;
  reg [32-1:0] result;
  //Main function
  /*your code here*/
  always @(*) begin
    result = (leftRight == 1'b1) ? (sftSrc << shamt) : (sftSrc >> shamt);
  end
endmodule 
