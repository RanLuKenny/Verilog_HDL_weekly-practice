module Shift_add_Mult(Op1, Op2, Out);

parameter N = 4;

input [N - 1:0] Op1, Op2;
output reg [7:0] Out;
reg [3:0] temp1, temp2;

integer n;

always @ (Op1, Op2)
	begin
		temp1 = Op1;
		temp2 = Op2;
		Out = 0;
		
		for (n = 0; n < N ; n = n + 1)
		begin
			if(temp2[0] == 1)
				Out = Out + temp1;
			temp1 = temp1 << 1;
			temp2 = temp2 >> 1;
		end
	end
	
endmodule 