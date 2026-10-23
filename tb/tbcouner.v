`timescale 1ns/1ps

module tb_sec_counter;

    reg clk;
    reg rst_n;
    reg tick;
    reg [31:0] max_time;

    wire done;
    wire [31:0] value;
    wire [6:0] led_7_seg;

    // DUT
    sec_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick),
        .max_time(max_time),
        .done(done),
        .value(value),
        .led_7_seg(led_7_seg)
    );

    //////////////////////////////////////////////
    // Clock 50 MHz (20 ns period)
    //////////////////////////////////////////////
    initial clk = 0;
    always #10 clk = ~clk;

    //////////////////////////////////////////////
    // Tick 1ms (1_000_000 ns) 
    //////////////////////////////////////////////
    initial tick = 0;
    always begin
        #50 tick = 1;   // tick lên
        #20      tick = 0;   
        #50;            
    end

    //////////////////////////////////////////////
    // Test sequence
    //////////////////////////////////////////////
    initial begin
        $display("---- START TEST ----");
        rst_n = 0;
        max_time = 10;    

        #100;
        rst_n = 1;

        // chy mô phng 50 ms
        #50_000_000;

        $display("---- END TEST ----");
        $stop;
    end

    //////////////////////////////////////////////
    // Monitor giá tr?
    //////////////////////////////////////////////
    initial begin
        $monitor("time=%0t  value=%0d  done=%b  led7=%b",
                 $time, value, done, led_7_seg);
    end

endmodule
