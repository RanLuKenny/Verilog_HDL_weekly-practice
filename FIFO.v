`timescale 1ns / 1ps
module FIFO(rst_n, 
	    clk, 
	    wt, 
	    rd, 
	    data_in,
	    data_out,
	    empty,
	    full,
	    counter, RD_pointer, WT_pointer);
parameter SIZE = 7;
parameter QUEUE_FULL = 8;

input rst_n, clk, wt, rd;
input [SIZE:0] data_in;

output wire empty, full;
output reg [SIZE:0] data_out;				

reg [SIZE:0] memory [0: QUEUE_FULL];
output reg [4:0] counter, RD_pointer, WT_pointer;

assign full = (counter == QUEUE_FULL);
assign empty = (counter == 0);

always @(posedge clk, negedge rst_n)//counter
begin
	if(!rst_n)
	   counter = 0;
	else
	   begin
	       if(rd && !empty && !wt)
	           counter = counter - 1;
	       else if (wt && !full && !rd)
	           counter = counter + 1;
	       else
	           counter = counter;   
	   end
end

always @(posedge clk, negedge rst_n)//read
begin
   if(!rst_n)
	   RD_pointer = 0;
	else
	   begin
	      if (RD_pointer == QUEUE_FULL)
		  RD_pointer = 0;
	      else if(rd && !empty && !wt)
                  RD_pointer = RD_pointer + 1;
	      else
	          RD_pointer = RD_pointer;			  
	   end
end

always @(posedge clk, negedge rst_n)//write
begin
   if(!rst_n)
	   WT_pointer = 0;
	else
	   begin
	      if (WT_pointer == QUEUE_FULL)
	          WT_pointer = 0;
	      else if(wt && !full && !rd)
                  WT_pointer = WT_pointer + 1;
	      else
	          WT_pointer = WT_pointer;
	   end
end

always @(posedge clk)//assign read/write
begin
    if(!rst_n)
        data_out <= 0;
    else if(!full && wt &&)
        memory[WT_pointer] <= data_in;
    else if (!empty && rd &&) 
        data_out <= memory[RD_pointer];
    else
        data_out <= data_out;
end

endmodule 
