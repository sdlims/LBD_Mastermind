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
    input timeUp,
    input done_i,
    output [15:0] led_o,
    output decrement_o, // Happens if we transition to WRONG
    output [2:0] correct_o,
    output startTime,
    output flash_o
    );

    wire [4:0] state_d, state_q; //Q = Present State, D = Next State
    wire IDLE_q, WAIT_q, WIN_q, WRONG_q, LOSE_q;
    wire IDLE_d, WAIT_d, WIN_d, WRONG_d, LOSE_d;

    assign state_d = {IDLE_d, WAIT_d, WIN_d, WRONG_d, LOSE_d};
    assign {IDLE_q, WAIT_q, WIN_q, WRONG_q, LOSE_q} = state_q[0:4];

    // State Transition Logic Equations
    assign IDLE_d = (IDLE_q & ~go_i) | (WRONG_q & ~done_i);
    assign WAIT_d = (IDLE_q & go_i) | (WAIT_q & ~lockin_i);
    assign WIN_d = (WAIT_q & lockin_i & (user_i == lfsr_i)) | (WIN_q & 1'b1);
    assign WRONG_d = (WAIT_q & lockin_i & (user_i != lfsr_i)) | (WRONG_q & ~timeUp & ~done_i);
    assign LOSE_d = (WRONG_q & ~timeUp & done_i) | (LOSE_q & 1'b1);


    // Output Equations

    wire led_en_w;
    assign led_en_w = (WAIT_q & lockin_i);

    wire [3:0] correct_w;
    assign correct_w[0] = lfsr_i[3:0] == user_i[3:0];
    assign correct_w[1] = lfsr_i[7:4] == user_i[7:4];
    assign correct_w[2] = lfsr_i[11:8] == user_i[11:8];
    assign correct_w[3] = lfsr_i[15:12] == user_i[15:12];

    wire [3:0] partial_w;
    assign partial_w[0] = (user_i[3:0] == lfsr_i[7:4]) | (user_i[3:0] == lfsr_i[11:8]) | (user_i[3:0] == lfsr_i[15:12]);
    assign partial_w[1] = (user_i[7:4] == lfsr_i[3:0]) | (user_i[7:4] == lfsr_i[11:8]) | (user_i[7:4] == lfsr_i[15:12]);
    assign partial_w[2] = (user_i[11:8] == lfsr_i[7:4]) | (user_i[11:8] == lfsr_i[3:0]) | (user_i[11:8] == lfsr_i[15:12]);
    assign partial_w[3] = (user_i[15:12] == lfsr_i[7:4]) | (user_i[15:12] == lfsr_i[11:8]) | (user_i[15:12] == lfsr_i[3:0]);
    

    wire [15:0] led;
    assign led[15:12] = (4'hF & {4{correct_w[3]}}) | (4'b0110 & {~partial_w[3], partial_w[3], partial_w[3], ~partial_w[3]}); // Should default to 4 0's if neither true
    assign led[11:8] = (4'hF & {4{correct_w[2]}}) | (4'b0110 & {~partial_w[2], partial_w[2], partial_w[2], ~partial_w[2]});
    assign led[7:4] = (4'hF & {4{correct_w[1]}}) | (4'b0110 & {~partial_w[1], partial_w[1], partial_w[1], ~partial_w[1]});
    assign led[3:0] = (4'hF & {4{correct_w[0]}}) | (4'b0110 & {~partial_w[0], partial_w[0], partial_w[0], ~partial_w[0]});

    FDRE #(.INIT(16'd0)) LED_FF[15:0] (.C({16{clk_i}}), .CE({16{led_en_w}}), .R({16{1'b0}}), .D(led), .Q(led_o));

    assign decrement_o = (WAIT_q & lockin_i & (user_i != lfsr_i));
    assign stareTime = (WAIT_q & lockin_i & (user_i != lfsr_i));
    assign flash_o = WIN_q | LOSE_q;
    assign correct_o = correct_w[3] + correct_w[2] + correct_w[1] + correct_w[0];
    
    // State FFs
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk_i), .CE(1'b1), .R(1'b0), .D(state_d[0]), .Q(state_q[0]));
    FDRE #(.INIT(4'b0000)) Q4_1_FF[4:1] (.C({4{clk_i}}), .CE({4{1'b1}}), .R({4{1'b0}}), .D(state_d[4:1]), .Q(state_q[4:1]));


endmodule
