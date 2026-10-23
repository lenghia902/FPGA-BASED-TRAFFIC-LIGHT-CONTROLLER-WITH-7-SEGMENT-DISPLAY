///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: traffic_fsm.v
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

module traffic_fsm #(
    parameter integer GREEN_TIME = 10,
    parameter integer YELLOW_TIME = 3
    )(
    input wire clk,
    input wire rst_n,
    input wire sec_tick,
  
    
    output reg ns_red,
    output reg ns_yellow,
    output reg ns_green,
    
    output reg ew_red,
    output reg ew_yellow,
    output reg ew_green,
    
    output reg sn_red,
    output reg sn_yellow,
    output reg sn_green,

    output reg we_red,
    output reg we_yellow,
    output reg we_green,

    output wire [6:0] led_7_seg
    );


// state encoding
    typedef enum logic [1:0] {
    S_NS_G=2'b00, 
    S_NS_Y=2'b01, 
    S_EW_G=2'b10, 
    S_EW_Y=2'b11
}   
    state_t;
    state_t state;   //next_state;

    wire cnt_done;
    reg [5:0] max_time;
    

    sec_counter u_cnt (
        .max_time(max_time),
        .clk(clk),
        .rst_n(rst_n),
        .tick(sec_tick),
        .done(cnt_done),
        .led_7_seg(led_7_seg),
        .value() // không can doc gia 
        
);

   // Cap nhat max_time theo trng thái
always @(*) begin
    case (state)
    S_NS_G: max_time = GREEN_TIME;
    S_NS_Y: max_time = YELLOW_TIME;
    S_EW_G: max_time = GREEN_TIME;
    S_EW_Y: max_time = YELLOW_TIME;
    default: max_time = GREEN_TIME;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_NS_G;
    end
    else if (cnt_done) begin
        case (state)
            S_NS_G: state <= S_NS_Y;
            S_NS_Y: state <= S_EW_G;
            S_EW_G: state <= S_EW_Y;
            S_EW_Y: state <= S_NS_G;
            default: state <= S_NS_G;
        endcase
    end
end
// Output logic (Moore) 
always @(*) begin
    ns_red = 0; ns_yellow=0; ns_green=0;
    ew_red = 0; ew_yellow=0; ew_green=0;
    
    sn_red = 0; sn_yellow=0; sn_green=0;
    we_red = 0; we_yellow=0; we_green=0;


    case (state)
        S_NS_G: begin 
                ns_green=1; ew_red=1; 
                sn_green=1; we_red=1;
                end
        S_NS_Y: begin 
                ns_yellow=1; ew_red=1; 
                sn_yellow=1; we_red=1;
                end
        S_EW_G: begin 
                ns_red=1; ew_green=1; 
                sn_red=1; we_green=1;
                end
                
        S_EW_Y: begin 
                ns_red=1; ew_yellow=1; 
                sn_red=1; we_yellow=1;    
                end
    endcase
end

endmodule
// State transition on sec_tick
/*always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_NS_G;
        sec_cnt <= 0;
    end     
    else begin
        if (sec_tick) begin
            if (state == S_NS_G) begin
                if (sec_cnt >= GREEN_TIME-1) begin
                    state <= S_NS_Y;
                    sec_cnt <= 0;
                end     
                else begin
                sec_cnt <= sec_cnt + 1;
                end
            end 
            else if (state == S_NS_Y) begin
                if (sec_cnt >= YELLOW_TIME-1) begin
                    state <= S_EW_G;
                    sec_cnt <= 0;
                end 
                else begin
                    sec_cnt <= sec_cnt + 1;
                end
            end 
            else if (state == S_EW_G) begin
                if (sec_cnt >= GREEN_TIME-1) begin
                    state <= S_EW_Y;
                    sec_cnt <= 0;
                end 
                else begin
                    sec_cnt <= sec_cnt + 1;
                    end
            end 
            else if (state == S_EW_Y) begin
                if (sec_cnt >= YELLOW_TIME-1) begin
                    state <= S_NS_G;
                    sec_cnt <= 0;
                end 
                else begin
                    sec_cnt <= sec_cnt + 1;
                end
            end
        end
    end
end*/
// Output logic (Moore machine) – s?a theo yêu c?u:
// Ðèn 1: xanh ? vàng ? ð? ? xanh...
// Ðèn 2: NGÝ?C L?I


    
//<statements>



