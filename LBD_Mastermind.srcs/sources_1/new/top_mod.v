`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2024 10:12:13 AM
// Design Name: 
// Module Name: top_mod
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


module top_mod(
    input clkin,
    input btnR,
    input btnU,
    input btnD,
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg
    );
    
    wire clk_i, digsel, qsec;
    qsec_clks slow (.clkin(clkin), .greset(btnR), .clk(clk_i), .digsel(digsel), .qsec(qsec));
    
    
    wire go_w, flash_w, lockin_w;
    EdgeDetector ED_go_inst(.clk_i(clk_i), .in_i(btnU), .out_o(go_w)); //Edge Detect so only high for 1 cycle
    EdgeDetector ED_sel_inst(.clk_i(clk_i), .in_i(btnD), .out_o(lockin_w)); //Edge Detect so only high for 1 cycle
    
    wire [7:0] temp_upper_w, temp_lower_w, LFSR_Upper_w, LFSR_Lower_w;
    LFSR LFSR_upper_inst(.clk_i(clk_i), .Q_o(temp_upper_w));
    LFSR LFSR_lower_inst(.clk_i(clk_i), .Q_o(temp_lower_w));
    
    //Save LFSR values when go_w
    FDRE # (.INIT(8'b00000000)) LFSR_Upper_FF [7:0] (.C(clk_i), .R({8{1'b0}}), .CE({8{go_w}}), .D(temp_upper_w), .Q(LFSR_Upper_w));
    FDRE # (.INIT(8'b00000000)) LFSR_Lower_FF [7:0] (.C(clk_i), .R({8{1'b0}}), .CE({8{go_w}}), .D(temp_lower_w), .Q(LFSR_Lower_w));
    
    wire [3:0] attempts_w;
    wire [1:0] correct_w;
    MastermindSM MMSM_inst (.clk_i(clk_i), .user_i(sw), .lfsr_i({LFSR_Upper_w, LFSR_Lower_w}), .go_i(go_w), .led_o(led), .attempts_o(attempts_w), 
    .correct_o(correct_w), .lockin_i(lockin_w), .flash_o(flash_w));
    
    
    wire [1:0] ring_w;
    RingCounter RC_inst(.clk_i(clk_i), .ring_o(ring_w));
    
    wire [3:0] sel_o;
    Selector S_inst(.a_i({attempts_w, 2'b00, correct_w}), .sel_i(ring_w), .y_o(sel_o));
    
    hex7seg hex7seg_inst(.n(sel_o), .seg(seg));
    
    
    assign an[3] = ring_w[1] | (flash_w & qsec); //qsec is probably too fast, should make it slower
    assign an[0] = ring_w[0] | (flash_w & qsec);
endmodule
