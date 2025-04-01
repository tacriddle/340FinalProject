// FInal working code
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2025 01:49:21 AM
// Design Name: 
// Module Name: sseg_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sseg_display(
input wire clk,           // System clock
    input wire reset,         // Reset signal
    input wire [15:0] value,  // 16-bit value to display
    output reg [6:0] seg,     // Seven segment LED segments (active low)
    output reg [3:0] an       // Seven segment display anodes (active low)
);

    // Counter for display refresh
    reg [19:0] refresh_counter = 0;
    wire [1:0] display_select;
    
    // Hexadecimal digit to display
    reg [3:0] current_digit;
    
    // Refresh counter to select the active display and digit
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    
    // Use the 2 MSBs of the counter to select which display to activate
    assign display_select = refresh_counter[19:18];
    
    // Select which digit to display based on the active display
    always @(*) begin
        case (display_select)
            2'b00: current_digit = value[3:0];     // Rightmost digit
            2'b01: current_digit = value[7:4];     // Second digit
            2'b10: current_digit = value[11:8];    // Third digit
            2'b11: current_digit = value[15:12];   // Leftmost digit
            default: current_digit = 4'h0;
        endcase
    end
    
    // Select which display to activate (active low)
    always @(*) begin
        case (display_select)
            2'b00: an = 4'b1110;  // Rightmost digit
            2'b01: an = 4'b1101;  // Second digit
            2'b10: an = 4'b1011;  // Third digit
            2'b11: an = 4'b0111;  // Leftmost digit
            default: an = 4'b1111;
        endcase
    end
    
    // Convert current digit to seven segment pattern (active low)
    always @(*) begin
        case (current_digit)
            4'h0: seg = 7'b1000000; // "0"
            4'h1: seg = 7'b1111001; // "1"
            4'h2: seg = 7'b0100100; // "2"
            4'h3: seg = 7'b0110000; // "3"
            4'h4: seg = 7'b0011001; // "4"
            4'h5: seg = 7'b0010010; // "5"
            4'h6: seg = 7'b0000010; // "6"
            4'h7: seg = 7'b1111000; // "7"
            4'h8: seg = 7'b0000000; // "8"
            4'h9: seg = 7'b0010000; // "9"
            4'hA: seg = 7'b0001000; // "A"
            4'hB: seg = 7'b0000011; // "b"
            4'hC: seg = 7'b1000110; // "C"
            4'hD: seg = 7'b0100001; // "d"
            4'hE: seg = 7'b0000110; // "E"
            4'hF: seg = 7'b0001110; // "F"
            default: seg = 7'b1111111;
        endcase
    end

endmodule
