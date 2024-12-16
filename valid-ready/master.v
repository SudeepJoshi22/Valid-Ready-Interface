`default_nettype none

module valid_ready_master(
	input wire clk,
	input wire rst_n,
	input wire i_m_ready,
	input wire i_m_stall,
	output wire [7:0] o_m_data,
	output wire o_m_valid
);
	reg ir_m_valid;
	reg [7:0] ir_m_data;
	
	reg [7:0] counter;

	wire is_valid_signal;

	assign is_valid_signal = rst_n & !i_m_stall;
	
	assign o_m_data = ir_m_data;	
	assign o_m_valid = ir_m_valid;

	initial
		counter <= 0;

	always @(posedge clk) begin
		if(!rst_n)
			counter <= 0;
		else
			counter <= counter + 1;
	end	

	// Logic for VALID
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n)
			ir_m_valid <= 0;
		else if(!ir_m_valid || i_m_ready) begin
			ir_m_valid <= is_valid_signal; 
		end
	end

	//  Logic for DATA
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			ir_m_data <= 0;
		else if(!ir_m_valid || o_m_valid) begin
			ir_m_data <= counter;	
			
			if(!is_valid_signal) 
				ir_m_data <= 0;
		end	

	end

endmodule		
