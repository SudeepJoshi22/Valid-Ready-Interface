// This is the first stage
// A counter will keep on running sending the current count to the next stage if the next stage is ready to accpt it
`default_nettype none

module stage_1(
	input wire i_clk,
	input wire i_rst_n,
	input wire i_internal_stall, // Internal condition for stall, being driven externally by test-bench
	input wire i_flush,
	// Inputs from next stage(n-1)	
	input wire i_stall, // Stall signal from next stage (!ready)
	input wire i_next_ce, // Tells if next stage is enabled or not
	// Outputs to next stage(n+1)
	output wire [15:0] o_data,
	output wire o_valid
);
	// Internal Registers
	reg [15:0] counter;
	reg [15:0] ir_data;
	reg ir_valid;

	// Internal wires
	wire is_ce;
	wire is_stall;

	// Stall for this stage
	assign is_stall = i_stall || i_internal_stall;

	// Output of this stage
	assign o_data = ir_data;
	assign o_valid = ir_valid;

	// Keep on running the counter
	always @(posedge i_clk, negedge i_rst_n) begin
		if(~i_rst_n) 
			counter <= 0;
		else
			counter <= counter + 1'b1;
	end

	// Is this stage enabled?
	// assign	stage[n]_ce = (stage[n-1]_valid)&&(!stage[n]_stalled);
	assign is_ce = ~is_stall && ~i_flush;

	// Clocking Valid of this stage
	always @(posedge i_clk, negedge i_rst_n) begin
		if(~i_rst_n || i_flush) begin
			ir_valid <= 0;
		end
		//else if(i_next_ce) begin
		//	ir_valid <= 0; 
		//end
		else begin
			ir_valid <= 1;
		end
		// There is no previous stage to drive the valid low
	end
	
	// Data processing for this stage
	always @(posedge i_clk, negedge i_rst_n) begin
		if(is_ce) begin
			ir_data <= counter; // Pass the current counter value to data
		end
		else if(i_flush) begin
			ir_data <= 0; // Drop the data if flushed
		end
		else begin
			ir_data <= ir_data;
		end
	end
	

endmodule
