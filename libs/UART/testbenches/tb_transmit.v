`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:45:08 11/17/2014
// Design Name:   TxControl
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/UART/tb_transmit.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TxControl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_transmit;

	// Inputs
	reg clk_in;
	reg enable_in;
	reg n_reset_in;
	reg n_wr_in;
	reg s_num_in;
	reg [31:0] clk_div_baud_in;
	reg [1:0] parity_in;
	reg d_num_in;
	reg [7:0] data_in;

	// Outputs
	wire tx_out;
	wire error_out;
	wire tx_rdy_out;

	// Instantiate the Unit Under Test (UUT)
	TxControl uut (
		.clk_in(clk_in), 
		.enable_in(enable_in), 
		.n_reset_in(n_reset_in), 
		.n_wr_in(n_wr_in), 
		.s_num_in(s_num_in), 
		.clk_div_baud_in(clk_div_baud_in), 
		.parity_in(parity_in), 
		.d_num_in(d_num_in), 
		.data_in(data_in), 
		.tx_out(tx_out), 
		.tx_rdy_out(tx_rdy_out)
	);
	
	always begin
		clk_in = !clk_in; #10; //50MHz clock
	end

	initial begin
		// Initialize Inputs
		clk_in = 0;
		enable_in = 0;
		n_reset_in = 0;
		n_wr_in = 0;
		s_num_in = 0;
		clk_div_baud_in = 5208;
		parity_in = 0;
		d_num_in = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
      n_reset_in=1; 
		#10 data_in = 8'h75; clk_div_baud_in = 5208; enable_in = 1; d_num_in=0; #50 n_wr_in = 1;
		#1500000;
		n_wr_in = 0; #10 data_in = 8'h75; clk_div_baud_in = 5208; enable_in = 1; d_num_in=0; #50 n_wr_in = 1;
		#1500000;
		$stop;
		// Add stimulus here

	end
      
endmodule

