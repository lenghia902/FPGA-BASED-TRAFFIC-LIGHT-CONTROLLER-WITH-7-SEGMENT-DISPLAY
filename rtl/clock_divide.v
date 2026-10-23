///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: clock_divide.v
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

module clk_divider #(
    parameter integer DIV = 50000000
)(
    input wire clk,
    input wire rst_n,
    output reg tick
);
// counter width ð ln
    localparam WIDTH = $clog2(DIV+1);
    reg [WIDTH-1:0] cnt;


always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
    cnt <= 0;
    tick <= 0;
   end 
   else begin
        if (cnt == DIV-1) begin
            cnt <= 0;
            tick <= 1'b1;
        end 
        else begin
            cnt <= cnt + 1'b1;
            tick <= 1'b0;
        end
    end
end
endmodule

