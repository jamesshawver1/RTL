`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sunburst Design
// Engineer: Clifford E. Cummings / James Shawver
// 
// Create Date:    09:51:10 11/03/2014 
// Design Name: 
// Module Name:    sunburst_fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Original Design was from Sunburst Design and by Clifford E. Cummings. 
// Modified in order to fit this assignment. 
//////////////////////////////////////////////////////////////////////////////////
module AFifo #(parameter data_width = 8, parameter ptr_width = 4)
(
	output [data_width-1:0] rd_data,
	output full_flag,
	output empty_flag,
	input [data_width-1:0] wr_data,
	input wr_en, wr_clk, rst_n,
	input rd_en, rd_clk 
);
	wire [ptr_width-1:0] wr_addr, rd_addr;
	wire [ptr_width:0] wr_ptr, rd_ptr, rd_ptr_sync, wr_ptr_sync;
	
	read_to_write_sync read_to_write_sync 
	(
		.rd_ptr_sync(rd_ptr_sync), 
		.rd_ptr(rd_ptr),
		.wr_clk(wr_clk), 
		.wrst_n(rst_n)
	);
	write_to_read_sync write_to_read_sync (
		.wr_ptr_sync(wr_ptr_sync), 
		.wr_ptr(wr_ptr),
		.rd_clk(rd_clk), 
		.rrst_n(rst_n)
	);
	mem_buff #(data_width, ptr_width) mem_buff
	(
		.rd_data(rd_data), 
		.wr_data(wr_data),
		.wr_addr(wr_addr), 
		.rd_addr(rd_addr),
		.wr_clken(wr_en), 
		.full_flag(full_flag),
		.wr_clk(wr_clk)
	);
	rd_ctrl #(ptr_width) rd_ctrl
	(
		.empty_flag(empty_flag),
		.rd_addr(rd_addr),
		.rd_ptr(rd_ptr), 
		.wr_ptr_sync(wr_ptr_sync),
		.rd_en(rd_en), 
		.rd_clk(rd_clk),
		.rrst_n(rst_n)
	);
	wr_ctrl #(ptr_width) wr_ctrl
	(
		.full_flag(full_flag), 
		.wr_addr(wr_addr),
		.wr_ptr(wr_ptr), 
		.rd_ptr_sync(rd_ptr_sync),
		.wr_en(wr_en), 
		.wr_clk(wr_clk),
		.wrst_n(rst_n)
	);
endmodule 

module mem_buff #(parameter DATASIZE = 8, parameter ADDRSIZE = 4) // Number of mem address bits
(
	output [DATASIZE-1:0] rd_data,
	input [DATASIZE-1:0] wr_data,
	input [ADDRSIZE-1:0] wr_addr, rd_addr,
	input wr_clken, full_flag, wr_clk
);
	// RTL Verilog memory model
	localparam DEPTH = 1<<ADDRSIZE;
	reg [DATASIZE-1:0] mem [0:DEPTH-1];
	assign rd_data = mem[rd_addr];
	always @(posedge wr_clk)
		if (wr_clken && !full_flag) mem[wr_addr] <= wr_data;
endmodule


module read_to_write_sync #(parameter ADDRSIZE = 4)
(
	output reg [ADDRSIZE:0] rd_ptr_sync,
	input [ADDRSIZE:0] rd_ptr,
	input wr_clk, wrst_n
);
	reg [ADDRSIZE:0] wq1_rd_ptr;
	always @(posedge wr_clk or negedge wrst_n)
		if (!wrst_n) {rd_ptr_sync,wq1_rd_ptr} <= 0;
		else {rd_ptr_sync,wq1_rd_ptr} <= {wq1_rd_ptr,rd_ptr};
endmodule

module write_to_read_sync #(parameter ADDRSIZE = 4)
(
	output reg [ADDRSIZE:0] wr_ptr_sync,
	input [ADDRSIZE:0] wr_ptr,
	input rd_clk, rrst_n
);
	reg [ADDRSIZE:0] rq1_wr_ptr;
	always @(posedge rd_clk or negedge rrst_n)
		if (!rrst_n) {wr_ptr_sync,rq1_wr_ptr} <= 0;
		else {wr_ptr_sync,rq1_wr_ptr} <= {rq1_wr_ptr,wr_ptr};
endmodule


module rd_ctrl #(parameter ADDRSIZE = 4)
(
	output reg empty_flag,
	output [ADDRSIZE-1:0] rd_addr,
	output reg [ADDRSIZE :0] rd_ptr,
	input [ADDRSIZE :0] wr_ptr_sync,
	input rd_en, rd_clk, rrst_n
);
	reg [ADDRSIZE:0] rbin;
	wire [ADDRSIZE:0] rgraynext, rbinnext;
		
	//-------------------
	// GRAYSTYLE2 pointer
	//-------------------
	always @(posedge rd_clk or negedge rrst_n)
		if (!rrst_n) {rbin, rd_ptr} <= 0;
		else {rbin, rd_ptr} <= {rbinnext, rgraynext};

	// Memory read-address pointer (okay to use binary to address memory)
	assign rd_addr = rbin[ADDRSIZE-1:0];
	assign rbinnext = rbin + (rd_en & ~empty_flag);
	
	//gray_counter module merged in here. 
	assign rgraynext = (rbinnext>>1) ^ rbinnext;
	//---------------------------------------------------------------
	// FIFO empty when the next rd_ptr == synchronized wr_ptr or on reset
	//---------------------------------------------------------------
	assign empty_flag_val = (rgraynext == wr_ptr_sync);
	
	always @(posedge rd_clk or negedge rrst_n)
		if (!rrst_n) empty_flag <= 1'b1;
		else empty_flag <= empty_flag_val;
endmodule

module wr_ctrl #(parameter ADDRSIZE = 4)
(
	output reg full_flag,
	output [ADDRSIZE-1:0] wr_addr,
	output reg [ADDRSIZE :0] wr_ptr,
	input [ADDRSIZE :0] rd_ptr_sync,
	input wr_en, wr_clk, wrst_n
);
	reg [ADDRSIZE:0] wbin;
	wire [ADDRSIZE:0] wgraynext, wbinnext;

	// GRAYSTYLE2 pointer
	always @(posedge wr_clk or negedge wrst_n)
		if (!wrst_n) {wbin, wr_ptr} <= 0;
		else {wbin, wr_ptr} <= {wbinnext, wgraynext};

	// Memory write-address pointer (okay to use binary to address memory)

	assign wr_addr = wbin[ADDRSIZE-1:0];
	assign wbinnext = wbin + (wr_en & ~full_flag);
	
	//gray_counter module merged in here. 
	assign wgraynext = (wbinnext>>1) ^ wbinnext;
	
	//------------------------------------------------------------------
	// Simplified version of the three necessary full-tests:
	// assign full_flag_val=((wgnext[ADDRSIZE] !=rd_ptr_sync[ADDRSIZE] ) &&
	// (wgnext[ADDRSIZE-1] !=rd_ptr_sync[ADDRSIZE-1]) &&
	// (wgnext[ADDRSIZE-2:0]==rd_ptr_sync[ADDRSIZE-2:0]));
	//------------------------------------------------------------------
	assign full_flag_val = (wgraynext=={~rd_ptr_sync[ADDRSIZE:ADDRSIZE-1], rd_ptr_sync[ADDRSIZE-2:0]});

	always @(posedge wr_clk or negedge wrst_n)
		if (!wrst_n) full_flag <= 1'b0;
		else full_flag <= full_flag_val;
endmodule

