// FInal working code
`timescale 1ns / 1ps

module motion_sensor_top(
    input clk,              // 100MHz system clock
    input reset,            // Reset button
    input JA1,              // Motion sensor input connected to JA1 Pmod connector 
    output [1:0] led,       // 2 LEDs for state indication
    output [6:0] seg,       // Seven segment display segments
    output [3:0] an         // Seven segment display anodes
);

    // State outputs
    wire state_motion;
    wire state_stable;
    
    // Value for seven segment display
    wire [15:0] sseg_value;
    
    // Instantiate the motion sensor module
    motion_sensor sensor(
        .clk(clk),
        .reset(reset),
        .motion_detected(JA1),     // Connect JA1 to motion_detected input
        .state_motion(state_motion),
        .state_stable(state_stable),
        .sseg_value(sseg_value)    // Connect to seven segment value
    );
    
    // Instantiate the seven segment display controller
    sseg_display display(
        .clk(clk),
        .reset(reset),
        .value(sseg_value),
        .seg(seg),
        .an(an)
    );
    
    // Connect states to LEDs
    assign led[0] = state_motion;
    assign led[1] = state_stable;
    
endmodule