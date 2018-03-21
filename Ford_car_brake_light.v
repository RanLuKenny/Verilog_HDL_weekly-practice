module Ford_car_brake_light(clka, clkb, RESTART, BRAKE, RIGHT, LEFT, L, R, ERROR, n_state, p_state);

input clka, clkb;                  //two phase clocks
input RESTART, BRAKE, RIGHT, LEFT; //four input ports
output wire ERROR;                 //output ERROR
output reg [2:0] L, R;             //LEFT and RIGHT lamps

output reg [3:0] p_state, n_state; //present state, next state;
/*state parameters*/
parameter reset = 0, run = 1, error = 2;
parameter R1 = 3, R2 = 4, R3 = 5, R4 = 6;
parameter L1 = 7, L2 = 8, L3 = 9, L4 =10;

assign ERROR = (RIGHT && LEFT);    //output ERROR signal
/*sequential logic*/
always @ (posedge clka) 
begin
	if(RESTART)
		p_state <= reset; //initial state
	else
		p_state <= n_state; //go to next state
end

/*combinational logic*/
always @ (posedge clkb)
begin
	n_state = p_state;
	case (p_state)
		reset: begin  //reset state
			L = 3'b000;
			R = 3'b000;
			n_state = run;
		end
		
		run: begin   //run state
			if(!LEFT && !RIGHT) begin //LEFT == 0 and RIGHT == 0
				if(BRAKE)begin  //if break all lamps go high
					L = 3'b111;
					R = 3'b111;
				end
				else begin      //if !break all lamps go low
					L = 3'b000;
					R = 3'b000;
				end
				n_state = run; //next state is run
			end
			
			else if(LEFT && !RIGHT) begin //LEFT == 1 and RIGHT == 0
				if(BRAKE)      //if break left lamps go high
					L = 3'b111;
				else
					L = 3'b000;//if !break left lamps go low
				n_state = L1;  //next state L1, start to turn left
			end
				
			else if(!LEFT && RIGHT) begin //same as above, turn right		
				if(BRAKE)
					L = 3'b111;
				else
					L = 3'b000;
				n_state = R1; //next state R1
			end
			
			else begin //LEFT == 1 and RIGHT == 1, all lamps go low
				L = 3'b000;
				R = 3'b000;
				n_state = error; //next state is error
			end
		end
		/*state error*/
		error: begin //error state, extinguish all the lamps
			L = 3'b000;
			R = 3'b000;
			if(LEFT && RIGHT) //is LEFT == 1 and RIGHT == 1
				n_state = error; //stay in error state 
			else if(!LEFT && RIGHT) //if LEFT = 0, we can turn right now
				n_state = R1;
			else if(LEFT && !RIGHT) //if RIGHT = 0, we can turn right now
			   n_state = L1;
			else //if all lamps go low, next state is run
				n_state = run;
		end
		
		R1: begin //start turn right
			R = 3'b000;
			if(BRAKE)
				L = 3'b111;
			else
				L = 3'b000;
			n_state = R2;
		end
		
		R2: begin
			R = 3'b100;
			if(BRAKE)
				L = 3'b111;
			else
				L = 3'b000;
			n_state = R3;
		end
		
		R3: begin
			R = 3'b110;
			if(BRAKE)
				L = 3'b111;
			else
				L = 3'b000;
			n_state = R4;
		end
		
		R4: begin
			R = 3'b111;
			if(BRAKE)
				L = 3'b111;
			else
				L = 3'b000;
			n_state = run;
		end
		
		L1: begin  //start turn left
			L = 3'b000;
			if(BRAKE)
				R = 3'b111;
			else
				R = 3'b000;
			n_state = L2;
		end
		
		L2: begin
			L = 3'b001;
			if(BRAKE)
				R = 3'b111;
			else
				R = 3'b000;
			n_state = L3;
		end
		
		L3: begin
			L = 3'b011;
			if(BRAKE)
				R = 3'b111;
			else
				R = 3'b000;
			n_state = L4;
		end
		
		L4: begin 
			L = 3'b111;
			if(BRAKE)
				R = 3'b111;
			else
				R = 3'b000;
			n_state = run;  //next state run
		end
		
		default: n_state = reset; //prevent unsafe latch, set default to reset
	endcase
end

endmodule 