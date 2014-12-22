`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:13:15 12/15/2014
// Design Name:   Motor
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/graduate_rc_car/tb_motor.v
// Project Name:  graduate_rc_car
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Motor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_motor;

	// Inputs
	reg clk_in;
	reg reset_in;
	reg [7:0] speed;
	reg direction;

	// Outputs
	wire motor_plus;
	wire motor_minus;

	// Instantiate the Unit Under Test (UUT)
	Motor #(.CLK_DIV(50))
	uut (
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.speed(speed), 
		.direction(direction), 
		.motor_plus(motor_plus), 
		.motor_minus(motor_minus)
	);
always #5 clk_in = ~clk_in;
	initial begin
		clk_in = 0;
		reset_in = 0;
		speed = 0;
		direction = 0;

		// Wait 100 ns for global reset to finish
		#100; reset_in = 1; #10 reset_in = 0;
		
		#500000 speed = 25; direction = 1;
		#500000 speed = 200; direction = 0;
		#500000;
		
		$stop;
        
		// Add stimulus here

	end
      
endmodule

