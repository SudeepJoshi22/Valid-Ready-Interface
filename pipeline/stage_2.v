`default_nettype none

module stage_2(
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
	input wire i_stall, // Stall signal from next stage (!ready)
	input wire i_next_ce, // Tells if next stage is enabled or not
	// Outputs to next stage(n+1)
	output wire [15:0] o_data,
	output wire o_valid
);
	// Internal Registers
	reg[15:0] ir_data;
	reg ir_valid;
	reg ir_stall_prev;

	// Internal wires
	wire is_ce;
	wire is_stall;

	assign is_stall = i_stall || i_internal_stall;

	// Output of this stage
	assign o_data = ir_data;
	assign o_valid = ir_valid;

	assign o_current_ce = is_ce;

	// Stall the previous stage
	assign o_stall = ir_stall_prev;	

	// Is this stage enabled?
	// assign	stage[n]_ce = (stage[n-1]_valid)&&(!stage[n]_stalled);
	assign is_ce = (~is_stall && i_valid) && ~i_flush;

	// Clocking Valid of this stage
	always @(posedge i_clk, negedge i_rst_n) begin
		if(~i_rst_n || i_flush) begin
			ir_valid <= 0;
		end
		//else if(i_next_ce) begin
		//	ir_valid <= 0; 
		//end
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
			ir_data <= i_data + 1; // Increment the received data 
		end
		else if(i_flush) begin
			ir_data <= 0; // Drop the data if flushed
		end
		else begin
			ir_data <= ir_data;
		end

	end

	// Clock the ir_prev_stall
	always @(posedge i_clk, negedge i_rst_n) begin
		if(~i_rst_n || i_flush) begin
			ir_stall_prev <= 1'b0;
		end
		else begin
			ir_stall_prev <= is_stall;
		end
	end
endmodule
