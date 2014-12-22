`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:41:44 11/19/2014
// Design Name:   CpuIfBlock
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/UART/tb_cpu_if.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CpuIfBlock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_cpu_if;

	// Inputs
	reg n_CS;
	reg C_nD;
	reg n_WR;
	reg n_RD;
	reg CLK50M;
	reg n_RST;
	reg [7:0] rx_data_in;

	wire n_rd_out;
	wire n_wr_out;

	// Outputs
	wire n_INT;
	wire Tx_RDY;
	wire Rx_RDY;
	wire [7:0] tx_data_out;
	wire [1:0] parity;
	wire extra_stop_bit;
	wire break_en;
	wire eight_data_bits;
	wire [31:0] clk_div_baud_out;
	wire rx_rdy_en;
	wire tx_rdy_en;
	wire internal_reset;
	
	
	reg frame_error_in;
	reg parity_error_in;
	reg overrun_error_in;
	
	reg tx_rdy_in;
	reg rx_rdy_in;

	// Bidirs
	reg [7:0] DATA_in;
	wire [7:0] DATA_out;

	// Instantiate the Unit Under Test (UUT)
	CpuIfBlock uut (
		.n_CS(n_CS), 
		.DATA_in(DATA_in), 
		.DATA_out(DATA_out), 
		.C_nD(C_nD), 
		.n_WR(n_WR), 
		.n_RD(n_RD), 
		.n_INT(n_INT), 
		.CLK50M(CLK50M), 
		.n_RST(n_RST), 
		.Tx_RDY(Tx_RDY), 
		.Rx_RDY(Rx_RDY), 
		.tx_data_out(tx_data_out), 
		.rx_data_in(rx_data_in), 
		.parity(parity), 
		.extra_stop_bit(extra_stop_bit), 
		.eight_data_bits(eight_data_bits), 
		.clk_div_baud_out(clk_div_baud_out), 
		.rx_rdy_en(rx_rdy_en), 
		.tx_rdy_en(tx_rdy_en), 
		.break_en(break_en),

		
		.n_rd_out(n_rd_out),
		.n_wr_out(n_wr_out),
				
		.frame_error_in(frame_error_in),
		.parity_error_in(parity_error_in),
		.overrun_error_in(overrun_error_in),
		
		.tx_rdy_in(tx_rdy_in),
		.rx_rdy_in(rx_rdy_in),
		
		.n_external_reset(internal_reset)
	);

	always begin
		#5 CLK50M = ~CLK50M;
	end

	initial begin
		// Initialize Inputs
		n_CS = 0;
		frame_error_in=1;
		parity_error_in=1;
		overrun_error_in=1;
		
		tx_rdy_in=1;
		rx_rdy_in=1;
		
		C_nD = 1; n_RD = 1; n_WR = 0;
		
		
		CLK50M = 0;
		n_RST = 0;
		rx_data_in = 15;

		// Wait 100 ns for global reset to finish
		#100;
		
		DATA_in = 8'b00111111; #10 n_RST = 0; #10 n_RST = 1; 
		#10 DATA_in = 8'b00111111;
		#10 C_nD = 0; n_RD = 0; n_WR = 1;
      #10 C_nD = 0; n_RD = 1; n_WR = 0;  
		
		#100;
		
		
		$stop;
		// Add stimulus here

	end
      
endmodule

