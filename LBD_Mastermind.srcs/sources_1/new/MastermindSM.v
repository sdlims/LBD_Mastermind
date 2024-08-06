`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2024 12:47:44 PM
// Design Name: 
// Module Name: MastermindSM
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


module MastermindSM(
    input clk_i,
    input [15:0] user_i,
    input [15:0] lfsr_i,
    input go_i,
    input lockin_i,
    output [15:0] led_o,
    output [3:0] attempts_o,
    output [1:0] correct_o,
    output flash_o
    );
endmodule
