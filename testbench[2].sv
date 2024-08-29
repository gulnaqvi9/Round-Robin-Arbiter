
/////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

parameter NumReq = 4;

module tb_RRA;

  
reg clk;
reg rst;
reg [NumReq-1:0] req;
reg [NumReq-1:0] mask;
wire [NumReq-1:0] grant; 
  
  reg [NumReq-1:0] UnmaskedGrant;
  reg [NumReq-1:0] MaskedGrant;
  reg [NumReq-1:0] MaskedReq;
  reg [NumReq-1:0] NextMask;
 

////instantiating the module
RoundRobin uut(.clk(clk),
.rst(rst),
.req(req),
.mask(mask),
.grant(grant),
.NextMask(NextMask));


////generating the clock using forever
initial begin
clk = 0;
forever #10 clk = ~clk;
end

////applying the input for testing
initial
begin
 ///initialising the signals
 
 rst = 1; req = 4'b0000;

 
 #10 rst = 0 ; req = 4'b0111;

 #20 req = 4'b0101;
  
#20 req = 4'b0011;
  
#50
$finish;
end
 
 ////monitoring the results
initial 
  begin
  $monitor(" %d |clk = %b | rst = %b |req = %b |Mask = %b | Grant = %b | Next Mask = %b ",$time,clk, rst,req,mask,grant, NextMask);
end
endmodule 

