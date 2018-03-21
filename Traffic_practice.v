`timescale 1ns / 1ps

module Traffic_practice(car_farm_road, clk, reset, Main_road, Farm_road);

input car_farm_road;
input clk ,reset;

output reg [1:0] Main_road, Farm_road;

reg [2:0] p_state;
wire [2:0] n_state;

parameter RED = 0, YELLOW = 1, GREEN = 2;
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;      

assign n_state = FSM(p_state, car_farm_road);
/*  //   Farm_road(signal) Main_road(signal)
    S0:  RED               GREEN
    S1:  RED               YELLOW
    S2:  RED               RED
    S3:  GREEN             RED
    S4:  YELLOW            RED  
*/
/*comb logic by using function, different style*/
function [2:0] FSM;
    input [2:0] p_state;
    input car_farm_road;
    case(p_state)
    S0: begin
        if(car_farm_road) FSM = S1;
        else FSM = S0;
    end
    S1: begin
        FSM = S2;
    end
    S2: begin
        FSM = S3;
    end
    S3: begin
        if(car_farm_road) FSM = S3;
        else FSM = S4;
    end
    S4: begin
        FSM = S0;
    end
    default : FSM = S0;
    endcase
endfunction

//sequential logic
always @(posedge clk, negedge reset)
begin
    if(~reset)
        p_state <= S0;
    else
        p_state <= n_state;
end
//data output logic
always@(p_state) //data_path always
begin
    //give default output
    Main_road = GREEN;
    Farm_road = RED;
    case (p_state)
    S0: begin end
    S1: begin
        Main_road = YELLOW;
    end
    
    S2: begin
        Main_road = RED;
    end
    
    S3: begin
        Main_road = RED;
        Farm_road = GREEN;    
    end
    
    S4: begin
        Main_road = RED;
        Farm_road = YELLOW;
    end 
    default: begin
        Main_road = GREEN;
        Farm_road = RED;
    end
    endcase
end

endmodule 