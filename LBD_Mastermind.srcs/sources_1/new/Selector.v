`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2023 01:33:40 PM
// Design Name: 
// Module Name: Selector
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

module Selector(
    input [7:0] a_i,
    input [1:0] sel_i,
    output [3:0] y_o
    );
    
    assign y_o[3] = (a_i[7] & ~sel_i[1]) | (a_i[3] & ~sel_i[0]);
    assign y_o[2] = (a_i[6] & ~sel_i[1]) | (a_i[2] & ~sel_i[0]);
    assign y_o[1] = (a_i[5] & ~sel_i[1]) | (a_i[1] & ~sel_i[0]);
    assign y_o[0] = (a_i[4] & ~sel_i[1]) | (a_i[0] & ~sel_i[0]);
      
endmodule