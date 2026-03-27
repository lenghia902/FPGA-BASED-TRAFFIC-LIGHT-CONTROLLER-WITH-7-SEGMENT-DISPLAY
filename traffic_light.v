///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: traffic_light.v
// Description: Traffic light controller for NS/EW directions
// Targeted device: PolarFireSoC MPFS095T FCSG325
// Author: <Name>
///////////////////////////////////////////////////////////////////////////////////////////////////

module traffic_light(
    input  wire clk,
    input  wire rst_n,              // active-low reset

    // outputs for North-South direction
    output reg ns_red,
    output reg ns_yel,
    output reg ns_green,

    // outputs for East-West direction
    output reg ew_red,
    output reg ew_yel,
    output reg ew_green
);

    
    parameter CLK_FREQ    = 2000000; // board oscillator frequency in Hz
    parameter GREEN_SEC   = 10;
    parameter YELLOW_SEC  = 3;
    parameter ALL_RED_SEC = 1;        // safety all-red interval if desired

    // Convert seconds to clock cycles
    localparam [31:0] GREEN_CYC  = GREEN_SEC  * CLK_FREQ;
    localparam [31:0] YELLOW_CYC = YELLOW_SEC * CLK_FREQ;
    localparam [31:0] ALLRED_CYC = ALL_RED_SEC * CLK_FREQ;

    // States
    localparam [2:0] S_NS_GREEN = 3'd0;
    localparam [2:0] S_NS_YEL   = 3'd1;
    localparam [2:0] S_ALL_RED1 = 3'd2;
    localparam [2:0] S_EW_GREEN = 3'd3;
    localparam [2:0] S_EW_YEL   = 3'd4;
    localparam [2:0] S_ALL_RED2 = 3'd5;

    // State and counter
    reg [2:0] state, next_state;
    reg [31:0] counter; // 32-bit counter

    // Timer load value based on current state
    reg [31:0] timer_load;

    always @(*) begin
        case (state)
            S_NS_GREEN:  timer_load = GREEN_CYC;
            S_NS_YEL:    timer_load = YELLOW_CYC;
            S_ALL_RED1:  timer_load = ALLRED_CYC;
            S_EW_GREEN:  timer_load = GREEN_CYC;
            S_EW_YEL:    timer_load = YELLOW_CYC;
            S_ALL_RED2:  timer_load = ALLRED_CYC;
            default:     timer_load = GREEN_CYC;
        endcase
    end

    // State register and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_NS_GREEN;
            counter <= GREEN_CYC;  // <=0
        end 
        else begin
            if (
            counter == 0) begin
                state = next_state;
                counter = timer_load;
            end 
            else begin
                counter <= counter - 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_NS_GREEN: next_state = S_NS_YEL;
            S_NS_YEL:   next_state = S_ALL_RED1;
            S_ALL_RED1: next_state = S_EW_GREEN;
            S_EW_GREEN: next_state = S_EW_YEL;
            S_EW_YEL:   next_state = S_ALL_RED2;
            S_ALL_RED2: next_state = S_NS_GREEN;
            default:    next_state = S_NS_GREEN;
        endcase
    end

    // Outputs based on state
    always @(*) begin
        // Default all off
        ns_red   = 0; ns_yel   = 0; ns_green = 0;
        ew_red   = 0; ew_yel   = 0; ew_green = 0;

        case (state)
            S_NS_GREEN: begin ns_green = 1; ew_red   = 1; end
            S_NS_YEL:   begin ns_yel   = 1; ew_red   = 1; end
            S_ALL_RED1: begin ns_red   = 1; ew_red   = 1; end
            S_EW_GREEN: begin ew_green = 1; ns_red   = 1; end
            S_EW_YEL:   begin ew_yel   = 1; ns_red   = 1; end
            S_ALL_RED2: begin ew_red   = 1; ns_red   = 1; end
        endcase
    end

endmodule


// 