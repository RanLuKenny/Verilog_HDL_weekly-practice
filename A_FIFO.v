//Asynchrounous FIFO
//this is what I wrote in second round interview in front of Dr Ken
//I finished it after interview
module A_FIFO(clkr, clkw, rst_n,
	      wt, rd,
	      data_in, data_out,
	      full, empty
	     );
parameter SIZE = 7;
parameter QUEUE_FULL = 8;

input clkr, clkw, rst_n, wt, rd;
input [SIZE:0] data_in;

output reg [SIZE:0] data_out;
output wire empty, full;

reg [4:0] counter, RD_pointer, WT_pointer;
reg [SIZE:0] mem [0:QUEUE_FULL-1];

assign empty = (counter == 0);
assign full = (counter == QUEUE_FULL - 1);

always @(posedge clkw, negedge rst_n)//read
begin
    if(!rst_n || WT_pointer == 8)
        WT_pointer = 0;        
    else if(!full && wt)
        WT_pointer = WT_pointer + 1;        
    else
        WT_pointer = WT_pointer;               
end

always @(posedge clkr, negedge rst_n)//write
begin
    if(!rst_n ||RD_pointer == 8)
        RD_pointer = 0;        
    else if(!empty && rd)
        RD_pointer = RD_pointer + 1;        
    else
        RD_pointer = RD_pointer;   
end


always @(posedge clkw, negedge rst_n)//write
begin
    if(!rst_n)
        mem[WT_pointer] = 0;               
    else if(!full && wt)
        mem[WT_pointer] = data_in;        
    else
        mem[WT_pointer] = mem[WT_pointer]; 
end

always @(posedge clkr, negedge rst_n)//read
begin
    if(!rst_n)
        data_out = 0;           
    else if(!empty && rd)
        data_out = mem[WT_pointer];        
    else
        data_out = data_out; 
end

always @ (*)
begin
    if(!rst_n)
        counter = 0;          
    else if(!empty && rd)
        counter = counter - 1;        
    else if(!full && wt)
        counter = counter + 1; 
    else
        counter = counter;
end

endmodule
