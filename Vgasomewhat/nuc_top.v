`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Top module for Nuclear Display
//////////////////////////////////////////////////////////////////////////////////
module nuclear_top(
    input clk_100MHz,
    input reset,
    input [11:0] sw,
    output hsync,
    output vsync,
    output [11:0] rgb
);

    // Simply connect the display module
    simple_nuclear_display display(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .sw(sw),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

endmodule