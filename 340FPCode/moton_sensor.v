// FInal working code
`timescale 1ns / 1ps

module motion_sensor(
    input wire clk,           // System clock
    input wire reset,         // Reset signal
    input wire motion_detected, // Motion sensor input (connected to JA1)
    output reg state_motion,  // MOTION state indicator
    output reg state_stable,  // STABLE state indicator
    output reg [15:0] sseg_value // 16-bit value for seven segment display
);

    // State definitions
    parameter MOTION = 1'b0;
    parameter STABLE = 1'b1;
    
    // Seven segment display values for each state
    parameter SSEG_MOTION = 16'h1111;
    parameter SSEG_STABLE = 16'h0000;
    
    // State register
    reg current_state;
    
    // Counter for the 1-second hold time
    reg [31:0] counter;
    
    // 1 second at 100MHz clock
    parameter HOLD_TIME_CYCLES = 100_000_000;
    
    // State update logic with 1-second hold
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STABLE; // Start in STABLE state
            counter <= 0;
        end else begin
            case (current_state)
                MOTION: begin
                    if (motion_detected) begin
                        // If motion is still detected, stay in MOTION and reset counter
                        counter <= 0;
                    end else begin
                        // When motion stops, start counting
                        counter <= counter + 1;
                        
                        // After 1 second of no motion, transition to STABLE
                        if (counter >= HOLD_TIME_CYCLES) begin
                            current_state <= STABLE;
                            counter <= 0;
                        end
                    end
                end
                
                STABLE: begin
                    if (motion_detected) begin
                        // Transition to MOTION immediately when motion is detected
                        current_state <= MOTION;
                        counter <= 0;
                    end
                end
                
                default: current_state <= STABLE; // Default to STABLE state
            endcase
        end
    end
    
    // Output logic - active high as specified
    always @(*) begin
        state_motion = (current_state == MOTION);
        state_stable = (current_state == STABLE);
        
        // Set seven segment display value based on state
        case (current_state)
            MOTION: sseg_value = SSEG_MOTION;
            STABLE: sseg_value = SSEG_STABLE;
            default: sseg_value = SSEG_STABLE;
        endcase
    end

endmodule