`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:00:20 11/18/2014
// Design Name:   RxControl
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/UART/tb_receive.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RxControl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_receive;

	// Inputs
	reg clk_in;
	reg enable_in;
	reg n_reset_in;
	
	reg s_num_in_tx;
	reg [1:0] parity_in_tx;
	
	reg s_num_in_rx;
	reg [1:0] parity_in_rx;
	
	reg [31:0] clk_div_baud_in;
	
	reg d_num_in;
	reg d_num_in_tx;
	wire tx_out;

	// Outputs
	wire [7:0] data_out;
	
	wire frame_error_out;
	wire parity_error_out;
	wire overrun_error_out;
	
	wire rx_rdy_out;

	integer i;
	reg [7:0] data_in;
	reg n_wr_in;
	reg n_rd_in;

	// Instantiate the Unit Under Test (UUT)
	RxControl rx (
		.clk_in(clk_in), 
		.n_rd_in(n_rd_in),
		.enable_in(enable_in), 
		.n_reset_in(n_reset_in), 
		.s_num_in(s_num_in_rx), 
		.clk_div_baud_in(clk_div_baud_in), 
		.parity_in(parity_in_rx), 
		.d_num_in(d_num_in), 
		.rx_in(tx_out), 
		.data_out(data_out), 
		.frame_error_out(frame_error_out), 
		.parity_error_out(parity_error_out), 
		.overrun_error_out(overrun_error_out), 
		.rx_rdy_out(rx_rdy_out)
	);

	TxControl tx (
		.clk_in(clk_in), 
		.enable_in(enable_in), 
		.n_reset_in(n_reset_in), 
		.n_wr_in(n_wr_in), 
		.s_num_in(s_num_in_tx), 
		.clk_div_baud_in(clk_div_baud_in), 
		.parity_in(parity_in_tx), 
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
		enable_in = 1;
		n_reset_in = 0;
		n_wr_in = 1;
		n_rd_in = 1;
		s_num_in_rx = 0;
		s_num_in_tx = 1;
		clk_div_baud_in = 5208;
		parity_in_rx = 3;
		parity_in_tx = 3;
		d_num_in = 0;
		d_num_in_tx = 1;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		//Testing Data in all types
		for(i = 0; i < 16; i = i + 1) begin
			n_reset_in=0; #10 {parity_in_tx,s_num_in_tx,d_num_in_tx} = i; #10 n_reset_in = 1;
			#10 n_wr_in = 1;
			while(~tx_rdy_out)#1; #2 n_wr_in = 0; n_rd_in = 1; #100 n_wr_in = 1;
			@(posedge rx_rdy_out); n_rd_in = 0; data_in = i; while(~tx_rdy_out)#1;
			
		end		

		$stop;
		// Add stimulus here

	end
      
endmodule

