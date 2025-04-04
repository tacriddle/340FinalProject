module encoder_top(
    input clk_100MHz,       // 100MHz from Basys 3
    input [7:4] JB,         // PMOD JB
    output [15:8] led
    );
	
	// Internal wires 
	wire [4:0] w_enc;
	wire w_A, w_B;
	 
	// Instantiate Modules
	debounce db(.clk(clk_100MHz), .Ain(JB[4]), .Bin(JB[5]), .Aout(w_A), .Bout(w_B));
 	encoder enc (.clk(clk_100MHz), .A(w_A), .B(w_B), .BTN(JB[6]), .EncOut(w_enc));
 	led_control lights (.clk(clk_100MHz), .sw(JB[7]), .enc(w_enc), .leds(led));

endmodule




