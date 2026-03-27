///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
// File: top.v
// Description: Top-level wrapper for traffic light controller
// Targeted device: PolarFireSoC MPFS095T FCSG325
// Author: <Name>
///////////////////////////////////////////////////////////////////////////////////////////////////

module top(
    input  wire SYS_CLK,      // 100 MHz oscillator from board
    input  wire rst_n,        // active-low reset button

    // North-South lights
    output wire ns_red,
    output wire ns_yel,
    output wire ns_green,

    // East-West lights
    output wire ew_red,
    output wire ew_yel,
    output wire ew_green
);

    // Instantiate the traffic light controller
    traffic_light # (
        .CLK_FREQ(2_000_000)         // Set clock frequency for PolarFire SoC board
    ) traffic_light_inst (
        .clk      (SYS_CLK),
        .rst_n    (rst_n),

        .ns_red   (ns_red),
        .ns_yel   (ns_yel),
        .ns_green (ns_green),

        .ew_red   (ew_red),
        .ew_yel   (ew_yel),
        .ew_green (ew_green)
    );

endmodule