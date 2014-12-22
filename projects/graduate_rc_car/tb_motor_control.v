`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:47:45 12/15/2014
// Design Name:   MotorControl
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/graduate_rc_car/tb_motor_control.v
// Project Name:  graduate_rc_car
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MotorControl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_motor_control;

	// Inputs
	reg [7:0] data_in;
	reg clk_in;
	reg reset_in;

	// Outputs
	wire m1_direction_out;
	wire m2_direction_out;
	wire [7:0] m1_speed_out;
	wire [7:0] m2_speed_out;

	// Instantiate the Unit Under Test (UUT)
	MotorControl uut (
		.data_in(data_in), 
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.m1_direction_out(m1_direction_out), 
		.m2_direction_out(m2_direction_out), 
		.m1_speed_out(m1_speed_out), 
		.m2_speed_out(m2_speed_out)
	);

	always #5 clk_in = ~clk_in;
	initial begin
		// Initialize Inputs
		data_in = 0;
		clk_in = 0;
		reset_in = 0;

		// Wait 100 ns for global reset to finish
		#100; reset_in = 1; #10 reset_in = 0;
		
		#100; data_in = 128;
		#100; data_in = 1;
		#100; data_in = 128;
		#100; data_in = 2;
		#100; data_in = 128;
		#100; data_in = 128;
        
		// Add stimulus here

	end
      
endmodule

