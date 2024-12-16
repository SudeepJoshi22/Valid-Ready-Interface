`default_nettype none

module stage_3(
	input wire i_clk,
	input wire i_rst_n,
	input wire i_internal_stall, // Internal condition for stall, being driven externally by test-bench
	input wire i_flush,
	// Inputs from previous stage(n-1)
	input wire [15:0] i_data,
	input wire i_valid,
	// Outputs to previous stage(n-1)
	output wire o_stall,
	output wire o_current_ce,
	// Inputs from next stage(n+1)	
	// ...
	// Outputs to next stage(n+1)
	output wire [15:0] o_data,
	output wire o_valid
);
	// Internal Registers
	reg[15:0] ir_data;
	reg ir_valid;

	// Internal wires
	wire is_ce;

	// Output of this stage
	assign o_data = ir_data;
	assign o_valid = ir_valid;

	assign o_current_ce = is_ce;
	// Is this stage enabled?
	// assign	stage[n]_ce = (stage[n-1]_valid)&&(!stage[n]_stalled);
	assign is_ce = ~i_internal_stall;

	// Clocking Valid of this stage
	always @(posedge i_clk, negedge i_rst_n) begin
		if(~i_rst_n || i_flush) begin
			ir_valid <= 0;
		end
		else if(is_ce) begin
			ir_valid <= i_valid;
		end
		else begin
			ir_valid <= 0;
		end
	end
	
	// Data processing for this stage
	always @(posedge i_clk, negedge i_rst_n) begin
		if(is_ce) begin
			ir_data <= i_data + 1; // Pass the current counter value to data
		end
	end

endmodule
