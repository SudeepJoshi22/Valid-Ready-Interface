`default_nettype none

module valid_ready_slave(
	input wire clk,
	input wire rst_n,
	input wire [7:0] i_s_data,
	input wire i_s_valid,
	input wire i_s_stall,
	output wire o_s_ready, 
	output wire o_reg_data
);
	reg ir_s_ready;
	wire is_ready_signal;

	assign o_s_ready = ir_s_ready;
	
	reg [7:0] ir_data;
	
	assign o_reg_data = ir_data;


	assign is_ready_signal = rst_n && !i_s_stall;
	
	// Logic for READY
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			ir_s_ready <= 0;
		else
			ir_s_ready <= is_ready_signal; 
	end

	// Logic for register DATA
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			ir_data <= 0;
		else if(i_s_valid && o_s_ready)
			ir_data <= i_s_data;
	end

endmodule
