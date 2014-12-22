`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:14:43 11/20/2014
// Design Name:   UART
// Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/UART/tb_uart.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_uart;

	// Inputs
	reg CLK50M;
	reg n_RST;
	reg [7:0] DATA_in;
	reg n_RD;
	reg n_WR;
	reg C_nD;
	reg n_CS;

	// Outputs
	wire [7:0] DATA_out;
	wire n_INT;
	wire Tx_RDY;
	wire Rx_RDY;
	wire tx;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	UART uut (
		.CLK50M(CLK50M), 
		.n_RST(n_RST), 
		.DATA_in(DATA_in), 
		.DATA_out(DATA_out), 
		.n_RD(n_RD), 
		.n_WR(n_WR), 
		.C_nD(C_nD), 
		.n_CS(n_CS), 
		.n_INT(n_INT), 
		.Tx_RDY(Tx_RDY), 
		.Rx_RDY(Rx_RDY), 
		.rx(tx), 
		.tx(tx)
	);

	always begin
		#5 CLK50M = ~CLK50M;
	end
	initial begin
		// Initialize Inputs
		CLK50M = 0;
		n_RST = 0;
		DATA_in = 0;
		n_CS = 0;
		C_nD = 1; n_RD = 1; n_WR = 0;
		// Wait 100 ns for global reset to finish
		#100;
    		
		DATA_in = 8'b00111111; #10 n_RST = 0; #100 n_RST = 1; 
		#10 DATA_in = 8'b00111111;
		@(posedge CLK50M);@(posedge CLK50M);
		for(i = 0; i < 10; i = i + 1) begin
			#10 C_nD = 0; n_RD = 0; n_WR = 1; #10 DATA_in = i;
			#10 C_nD = 0; n_RD = 1;
			$display("before ready tx");
			#100; n_WR = 0;  
			$display("after ready tx");
			@(posedge Rx_RDY); n_WR = 1; #1000;
			C_nD = 0; n_RD = 0; n_WR = 1; #10 ;
			
		end
		
		#10 DATA_in = 8'b10111111;
		#10 C_nD = 1; n_RD = 1; n_WR = 0; //loading break
		
		for(i = 0; i < 10; i = i + 1) begin
			#10 C_nD = 0; n_RD = 0; n_WR = 1; #10 DATA_in = i;
			#10 C_nD = 0; n_RD = 1;
			#1000; n_WR = 0;  
			@(posedge Rx_RDY); n_WR = 1; #1000;
			C_nD = 0; n_RD = 0; n_WR = 1; #10 ;
		end
		$stop;
	end
      
endmodule

