///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: testbench_trafic.v
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

`timescale 1ns/1ps
module tb_traffic;
reg clk;
reg rst_n;


wire ns_r, ns_y, ns_g, ew_r, ew_y, ew_g,
     sn_r, sn_y, sn_g, we_r, we_y, we_g;

        
// Instantiate top with shorter times for simulation
top_module #(.CLK_FREQ(10), .GREEN_TIME(10), .YELLOW_TIME(3)) DUT (
    .clk(clk), .rst_n(rst_n),
    .ns_red(ns_r), .ns_yellow(ns_y), .ns_green(ns_g),
    .ew_red(ew_r), .ew_yellow(ew_y), .ew_green(ew_g),
    .sn_red(sn_r), .sn_yellow(sn_y), .sn_green(sn_g),
    .we_red(we_r), .we_yellow(we_y), .we_green(we_g)
);


initial begin
    clk = 0; rst_n = 0;
    #20 rst_n = 1;
end


always #5 clk = ~clk;   


initial begin
// run simulation cho mot khoang thoi gian
#2000 $finish;
end




endmodule

