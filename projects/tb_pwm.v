`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:19:57 12/15/2014
// Design Name:   Pwm
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/graduate_rc_car/tb_pwm.v
// Project Name:  graduate_rc_car
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Pwm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_pwm;

	// Inputs
	reg clk_in;
	reg reset_in;
	reg [7:0] duty_cycle_in;

	// Outputs
	wire pwm_out;

	// Instantiate the Unit Under Test (UUT)
	Pwm  #(.CLK_DIV(50)) pwm
	(
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.duty_cycle_in(duty_cycle_in), 
		.pwm_out(pwm_out)
	);

	always #5 clk_in = ~clk_in;

	initial begin
		// Initialize Inputs
		clk_in = 0;
		reset_in = 0;
		duty_cycle_in = 128;

		// Wait 100 ns for global reset to finish
		#100; reset_in = 1; #10 reset_in = 0;
		
		#500000 duty_cycle_in = 25;
		#500000 duty_cycle_in = 200;
		#500000;
		
		$stop;
      
		// Add stimulus here

	end
      
endmodule

