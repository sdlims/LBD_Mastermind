`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 02:21:28 PM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input clk_i,
    output [7:0] Q_o
    );
    
    wire [7:0] rnd;
    
    FDRE # (.INIT(1'b1)) Q0_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[0] ^ rnd[5] ^ rnd[6] ^ rnd[7]), .Q(rnd[0]));
    FDRE # (.INIT(1'b0)) Q1_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[0]), .Q(rnd[1]));
    FDRE # (.INIT(1'b0)) Q2_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[1]), .Q(rnd[2]));
    FDRE # (.INIT(1'b0)) Q3_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[2]), .Q(rnd[3]));
    FDRE # (.INIT(1'b0)) Q4_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[3]), .Q(rnd[4]));
    FDRE # (.INIT(1'b0)) Q5_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[4]), .Q(rnd[5]));
    FDRE # (.INIT(1'b0)) Q6_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[5]), .Q(rnd[6]));
    FDRE # (.INIT(1'b0)) Q7_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(rnd[6]), .Q(rnd[7]));
    
    assign Q_o = rnd;
    
endmodule