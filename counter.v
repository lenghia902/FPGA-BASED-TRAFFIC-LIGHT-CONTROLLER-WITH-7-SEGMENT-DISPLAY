///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: counter.v
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

module sec_counter #(
//parameter MAX = 10
)(
input wire clk,
input wire rst_n,
input wire tick, // tick 1s clk_divider
input wire [31:0] max_time,
output reg done, // bao chuyen trang thai
output reg [31:0] value,
output reg [6:0] led_7_seg

);
//reg [31:0] counter; 
wire [31:0] display_value;  // Giá tr? hi?n th? = max_time - value - 1

assign display_value = max_time - value - 1;    


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        value <= 0;
        done <= 0;
       
    end 
    else begin
        if (done) begin
            // Load chu ki moi
            value <= 0;
            done <= 0;
        end
        else if (tick) begin
            if (value < max_time - 1) begin
                value <= value + 1;  // Ðem tãng
                done <= 0;
            
            end 
            else begin
                // Ða ðem ðu max_time giây
                done <= 1; //else if (tick) begin
            end
        end
    end
end
            


always @(*) begin
        
        case (display_value[3:0])       
            4'd0: led_7_seg = 7'b0000001; // 0
            4'd1: led_7_seg = 7'b1001111; // 1
            4'd2: led_7_seg = 7'b0010010; // 2
            4'd3: led_7_seg = 7'b0000110; // 3
            4'd4: led_7_seg = 7'b1001100; // 4
            4'd5: led_7_seg = 7'b0100100; // 5
            4'd6: led_7_seg = 7'b0100000; // 6
            4'd7: led_7_seg = 7'b0001111; // 7
            4'd8: led_7_seg = 7'b0000000; // 8
            4'd9: led_7_seg = 7'b0000100; // 9*/
            default: led_7_seg = 7'b1111111; // all off
        endcase
end
endmodule