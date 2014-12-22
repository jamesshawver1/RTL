`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:37:51 11/17/2014
// Design Name:   ShiftReg
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/UART/tb_shift_reg.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ShiftReg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_shift_reg;

	// Inputs
	reg clk_in;
	reg n_reset;
	reg shift;
	reg ld;
	reg [7:0] din;
	reg si;

	// Outputs
	wire so;
	wire [7:0] dout;

	// Instantiate the Unit Under Test (UUT)
	ShiftReg uut (
		.clk_in(clk_in), 
		.n_reset(n_reset), 
		.shift(shift), 
		.ld(ld), 
		.din(din), 
		.si(si), 
		.so(so), 
		.dout(dout)
	);
	
	always begin
		#5 clk_in = !clk_in;
	end

	initial begin
		// Initialize Inputs
		clk_in = 0;
		n_reset = 0;
		shift = 0;
		ld = 0;
		din = 0;
		si = 1;

		// Wait 100 ns for global reset to finish
		#100;
		n_reset=1;
		#10; din = 8'ha5;
		#10 ld = 1;
		#10 ld = 0; shift = 1;
		#100;
		
        
		// Add stimulus here

	end
      
endmodule

