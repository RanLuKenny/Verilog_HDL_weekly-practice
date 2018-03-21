//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2018 11:06:56 PM
// Design Name: 
// Module Name: test_Pro_2
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


module tb_Ford_car_brake_light();

reg clka, clkb, RESTART, BRAKE, RIGHT, LEFT;
wire [2:0] L, R;
wire ERROR; 
wire [3:0] n_state, p_state;
//reg [5:0] z; 

Pro_2 Ford_car_brake_light(clka, clkb, RESTART, BRAKE, 
            RIGHT, LEFT, L, R, ERROR, 
            n_state, p_state);

initial
begin
    clka = 0;
    clkb = 1;
    RESTART = 1;
    LEFT = 0;
    BRAKE = 0;
    LEFT = 0;
    RIGHT = 0; 
    #10 RESTART = 0;   
end

initial // LEFT
begin
    #10  LEFT = 1;
    #130 LEFT = 0;
    #280 LEFT = 1;
    #300 LEFT = 0;
end

initial // RIGHT
begin
    #130 RIGHT = 1;
    #250 RIGHT = 0;
    #280 RIGHT = 1;
    #310 RIGHT = 0;
end

initial // BRAKE
begin
    #90  BRAKE = 1;
    #130 BRAKE = 0;
    #210 BRAKE = 1;
    #280 BRAKE = 0;
end

initial
begin
//    {a,b,c,d,e,f} = 0;
    
    $dumpfile("test_Pro2.vcd");
    $dumpvars;
    
    $display("\t\t clka,\t clkb,\t RESTART,\t BRAKE,\t RIGHT,\t LEFT,\t ERROR");
    $monitor("\t\t clka,\t clkb,\t RESTART,\t BRAKE,\t RIGHT,\t LEFT,\t ERROR");
  
    #320 $finish;
end

always
    #5 clka = ~clka; //period of clock is 10

always
    #5 clkb = ~clkb; //set clkb
    
endmodule