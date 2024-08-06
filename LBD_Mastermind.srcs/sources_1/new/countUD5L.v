`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2023 10:54:38 AM
// Design Name: 
// Module Name: countUD5L
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


module countUD5L(
    input clk_i,
    //Control Signal: Dw means we start decrementing
    input Dw,
    //Outputs the new 5-bit bus with incremented/decremented values
    output [3:0] Q,
    //Control Signal: Are we still decrementing?
    output DTC
    );

    wire [3:0] decr, Cout;
    
    assign decr[0] = (~Q[0]);
    assign decr[1] = (~Q[1] & ~Q[0]) | (Q[1] & Q[0]);
    assign decr[2] = (~Q[2] & ~Q[1] & ~Q[0]) | (Q[2] & Q[0]) | (Q[2] & Q[1]);
    assign decr[3] = (~Q[3] & ~Q[2] & ~Q[1] & ~Q[0]) | (Q[3] & Q[0]) | (Q[3] & Q[1]) | (Q[3] & Q[2]);
    
    assign Cout[0] = (decr[0] & Dw);
    assign Cout[1] = (decr[1] & Dw);
    assign Cout[2] = (decr[2] & Dw);
    assign Cout[3] = (decr[3] & Dw);

    // Initialized to 10
    FDRE #(.INIT(1'b0)) FF_0 (.C(clk_i), .R(1'b0), .CE(Dw), .D(Cout[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b1)) FF_1 (.C(clk_i), .R(1'b0), .CE(Dw), .D(Cout[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) FF_2 (.C(clk_i), .R(1'b0), .CE(Dw), .D(Cout[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b1)) FF_3 (.C(clk_i), .R(1'b0), .CE(Dw), .D(Cout[3]), .Q(Q[3]));
    
    //Assign 'Overflow' Output
    assign DTC = ~(Q[3] | Q[2] | Q[1] | Q[0]);
    
endmodule