
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//LED Control module for ECEN 340 Final Project
//////////////////////////////////////////////////////////////////////////////////
module led_control(
    input clk,
    input sw,
    output [4:0] enc,
    output reg [7:0] leds  // Changed to 8 LEDs output
    );

    reg [17:0] sclk;
    reg [7:0] led_reg; // Register to store LED states

    always @(posedge clk)  begin
        // Refresh each LED
        // 0 ms refresh LED pattern 0
        if (sclk == 0) begin
            leds <= led_reg;  // Set LEDs based on encoder value
            sclk <= sclk + 1;
        end

        // 1ms refresh LED pattern 1
        else if (sclk == 100_000) begin
            // Update LED based on encoder value
            sclk <= sclk + 1;
        end

        // 2ms
        else if (sclk == 200_000)
            sclk <= 0;

        // increment counter
        else
            sclk <= sclk + 1;
    end
    
    // Selects the LED pattern based on the encoder value (enc)
    always @(enc[4:0])
        if (sw == 1'b1) begin
            case (enc[4:0])
            5'b00000 : led_reg <= 8'b00000001;  // LED 0 on
            5'b00001 : led_reg <= 8'b00000010;  // LED 1 on
            5'b00010 : led_reg <= 8'b00000100;  // LED 2 on
            5'b00011 : led_reg <= 8'b00001000;  // LED 3 on
            5'b00100 : led_reg <= 8'b00010000;  // LED 4 on
            5'b00101 : led_reg <= 8'b00100000;  // LED 5 on
            5'b00110 : led_reg <= 8'b01000000;  // LED 6 on
            5'b00111 : led_reg <= 8'b10000000;  // LED 7 on
            5'b01000 : led_reg <= 8'b00000011;  // LED 0 and 1 on
            5'b01001 : led_reg <= 8'b00000111;  // LED 0, 1, and 2 on
            5'b01010 : led_reg <= 8'b00001111;  // LED 0, 1, 2, and 3 on
            5'b01011 : led_reg <= 8'b00011111;  // LED 0, 1, 2, 3, and 4 on
            5'b01100 : led_reg <= 8'b00111111;  // LED 0, 1, 2, 3, 4, and 5 on
            5'b01101 : led_reg <= 8'b01111111;  // LED 0, 1, 2, 3, 4, 5, and 6 on
            5'b01110 : led_reg <= 8'b11111111;  // All LEDs on
            default  : led_reg <= 8'b00000000;  // All LEDs off4
            endcase
       end 
       else begin
            led_reg <= 8'b00000000;  // All LEDs off
       end
endmodule