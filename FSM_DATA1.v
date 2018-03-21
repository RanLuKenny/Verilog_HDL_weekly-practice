
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2018 09:42:15 PM
// Design Name: 
// Module Name: Pro_3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module FSM_DATA1(clka, clkb, Temp_data,
             RESTART, LOAD, NOT,
             DATA, p_state, DO 
             );
parameter DATA_DEPTH = 3;   
  
input clka, clkb, RESTART, LOAD, NOT; //clock signal and some control signal
input [DATA_DEPTH:0] DATA;//input data

output reg [DATA_DEPTH:0] DO; //output data
output reg p_state; //output present state

reg n_state; //next state

output reg [DATA_DEPTH:0] Temp_data; //temp register

parameter RESET_STATE = 0, LOAD_STATE = 1; //state parameters
/*sequential logic*/
always @ (posedge clka)
begin 
    if(RESTART)
        p_state <= RESET_STATE;
    else
        p_state <= n_state;
end
/*combinational logic*/
always @ (posedge clkb)
begin
    n_state = p_state;
    case (p_state)
        RESET_STATE: begin //reset state
            DO = 4'b0000;  //output data clear
            if(!LOAD)
                n_state = RESET_STATE;               
            else
                n_state = LOAD_STATE;
        end
        
        LOAD_STATE: begin //load state
            if(LOAD)begin //if LOAD = 1, keeps in this state
                n_state = LOAD_STATE;
                DO = DO; //output data keeps previous value
            end
            else //if load = 0
                begin
                    if(NOT) //if NOT = 1
				       begin 
					       DO = ~ Temp_data;//inverse and output data from temp registers
						   n_state = LOAD_STATE; //next sate is LOAD_STATE
					   end
                    else 
					   begin //othervise output previous value
						   DO = Temp_data;//output data from temp registers
						   n_state = LOAD_STATE; //next sate is LOAD_STATE
					end
             end   
        end
                  
		default: n_state = RESET_STATE;	//default next state is RESET
                                        //prevent unsafe latch	  
    endcase
end
/*data LOADED in stage*/
always @ (posedge LOAD)//when posedge LOAD
	begin
		if(RESTART) //if reset
			Temp_data <= 0; //output 0, clear
		else
			Temp_data <= DATA; //LOAD in put DATA into temp register
	end
endmodule
