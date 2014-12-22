`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:29 09/02/2014 
// Design Name: 
// Module Name:    HexTo7Seg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module HexTo7Seg(data_in,enable_in,segs_out,enable_out);
	input [3:0] data_in;
	input enable_in;
	output enable_out;
	output reg [0:6] segs_out;
	
	
	assign enable_out = ~enable_in;
	parameter lit=0;
	parameter unlit=1;
	
	//A=0 G=6
	always @(data_in) begin
		case (data_in)
			0: begin
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=unlit;
				end
			1: begin
				segs_out[0]=unlit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=unlit;
				segs_out[4]=unlit;
				segs_out[5]=unlit;
				segs_out[6]=unlit;
				end
			2: begin
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=unlit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=unlit;
				segs_out[6]=lit;
				end
			3:  begin
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=unlit;
				segs_out[5]=unlit;
				segs_out[6]=lit;
				end
			4: begin
				segs_out[0]=unlit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=unlit;
				segs_out[4]=unlit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			5:	begin 
				segs_out[0]=lit;
				segs_out[1]=unlit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=unlit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			6: begin
				segs_out[0]=lit;
				segs_out[1]=unlit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			7:  begin
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=unlit;
				segs_out[4]=unlit;
				segs_out[5]=unlit;
				segs_out[6]=unlit;
				end
			8:  begin
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			9:  begin
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=unlit;
				segs_out[4]=unlit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			10: begin //A  
				segs_out[0]=lit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=unlit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			11: begin //B  
				segs_out[0]=unlit;
				segs_out[1]=unlit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			12: begin //C  
				segs_out[0]=lit;
				segs_out[1]=unlit;
				segs_out[2]=unlit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=unlit;
				end
			13: begin //D  
				segs_out[0]=unlit;
				segs_out[1]=lit;
				segs_out[2]=lit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=unlit;
				segs_out[6]=lit;
				end
			14: begin //E  
				segs_out[0]=lit;
				segs_out[1]=unlit;
				segs_out[2]=unlit;
				segs_out[3]=lit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			default: begin //F
				segs_out[0]=lit;
				segs_out[1]=unlit;
				segs_out[2]=unlit;
				segs_out[3]=unlit;
				segs_out[4]=lit;
				segs_out[5]=lit;
				segs_out[6]=lit;
				end
			endcase
	
	end

endmodule


module Bin16To4Seg7(data_in,clk_in,clk_divide_in ,segs_out,enables_out);
	input [15:0] data_in;
	input clk_in;
	input [19:0] clk_divide_in; //20 bits takes a 50MHz clock down to 60Hz
	
	output [6:0] segs_out;
	output [3:0] enables_out;
	
	reg [19:0] clk_count_r=0; //20 bits takes a 50MHz clock down to 60Hz
	reg [3:0] enable_s;
	reg [3:0] hex_s;

	
	assign enables_out = ~enable_s;
	
	HexTo7Seg U3 (
		.data_in(hex_s), 
		.enable_in(1'b1), 
		.segs_out(segs_out), 
		.enable_out()
	);
	
		
	always @(posedge clk_in) begin
			clk_count_r = clk_count_r + 1;
			if(clk_count_r == clk_divide_in) begin
				clk_count_r = 0;
				case (enable_s)
					0: begin
						enable_s = 1;
					end
					1: begin
						enable_s = 2;
						hex_s=data_in[11:8];
					end
					2: begin
						enable_s = 4;
						hex_s=data_in[7:4];
						
					end
					
					4: begin
						enable_s = 8;
						hex_s=data_in[3:0];
					end
					
					8: begin
						enable_s = 1;
						hex_s=data_in[15:12];
					end
					
					default: begin
						enable_s = 1;
					end
				
				endcase
			end
	end
endmodule
