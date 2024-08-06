`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2024 01:08:55 PM
// Design Name: 
// Module Name: RingCounter
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


module RingCounter(
    input clk_i,
    output [1:0] ring_o
    );
    
    FDRE #(.INIT(1'b0) ) FF0  (.C(clk_i), .CE(1'b1), .D(ring_o[0]), .Q(ring_o[1]));
    FDRE #(.INIT(1'b1) ) FF1  (.C(clk_i), .CE(1'b1), .D(ring_o[1]), .Q(ring_o[0]));
//    FDRE #(.INIT(1'b1) ) FF2  (.C(clk_i), .CE(1'b1), .D(ring_o[2]), .Q(ring_o[0]));
    
endmodule
