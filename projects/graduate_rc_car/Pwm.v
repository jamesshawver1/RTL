`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:10:13 12/15/2014 
// Design Name: 
// Module Name:    Pwm 
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
module Pwm #(parameter CLK_DIV = 10000)
	(
    input clk_in,
    input reset_in,
    input [7:0] duty_cycle_in,
    output reg pwm_out
    );

	reg [31:0] clk_div_count_r;
	reg [7: 0] pwm_compare_r;

always @(posedge clk_in) begin
	if(reset_in) begin
		clk_div_count_r=0;
		pwm_compare_r=0;
	end
	else begin
		if(clk_div_count_r == CLK_DIV) begin
			clk_div_count_r = 0;
			if(pwm_compare_r < duty_cycle_in) begin
				pwm_out = 1;
			end
			else begin
				pwm_out = 0;
			end
			pwm_compare_r = pwm_compare_r + 1;
		end
		else begin 
			clk_div_count_r = clk_div_count_r + 1;
		end
	end
end

endmodule

module Motor #(parameter CLK_DIV = 10000)
	(
		input clk_in,
		input reset_in,
		input[7:0] speed,
		input direction,
		output motor_plus,
		output motor_minus	
	);
	
	reg [7:0] mplus,mminus;
	Pwm  #(.CLK_DIV(CLK_DIV)) mp
	(
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.duty_cycle_in(mplus), 
		.pwm_out(motor_plus)
	);
	Pwm  #(.CLK_DIV(CLK_DIV)) mm
	(
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.duty_cycle_in(mminus), 
		.pwm_out(motor_minus)
	);
	always @(posedge clk_in) begin
		if(reset_in) begin
			mplus = 0;
			mminus = 0;
		end
		else begin
			if(direction) begin
				mplus = 0;
				mminus = speed;
			end
			else begin
				mplus = speed;
				mminus = 0;			
			end
		end
	end
	
	
endmodule
