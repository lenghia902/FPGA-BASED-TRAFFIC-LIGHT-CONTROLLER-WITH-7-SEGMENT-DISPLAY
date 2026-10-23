///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: top_module.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFireSoC> <Die::MPFS095T> <Package::FCSG325>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module top_module #( 
parameter CLK_FREQ = 50000000, // board oscillator (Hz) — ch?nh n?u khác
parameter GREEN_TIME = 10, // giây — th?i gian ðèn xanh m?i hý?ng
parameter YELLOW_TIME = 3 // giây — th?i gian ðèn vàng
)(
input wire clk, // board clock
input wire rst_n, // active-low reset (tied to MSS reset / button)


// Outputs: các tín hieu led cho 4 hýong (NS = North-South, EW = East-West)
output wire ns_red,
output wire ns_yellow,
output wire ns_green,

output wire ew_red,
output wire ew_yellow,
output wire ew_green,

output wire sn_red,
output wire sn_yellow,
output wire sn_green,

output wire we_red,
output wire we_yellow,
output wire we_green,

output wire [6:0] led_7_seg
);


// Clock divider: tao tick moi 1 giây
localparam integer DIV_FACTOR = CLK_FREQ; //


wire sec_tick;
clk_divider #(.DIV(DIV_FACTOR)) u_clkdiv (
    .clk(clk),
    .rst_n(rst_n),
    .tick(sec_tick)
);


// FSM controller
traffic_fsm #(
    .GREEN_TIME(GREEN_TIME),
    .YELLOW_TIME(YELLOW_TIME)
) u_fsm (
    .clk(clk),
    .rst_n(rst_n),
    .sec_tick(sec_tick),
    
    .ns_red(ns_red),
    .ns_yellow(ns_yellow),
    .ns_green(ns_green),
    
    .ew_red(ew_red),
    .ew_yellow(ew_yellow),
    .ew_green(ew_green),
    
    .sn_red(sn_red),
    .sn_yellow(sn_yellow),
    .sn_green(sn_green),
    
    .we_red(we_red),
    .we_yellow(we_yellow),
    .we_green(we_green),
    
    .led_7_seg(led_7_seg)
);


endmodule

