`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: THARUN KUMAR U
// 
// Create Date: 08.05.2025 16:46:27
// Design Name: AXI STREAM
// Module Name: TEST
// Project Name: AXI STREAM
// Target Devices: Artix 7
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Code your testbench here
// or browse Examples
module tb;
  reg aclk,areset,tready;
  reg [31:0] tdata;
  reg [31:0] indata;
  reg in_valid;
  reg [1:0]mode;
  wire tvalid;
  wire [3:0] tkeep,tstrb;
  wire tlast;
  
  axi_stream dut(.aclk(aclk),.areset(areset),.indata(indata),.in_valid(in_valid),.tvalid(tvalid),.mode(mode));
  
  initial
    aclk = 0;
  always #5 aclk = ~aclk;
  
  initial
    begin
      areset = 0;
      #10;
      areset = 1;
      #10;
      in_valid = 1;
      mode = 00;
      indata = 32'h11112222;
      #40;
      mode = 01;
      #40;   
      mode = 10;

      in_valid = 0;
      #100;
      $finish;
    end
endmodule
  
