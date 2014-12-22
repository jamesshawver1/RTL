`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:51:15 11/19/2014
// Design Name:   bidirec
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/UART/tb_inout.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bidirec
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_inout;

	// Inputs
	reg oe;
	reg clk;
	reg [7:0] inp;

	// Outputs
	wire [7:0] outp;

	// Bidirs
	wire [7:0] bidir;

	// Instantiate the Unit Under Test (UUT)
	bidirec uut (
		.oe(oe), 
		.clk(clk), 
		.inp(inp), 
		.outp(outp), 
		.bidir(bidir)
	);

	always begin
		#5 clk= ~clk;
	end

	initial begin
		// Initialize Inputs
		oe = 0;
		clk = 0;
		inp = 10;
		bidir=5;

		// Wait 100 ns for global reset to finish
		#100;
		#10 oe = 1;
		
		# 10 oe = 0; //bidir = 5;
		#20;
        

		  
		// Add stimulus here

	end
      
endmodule

