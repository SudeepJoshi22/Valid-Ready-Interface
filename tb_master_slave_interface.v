module tb_master_slave_interface (
	input wire clk,
	input wire rst_n,
	input wire stall_master,        // Stall signal for the master
	input wire stall_slave,         // Stall signal for the slave
	output wire slave_reg_data_out  // Output to monitor slave's `o_reg_data`
);

	// Signals for master-slave communication
	wire [7:0] m_to_s_data;   // Data from master to slave
	wire m_valid;             // Master indicates data is valid
	wire m_ready;             // Slave indicates ready to accept data
	wire [7:0] s_data_out;    // Processed data from the slave

	// Instantiate the master module
	valid_ready_master master_inst (
		.clk(clk),
		.rst_n(rst_n),
		.i_m_ready(m_ready),      // Connect master's ready to slave's ready
		.i_m_stall(stall_master), // Stall signal for master from input
		.o_m_data(m_to_s_data),   // Data from master to slave
		.o_m_valid(m_valid)       // Valid signal from master
	);

	// Instantiate the slave module
	valid_ready_slave slave_inst (
		.clk(clk),
		.rst_n(rst_n),
		.i_s_data(m_to_s_data),   // Connect master's data to slave's data input
		.i_s_valid(m_valid),      // Connect master's valid to slave's valid input
		.i_s_stall(stall_slave),  // Stall signal for slave from input
		.o_s_ready(m_ready),      // Ready signal from slave to master
		.o_reg_data(slave_reg_data_out) // Monitor slave's `o_reg_data`
	);

	initial begin
		$dumpfile("waves.vcd");
		$dumpvars(0, tb_master_slave_interface);
	end
	// Optional: Additional logic to monitor or manipulate signals can be added here

endmodule
