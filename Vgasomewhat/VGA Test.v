`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Very Simple Nuclear Monitoring Display
// Creates a static display similar to the image with minimal code
//////////////////////////////////////////////////////////////////////////////////
module simple_nuclear_display(
    input clk_100MHz,      // from Basys 3
    input reset,
    input [11:0] sw,       // 12 bits for color (optional for testing)
    output hsync, 
    output vsync,
    output [11:0] rgb      // 12 FPGA pins for RGB(4 per color)
);
    
    // Signal Declaration
    wire video_on;         // Video enable signal from controller
    wire p_tick;           // Pixel tick for synchronization
    wire [9:0] x, y;       // Current pixel coordinates
    reg [11:0] rgb_reg;    // Register for RGB output
    
    // Color definitions (4 bits per color: RRRR GGGG BBBB)
    localparam BLACK       = 12'h000;
    localparam WHITE       = 12'hFFF;
    localparam YELLOW      = 12'hFF0;
    localparam GREEN       = 12'h0F0;
    localparam DARK_GREEN  = 12'h080;
    localparam RED         = 12'hF00;
    
    // Display layout constants
    localparam DISPLAY_X = 120;       // Left position of display
    localparam DISPLAY_Y = 110;       // Top position of display
    localparam DISPLAY_WIDTH = 400;   // Width of the display
    localparam DISPLAY_HEIGHT = 260;  // Height of the display
    
    // Instantiate VGA Controller
    vga_controller vga_c(
        .clk_100MHz(clk_100MHz), 
        .reset(reset), 
        .video_on(video_on), 
        .hsync(hsync), 
        .vsync(vsync), 
        .p_tick(p_tick), 
        .x(x), 
        .y(y)
    );
    
    // RGB Buffer for display
    always @(posedge clk_100MHz or posedge reset)
    begin
        if (reset)
            rgb_reg <= BLACK;
        else if (p_tick) begin
            // Default background
            rgb_reg <= BLACK;
            
            if (video_on) begin
                // Yellow display area
                if (x >= DISPLAY_X && x < DISPLAY_X + DISPLAY_WIDTH && 
                    y >= DISPLAY_Y && y < DISPLAY_Y + DISPLAY_HEIGHT) begin
                    
                    // Green border
                    if (x < DISPLAY_X + 3 || x >= DISPLAY_X + DISPLAY_WIDTH - 3 ||
                        y < DISPLAY_Y + 3 || y >= DISPLAY_Y + DISPLAY_HEIGHT - 3) begin
                        rgb_reg <= GREEN;
                    end
                    // Horizontal divider (at y=170)
                    else if (y >= DISPLAY_Y + 60 && y < DISPLAY_Y + 63) begin
                        rgb_reg <= GREEN;
                    end
                    // Horizontal divider (at y=320)
                    else if (y >= DISPLAY_Y + 210 && y < DISPLAY_Y + 213) begin
                        rgb_reg <= GREEN;
                    end
                    // Vertical divider
                    else if (x >= DISPLAY_X + DISPLAY_WIDTH/2 - 1 && 
                             x < DISPLAY_X + DISPLAY_WIDTH/2 + 2 &&
                             y >= DISPLAY_Y + 63 && y < DISPLAY_Y + 210) begin
                        rgb_reg <= GREEN;
                    end
                    // Nuclear symbol (simple circle)
                    else if ((x-DISPLAY_X-340)*(x-DISPLAY_X-340) + (y-DISPLAY_Y-30)*(y-DISPLAY_Y-30) <= 225 &&
                             (x-DISPLAY_X-340)*(x-DISPLAY_X-340) + (y-DISPLAY_Y-30)*(y-DISPLAY_Y-30) >= 100) begin
                        rgb_reg <= BLACK;
                    end
                    // Temperature box
                    else if (x >= DISPLAY_X + 50 && x < DISPLAY_X + 150 &&
                             y >= DISPLAY_Y + 100 && y < DISPLAY_Y + 150) begin
                        rgb_reg <= BLACK;
                    end
                    // Intrusion box
                    else if (x >= DISPLAY_X + 250 && x < DISPLAY_X + 350 &&
                             y >= DISPLAY_Y + 100 && y < DISPLAY_Y + 150) begin
                        rgb_reg <= BLACK;
                    end
                    // Controller indicators
                    else if (y >= DISPLAY_Y + 225 && y < DISPLAY_Y + 240) begin
                        // Red indicator
                        if (x >= DISPLAY_X + 50 && x < DISPLAY_X + 80) begin
                            rgb_reg <= RED;
                        end
                        // Green indicators
                        else if ((x >= DISPLAY_X + 90 && x < DISPLAY_X + 120) ||
                                 (x >= DISPLAY_X + 130 && x < DISPLAY_X + 160) ||
                                 (x >= DISPLAY_X + 170 && x < DISPLAY_X + 200) ||
                                 (x >= DISPLAY_X + 210 && x < DISPLAY_X + 240) ||
                                 (x >= DISPLAY_X + 250 && x < DISPLAY_X + 280) ||
                                 (x >= DISPLAY_X + 290 && x < DISPLAY_X + 320) ||
                                 (x >= DISPLAY_X + 330 && x < DISPLAY_X + 360)) begin
                            rgb_reg <= DARK_GREEN;
                        end
                        else begin
                            rgb_reg <= YELLOW;
                        end
                    end
                    // Title text "Nuclear Norris"
                    else if (y >= DISPLAY_Y + 20 && y < DISPLAY_Y + 40 &&
                             x >= DISPLAY_X + 50 && x < DISPLAY_X + 250) begin
                        rgb_reg <= BLACK;
                    end
                    // "TC JB" label
                    else if (y >= DISPLAY_Y + 15 && y < DISPLAY_Y + 45 &&
                             x >= DISPLAY_X + 360 && x < DISPLAY_X + 390) begin
                        rgb_reg <= BLACK;
                    end
                    // Background
                    else begin
                        rgb_reg <= YELLOW;
                    end
                end
                // Green status light
                else if (x >= DISPLAY_X + DISPLAY_WIDTH + 10 &&
                         x < DISPLAY_X + DISPLAY_WIDTH + 20 &&
                         y >= DISPLAY_Y + 200 &&
                         y < DISPLAY_Y + 210) begin
                    rgb_reg <= GREEN;
                end
            end
        end
    end
    
    // Output
    assign rgb = (video_on) ? rgb_reg : 12'b0;
        
endmodule