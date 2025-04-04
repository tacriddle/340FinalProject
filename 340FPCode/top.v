`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 01:18:15 PM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input SW,                  
    inout TMP_SDA,
    input motion_detected,
    input [7:4] JB,           
    output [15:0] LED,        
    output [6:0] SEG,         
    output [3:0] AN,          
    output TMP_SCL  
);
    
    
Temp2Top I1 (
    .clk_100MHz(clk),
    .SW(SW),
    .TMP_SDA(TMP_SDA),
    .TMP_SCL(TMP_SCL),
    .LED(LED[7:0])
);

motion_sensor_top I2(
    .clk(clk),
    .JA1(motion_detected),
    .seg(SEG),
    .an(AN)
);

encoder_top I3(
    .clk_100MHz(clk),
    .JB(JB),          
    .led(LED[15:8])
);
    
    
endmodule
