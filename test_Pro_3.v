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


module test_FSM_DATA1();

reg clka, clkb, RESTART, NOT, LOAD;
reg [3:0] DATA;

wire [3:0] Temp_data, DO; 
wire p_state;
//reg [5:0] z; 

Pro_3 FSM_DATA1 (clka, clkb, Temp_data,
             RESTART, LOAD, NOT,
             DATA, p_state, DO 
             );

initial
fork
    clka = 0;
    clkb = 0;
    RESTART = 1;
    LOAD = 0;
    NOT = 0;
    DATA = 0;
join

always // DATA
begin
    #25 DATA = DATA + 1;
end

initial // RIGHT
fork
    #25 RESTART = 0;
    #270 RESTART = 1;
    #300 RESTART = 0;
join

initial // BRAKE
fork
    #45 LOAD = 1;
    #100 LOAD = 0;
    #180 LOAD = 1;
    #320 LOAD = 0;

    
    #90 NOT = 1;
    #130 NOT = 0;
    #165 NOT = 1;
    #190 NOT = 0;
    #260 NOT = 1;
    #330 NOT = 0;
    #370 NOT = 1;
    #400 NOT = 0;
join

initial
begin 
    $dumpfile("test_Pro3.vcd");
    $dumpvars;
    
    $display("\t\t clka,\t clkb,\t RESTART,\t NOT,\t LOAD,\t p_state,\t DATA,\t Temp_data,\t DO");
    $monitor("\t\t clka,\t clkb,\t RESTART,\t NOT,\t LOAD,\t p_state,\t DATA,\t Temp_data,\t DO");
  
    #420 $finish;
end

always
    fork
        #5 clka = 1; //period of clock is 10
        #10 clka = 0;
        #15 clka = 0;
        #20 clka = 0;
    join
    
always
    fork
        #5 clkb = 0; //period of clock is 10
        #10 clkb = 0;
        #15 clkb = 1;
        #20 clkb = 0;
    join //set clkb
    
endmodule