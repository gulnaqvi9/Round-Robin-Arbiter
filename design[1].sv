///Defining Arbiter module
`timescale 1ns/1ps
module Arbiter # (parameter NumRequest = 4)(
  input [NumRequest-1:0] Request,
  input clk,
  output reg [NumRequest-1:0] Grant);
  integer i;
  
  always@(*)
    begin
      Grant = 0;
      for (i=0;i<NumRequest;i++)
        begin
        if(Request[i])
          begin
            Grant[i] = 1;
      	 	i = NumRequest;
          end
        end
  end
endmodule

///Defining roundrobin arbiter

module RoundRobin # (parameter NumReq = 4)(
  input [NumReq-1:0] req,
  output reg [NumReq-1:0] mask,
  input clk,
  input rst,
  output [NumReq-1:0] grant,
  output reg [NumReq-1:0] NextMask);
  
  integer i;
  
  reg [NumReq-1:0] UnmaskedGrant;
  reg [NumReq-1:0] MaskedGrant;
  reg [NumReq-1:0] MaskedReq;
  
  
  assign MaskedReq = mask & req;
  
  Arbiter   UnmaskedArbiter (.Request(req),
                             .Grant(UnmaskedGrant),
                             .clk(clk));
  
  Arbiter  MaskedArbiter (.Request(MaskedReq),
                          .clk(clk),
                          .Grant(MaskedGrant));
  
  assign grant = (~| MaskedReq)? UnmaskedGrant: MaskedGrant;
  
  ////logic for next mask
  
 always @(*) begin
  //if(rst)
    // NextMask = mask;
  // else begin

   if (grant == 4'b0000)
      NextMask = mask;
    else begin
      NextMask = {NumReq{1'b1}};
      for (i = 0; i < NumReq; i = i + 1) begin
        
        NextMask[i] = 1'b0;
        if (grant[i]) 
          i = NumReq;
      end
    end
  end
// end


  always@(posedge clk or posedge rst)
  begin
    if(rst) begin
      mask <= {NumReq{1'b1}};
     
    end
    else
       mask <= NextMask ;
  end
  
  endmodule
