`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2023 01:34:36 PM
// Design Name: 
// Module Name: EdgeDetector
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


module EdgeDetector(
    input clk_i,
    //either btnU or btnD
    input in_i,
    output out_o
    );
    
    wire in_prev_w;
    FDRE #(.INIT(1'b0)) Q0_FF (.C(clk_i), .R(1'b0), .CE(1'b1), .D(in_i), .Q(in_prev_w));
//    FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(w1), .Q(w2));
    assign out_o = in_prev_w & ~in_i; //Once button is released, generate signal

endmodule