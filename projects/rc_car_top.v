`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:21:13 12/15/2014 
// Design Name: 
// Module Name:    rc_car_top 
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

module MotorControl (
	input [ 7:0 ] data_in,
	input clk_in,
	input reset_in,
	output reg m1_direction_out,
	output reg m2_direction_out,
	output reg [7:0] m1_speed_out,
	output reg [7:0] m2_speed_out

);
	parameter M1_FOR = 8'h00;
	parameter M1_BACK = 8'h01;
	parameter M2_FOR = 8'h02;
	parameter M2_BACK = 8'h03;
	
	reg[2:0] enabled_update;
	reg [7:0] state,data_s;
	always @(posedge clk_in) begin
		if(reset_in) begin
			m1_direction_out<=0;
			m2_direction_out<=0;
			m1_speed_out<=0;
			m2_speed_out<=0;
			enabled_update<=0;
			state<=0;
			data_s<=0;
		end
		else begin
			state<=data_in;
			case(state) 
				M1_FOR:  enabled_update <= M1_FOR;
				M1_BACK: enabled_update <= M1_BACK;
				M2_FOR:  enabled_update <= M2_FOR;
				M2_BACK: enabled_update <= M2_BACK;
				default: begin
					data_s<= data_in;
					case(enabled_update)
						M1_FOR:   begin
							m1_speed_out <= data_s;
							m1_direction_out<=1;
						end
						M1_BACK:  begin
							m1_speed_out <= data_s;
							m1_direction_out<=0;
						end
						M2_FOR:   begin
							m2_speed_out <= data_s;
							m2_direction_out<=1;
						end
						M2_BACK:  begin
							m2_speed_out <= data_s;
							m2_direction_out<=0;
						end
					endcase
				end
			endcase
		end
	end

endmodule 


module rc_car_top(
    input uart_rx,
    input clk_in,
    input reset_in,
//	 input  [7:0] data,
	 input enable_in,
	 input read_in,
	 output [7:0] uart_data,
    output m1_plus,
    output m1_minus,
    output m2_plus,
    output m2_minus
    );

	wire [ 7:0 ] uart_data_s;

	wire m1_direction_s,m2_direction_s;
	wire [7:0] m1_speed_s,m2_speed_s;
	
	assign uart_data = uart_data_s;

	RxControl uart_rxm (
    .clk_in(clk_in), 
    .enable_in(enable_in), 
    .n_reset_in(1'b1), 
    .n_rd_in(read_in), 
    .s_num_in(1'b0), 
    .clk_div_baud_in(5210), 
    .parity_in(2'b00), 
    .d_num_in(1'b1), 
    .rx_in(uart_rx), 
    .overrun_error_out(), 
    .parity_error_out(), 
    .frame_error_out(), 
    .break_out(), 
    .data_out(uart_data_s), 
    .rx_rdy_out()
    );

	MotorControl mc (
    .data_in(uart_data_s), 
    .clk_in(clk_in), 
    .reset_in(reset_in), 
    .m1_direction_out(m1_direction_s), 
    .m2_direction_out(m2_direction_s), 
    .m1_speed_out(m1_speed_s), 
    .m2_speed_out(m2_speed_s)
    );

	Motor #(.CLK_DIV(1000))
		m1 (
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.speed(m1_speed_s), 
		.direction(m1_direction_s), 
		.motor_plus(m1_plus), 
		.motor_minus(m1_minus)
	);
		Motor #(.CLK_DIV(1000))
		m2 (
		.clk_in(clk_in), 
		.reset_in(reset_in), 
		.speed(m2_speed_s), 
		.direction(m2_direction_s), //m2_direction_s
		.motor_plus(m2_plus), 
		.motor_minus(m2_minus)
	);
endmodule
