module RxControl #(parameter num_samples = 16)
(
	input clk_in,
	input enable_in,
	input n_reset_in,
	input n_rd_in, //this will need to be pulsed in order to ensure that the afifo only is read once
	
	input s_num_in, // number of stop bits 0- 1 stop bit; 1 - 2 stop bits
	input [31:0] clk_div_baud_in, //takes clk_in to the correct baud rate
	input [1:0] parity_in, //00-none 01-invalid 10-Odd 11-even
	input d_num_in, //0- 7 data bits; 1- 8 data bits
	input rx_in, //this is the input to the module from the transmitting device aka the sampled wire
	
	output reg overrun_error_out,
	output parity_error_out,
	output frame_error_out,
	output break_out,
	
	output [7:0] data_out, //need to maintain an 8 bit bus due to it being the highest data bus
	output rx_rdy_out //this tells the higher modules that there is something in the fifo to be read
);
	reg [31:0] mod_count_r;
	reg [7:0] sample_count_r,num_samples_r=num_samples;
	reg sample_r;
	reg rx_rdy_r;
	reg rx_rdy_s_r;
	wire rx_rdy_s;
	wire receiving_s;
	
	
	assign rx_rdy_out = rx_rdy_r & rx_rdy_s;

	RxReceiver rx_magic (
		 .clk_in(clk_in), 
		 .enable_in(enable_in), 
		 .sample_in(sample_r), 
		 .n_reset_in(n_reset_in), 
		 .d_num_in(d_num_in), 
		 .s_num_in(s_num_in), 
		 .rx_in(rx_in), 
		 .parity_in(parity_in), 
		 .parity_error_out(parity_error_out), 
		 .frame_error_out(frame_error_out), 
		 .break_out(break_out), 
		 .rx_complete_out(rx_rdy_s), //this tells the higher modules that there is space in the afifo to write to
	     .rx_in_progress_out(receiving_s), //this tells the higher modules that there is space in the afifo to write to
		 .data_out({data_out[0],data_out[1],data_out[2],data_out[3],data_out[4],data_out[5],data_out[6],data_out[7]})
		 );

	always @(posedge clk_in) begin
		
		if(rx_rdy_s!=rx_rdy_s_r) begin
			if(rx_rdy_r) overrun_error_out=1;
			if(rx_rdy_s) rx_rdy_r = 1;
			rx_rdy_s_r=rx_rdy_s;
		end
		
		if(~n_reset_in | ~enable_in) begin
				rx_rdy_s_r = 0;
				num_samples_r =num_samples;
				mod_count_r <= clk_div_baud_in;
				sample_count_r<=  {1'b0,num_samples_r[7:1]};//effectively a X/2
				overrun_error_out = 0;
				mod_count_r <= clk_div_baud_in;
		end

		else if(~n_rd_in) begin
			rx_rdy_r = 0;
			overrun_error_out = 0;
		end
		else begin	
			if(~receiving_s) begin
				sample_count_r<= {1'b0,num_samples_r[7:1]};//effectively a X/2
				mod_count_r <= clk_div_baud_in;
			end
			else begin //actually receiving

				if (mod_count_r < num_samples) begin // comparison is for cases where mod_count_r is too small to subtract 16 from
					mod_count_r <= clk_div_baud_in+mod_count_r;//leaves the remainder
					if(sample_count_r ==1) begin //sample point
						sample_r=1;
						sample_count_r <= num_samples_r;	//set back to full value

					end
					else begin
						sample_count_r <= sample_count_r - 1;
					end
				end
				else begin
					sample_r=0;
					mod_count_r <= mod_count_r - num_samples;
				end
			end
		end
	end

endmodule

module RxReceiver(
	input clk_in,
	input enable_in,//pulsed for each state transition
	input sample_in,//pulsed for each state transition
	input n_reset_in,
	input d_num_in, //datawidth 7/8
	input s_num_in, //stop bits
	input rx_in, //used to set tx_out to low
	input [1:0] parity_in, //parity mode

	output reg parity_error_out,
	output reg frame_error_out,
	output reg break_out,

	output reg [7:0] data_out,
	output reg rx_complete_out, //this tells the higher modules that there is space in the afifo to write to
	output reg rx_in_progress_out //this tells the higher modules that there is space in the afifo to write to
);
	parameter WAITING=    3'b000,  //states
			  START_BIT=  3'b001, 
			  DATA=       3'b010, 
			  PARITY=     3'b011, 
			  STOP_BIT=   3'b100; 

	reg [2:0] state;
	reg stop_count_r,parity_r;
	reg [1:0] stop_r;
	reg [1:0] parity_mode_r;
	reg [7:0] data_r;
	reg [2:0] data_count_r;
	
	always @(posedge clk_in or negedge n_reset_in) begin
		if(~n_reset_in) begin
			rx_complete_out = 0;
			state=WAITING;
			stop_count_r=0;
			stop_r = 0;
			parity_mode_r=0;
			data_r=0;
			parity_mode_r=0;
			data_count_r=0;
			parity_error_out = 0;
			frame_error_out = 0;
		end
		else if (~enable_in) begin
			rx_complete_out = 0;
			state=WAITING;
			stop_count_r=0;
			parity_mode_r=0;
			data_r=0;
			data_count_r=0;
		end
		else begin
			case(state)
				WAITING:   begin 
									
									if(~rx_in & enable_in) begin //start bit went low
										stop_count_r = s_num_in; //index 1:0 
										data_count_r = 6+d_num_in;/*index 7:0 */ 
										parity_mode_r = parity_in; 
										data_r=0;
										stop_r=2'b11;//set to high for only one stop bit case
										
										rx_in_progress_out = 1;
										rx_complete_out= 0;
									
										state=START_BIT; //go to next state
									end
								end
				START_BIT: begin 
								if(rx_in) begin //if high before sample_in = false start
									state=WAITING;
									frame_error_out = 1;
								end
							    if(enable_in&sample_in) begin
									state=DATA; //go to next state
									frame_error_out = 0;
							    end
						   end
				DATA:      begin 
							   if(enable_in&sample_in) begin 
									data_r[data_count_r] = rx_in ; //decrementing
									if(data_count_r == 0) begin  //go to next state
										stop_r=2'b11;
										if(parity_mode_r[1])//has parity -> goto parity state
											state=PARITY; 
										else//no parity -> goto stop state
											state=STOP_BIT; 
									end
									else begin
										data_count_r = data_count_r - 1;
									end
							   end
						   end
				PARITY:    begin 
							   if(enable_in&sample_in) begin
									 state=STOP_BIT; //go to next state
									 
									 parity_r = rx_in;
									 parity_error_out=  ^data_r ^ parity_mode_r[0] ^ rx_in;
								end
						   end
				STOP_BIT:  begin 
							   if(enable_in&sample_in) begin  //go to next state
									stop_r[stop_count_r] = rx_in ; //decrementing
									if(stop_count_r == 0) begin
										state=WAITING; 
										frame_error_out = ~(&stop_r);
										break_out = ~(parity_r & data_r& stop_r & rx_in);
										rx_complete_out= 1;
										rx_in_progress_out =0;
										data_out= data_r;
									end
									else begin
										stop_count_r = 0;
									end
							   end
						   end
				default: state=WAITING;
			endcase
		end
	end
endmodule //transmitting states

module TxTransmitter (
	input clk_in,
	input enable_in,//pulsed for each state transition
	input next_state_in,//pulsed for each state transition
	input n_reset_in,
	input d_num_in, //datawidth 7/8
	input s_num_in, //stop bits
	input break_in, //used to set tx_out to low
	input [1:0] parity_in, //parity mode
	input [7:0] data_in,
	output reg tx_complete_out, //this tells the higher modules that there is space in the afifo to write to
	output reg tx_out //this is the input to the module from the transmitting device aka the sampled wire
);
	parameter START=      3'b000,  //states
			  LOAD=       3'b001, 
			  START_BIT=  3'b010, 
			  DATA=       3'b011, 
			  PARITY=     3'b100, 
			  STOP_BIT=   3'b101; 

	reg [2:0] state;
	reg [1:0] stop_count_r;
	reg [1:0] parity_mode_r;
	reg [7:0] data_r;
	reg [2:0] data_count_r;

	always @(posedge clk_in or negedge n_reset_in or posedge break_in ) begin
		if(~n_reset_in) begin
			tx_out = 1;
			tx_complete_out = 1;
			state=START;
			stop_count_r = 0;
			parity_mode_r =0;
			data_r=0;
			data_count_r=0;
		end
		else if (break_in) begin
			tx_out = 0;
			tx_complete_out = 1;
			state=START;
			stop_count_r = 0;
			parity_mode_r =0;
			data_r=0;
			data_count_r=0;
		end
		else  begin //if(clk_in)
			case(state)
				START:     begin tx_out = 1; 
							   if(enable_in) state=LOAD; //go to next state
						   end
				LOAD:      begin stop_count_r = 1+s_num_in; data_count_r = 6+d_num_in;/*index 7:0 */ parity_mode_r = parity_in; data_r = data_in; tx_complete_out= 0;
							   if(enable_in&next_state_in) state=START_BIT; //go to next state
						   end
				START_BIT: begin tx_out = 0; tx_complete_out= 0;
							   if(enable_in&next_state_in) state=DATA; //go to next state
						   end
				DATA:      begin tx_out = data_r[data_count_r]; //decrementing
							   if(enable_in&next_state_in) begin 
									if(data_count_r == 0) begin  //go to next state
										if(parity_mode_r[1])//has parity -> goto parity state
											state=PARITY; 
										else//no parity -> goto stop state
											state=STOP_BIT; 
									end
									else begin
										data_count_r = data_count_r - 1;
									end
							   end
						   end
				PARITY:    begin tx_out = ^data_r ^ parity_mode_r[0]; //even vs odd is parity[0]
							   if(enable_in&next_state_in) state=STOP_BIT; //go to next state
						   end
				STOP_BIT:  begin tx_out = 1;
							   if(enable_in&next_state_in) begin  //go to next state
									if(stop_count_r == 0) begin
										state=START; 
										tx_complete_out= 1;
									end
									else begin
										stop_count_r = stop_count_r -1;
									end
							   end
						   end
				default: state=START;
			endcase
		end
	end
endmodule //transmitting states

module TxControl #(parameter fifo_address_width=4)
(
	input clk_in, 
	input enable_in, //sets tx_out to 1 if enable_in==0
	input n_reset_in, //sets tx_out to 1 and clears internal registers
	input n_wr_in, 
	
	input s_num_in, // number of stop bits 0- 1 stop bit; 1 - 2 stop bits
	input [31:0] clk_div_baud_in, //takes clk_in to the correct baud rate
	input [1:0] parity_in, //00-none 01-invalid 10-Odd 11-even
	input d_num_in, //0- 7 data bits; 1- 8 data bits
	input [7:0] data_in, //need to maintain an 8 bit bus due to it being the highest data bus
	input break_in,
	
	output tx_out, //this is the input to the module from the transmitting device aka the sampled wire
	//output error_out, //an error will occur if the afifo becomes full at any point
	output tx_rdy_out //this tells the higher modules that there is space in the afifo to write to
);
	
		
	wire n_transmitting_s; //register is used to hold state of performing a transmit
	reg n_transmitting_r;
	wire tx_complete_r; //register is used to hold state of performing a transmit
	reg shift =0;
	reg [31:0] mod_count_r=0;
	
	TxTransmitter tx_shifter (
    .clk_in(clk_in), 
    .enable_in(~n_transmitting_s), 
	 .next_state_in(shift),
    .n_reset_in(n_reset_in), 
    .d_num_in(d_num_in), 
    .s_num_in(s_num_in), 
    .break_in(break_in), 
    .parity_in(parity_in), 
    .data_in(data_in), 
    .tx_complete_out(tx_complete_r ), 
    .tx_out(tx_out)
    );
	

	
	assign n_transmitting_s = tx_complete_r & n_wr_in;
	assign tx_rdy_out = n_transmitting_r & enable_in;
	
	always @(posedge clk_in or negedge n_reset_in) begin
		
		if(~n_reset_in) begin
			mod_count_r <= clk_div_baud_in;
			shift <= 0;
		end
		else if(~n_transmitting_r & enable_in) begin
				if (mod_count_r == 0) begin
					mod_count_r <= clk_div_baud_in;
					shift<=1;
				end
				else begin
					shift <= 0;
					mod_count_r <= mod_count_r - 1;
				end
		end
		else begin
			mod_count_r <= clk_div_baud_in;
			n_transmitting_r = n_transmitting_s;
		end

		
		
	end
endmodule

module CpuIfBlock 
	(
		input n_CS, //chip select active low 
		input [7:0] DATA_in, //inout data bus
		output reg [7:0] DATA_out=0, //inout data bus
		input C_nD, //command not data
		input n_WR, //low active write
		input n_RD, //low active read
		output n_INT, //interrupt 
		input CLK50M, //assumed 50MHz clock
		input n_RST, // low active reset
		output Tx_RDY, // tx ready
		output Rx_RDY, // ready to read
		
		//stuff going to RX and TX controlling modules
		output reg [7:0] tx_data_out,
		input  [7:0] rx_data_in,
		output [1:0] parity,
		output extra_stop_bit,
		output eight_data_bits,
		output reg [12 : 0 ] clk_div_baud_out,
		output rx_rdy_en,
		output tx_rdy_en,
		output reg n_external_reset,
		
		output reg n_rd_out,
		output reg n_wr_out,
		
		input frame_error_in,
		input parity_error_in,
		input overrun_error_in,
		
		input tx_rdy_in,
		input rx_rdy_in,
		output reg [7:0] configuration_word_reg_r,
		//needs to be handled higher up
		output break_en
		
	);
	
	
	reg [7:0] status_reg_r;
	reg [7:0] command_word_reg_r;
	
	
	reg control_count = 0;
	
	//Configuration word parsing
	
	assign extra_stop_bit  = configuration_word_reg_r[3];
	assign eight_data_bits = configuration_word_reg_r[2];
	wire[1:0] selected_baud;
	assign selected_baud   = configuration_word_reg_r[1:0];
	assign parity          = configuration_word_reg_r[5:4];
	
	//Command Word Parsing
	assign rx_rdy_en        = command_word_reg_r[0];
	assign tx_rdy_en        = command_word_reg_r[1];
	assign parity_error_en  = command_word_reg_r[2];
	assign frame_error_en   = command_word_reg_r[3];	
	assign overrun_error_en = command_word_reg_r[4];
	assign clear_errors     = command_word_reg_r[5];
	assign internal_reset   = command_word_reg_r[6];
	assign break_en         = command_word_reg_r[7];
	

	
	wire[2:0] state;// = {C_nD,n_RD,n_WR};
	assign state = {C_nD,n_RD,n_WR};
	//assign DATA = n_WR ? 8'bZ : rx_reg_r;
	
	assign n_INT = ~((parity_error_en & parity_error_in) | (frame_error_en & frame_error_in) | (overrun_error_en & overrun_error_in));
	
	assign Tx_RDY = tx_rdy_in;
	assign Rx_RDY = rx_rdy_in;
	
	always @(posedge CLK50M) begin
		n_wr_out <=1;
		n_rd_out <=1;
		
			//status word parsing
		status_reg_r[7] = rx_rdy_in;//rx ready
		status_reg_r[6] = tx_rdy_in;//tx ready
		status_reg_r[5] = parity_error_in;//pe_fg
		status_reg_r[4] = frame_error_in;//fe fg
		status_reg_r[3] = overrun_error_in;//oe fg
		status_reg_r[2] = 0;//break
		status_reg_r[1] = 0;
		status_reg_r[0] = 0;
		
		if(clear_errors) begin
			status_reg_r[5:2] = 0;
		end
		
		case(selected_baud) 
			0: clk_div_baud_out <= 5208; //9600 baud
			1: clk_div_baud_out <= 2604; //19200 baud
			2: clk_div_baud_out <= 868; //57,600 baud
			3: clk_div_baud_out <= 434; //115200 baud
		endcase
		
		if(~n_RST | internal_reset) begin
			configuration_word_reg_r <=0;
			command_word_reg_r <= 0;
			control_count <= 0;
			status_reg_r = 0;
			DATA_out <=0;
			n_external_reset<=0;
		end
		
		else begin
			n_external_reset<=1;
			if(~n_CS) begin
				case(state)
					//if reading and C_nD is low
					1: begin
						DATA_out <= rx_data_in;
						n_rd_out <=0;
						end
					//if writing and C_nD is low
					2: begin
						tx_data_out <= DATA_in;
						n_wr_out <=0;
						end
					//if reading and C_nD is high
					5: DATA_out <= status_reg_r;
					6: begin
						if(~control_count) begin
							configuration_word_reg_r <= DATA_in;
							control_count <= 1;
							n_external_reset<=0;
						end
						else begin
							command_word_reg_r <= DATA_in;
						end
					end
				endcase
			end
		end
	end
endmodule 


module UART(
	input CLK50M,
	input n_RST,
	input [7:0] DATA_in,
	output [7:0] DATA_out,
	input n_RD,
	input n_WR,
	input C_nD,
	input n_CS,
	output n_INT,
	output Tx_RDY,
	output Rx_RDY,
	output [7:0] configuration_word_reg_r,
	input rx,
	output tx
    );
		wire [7:0] tx_data_out;
		wire [7:0] rx_data_out;
		wire [1:0] parity;
		wire extra_stop_bit;
		wire eight_data_bits;
		wire [31:0] clk_div_baud_out;
		wire rx_rdy_en;
		wire tx_rdy_en;
		wire break_en;
		wire n_rd_out;
		wire n_wr_out;
		wire frame_error_out;
		wire parity_error_out;
		wire overrun_error_out;
		wire tx_rdy_out;
		wire rx_rdy_out;
		wire internal_reset;

		wire tx_s;
		assign tx = ~break_en & tx_s;
	 
	CpuIfBlock cpu_if2 (
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
		.rx_data_in(rx_data_out), 
		.parity(parity), 
		.extra_stop_bit(extra_stop_bit), 
		.eight_data_bits(eight_data_bits), 
		.clk_div_baud_out(clk_div_baud_out), 
		.rx_rdy_en(rx_rdy_en), 
		.tx_rdy_en(tx_rdy_en), 
		.break_en(break_en),
		.n_rd_out(n_rd_out),
		.n_wr_out(n_wr_out),
		.frame_error_in(frame_error_out),
		.parity_error_in(parity_error_out),
		.overrun_error_in(overrun_error_out),
		.tx_rdy_in(tx_rdy_out),
		.rx_rdy_in(rx_rdy_out),
		.configuration_word_reg_r(configuration_word_reg_r),
		.n_external_reset(internal_reset)
	);
	RxControl rxu (
		.clk_in(CLK50M), 
		.n_rd_in(n_rd_out),
		.enable_in(rx_rdy_en), 
		.n_reset_in(internal_reset), 
		.s_num_in(extra_stop_bit), 
		.clk_div_baud_in(clk_div_baud_out), 
		.parity_in(parity), 
		.d_num_in(eight_data_bits), 
		.rx_in(rx), 
		.data_out(rx_data_out), 
		.frame_error_out(frame_error_out), 
		.parity_error_out(parity_error_out), 
		.overrun_error_out(overrun_error_out), 
		.rx_rdy_out(rx_rdy_out)
	);

	TxControl txu (
		.clk_in(CLK50M), 
		.enable_in(tx_rdy_en), 
		.n_reset_in(internal_reset), 
		.n_wr_in(n_wr_out), 
		.s_num_in(extra_stop_bit), 
		.clk_div_baud_in(clk_div_baud_out), 
		.parity_in(parity), 
		.d_num_in(eight_data_bits), 
		.data_in(tx_data_out), 
		.tx_out(tx_s), 
		.tx_rdy_out(tx_rdy_out)
	);
	
	

endmodule
