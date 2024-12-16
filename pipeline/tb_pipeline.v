module tb_pipeline(
    input wire clk,
    input wire rst_n,
    input wire i_flush,
    input wire i_internal_stall_1,
    input wire i_internal_stall_2,
    input wire i_internal_stall_3,
    output wire [15:0] o_pipeline_data,
    output wire o_pipeline_valid
);

    // Signals for interconnecting stages
    wire [15:0] stage1_to_stage2_data;
    wire stage1_to_stage2_valid;
    wire stage2_to_stage1_stall;
    wire stage2_to_stage1_current_ce;

    wire [15:0] stage2_to_stage3_data;
    wire stage2_to_stage3_valid;
    wire stage3_to_stage2_stall;
    wire stage3_to_stage2_current_ce;

    // Instantiate stage_1
    stage_1 u_stage_1 (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_internal_stall(i_internal_stall_1),
        .i_flush(i_flush),
        .i_stall(stage2_to_stage1_stall),
        .i_next_ce(stage2_to_stage1_current_ce),
        .o_data(stage1_to_stage2_data),
        .o_valid(stage1_to_stage2_valid)
    );

    // Instantiate stage_2
    stage_2 u_stage_2 (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_internal_stall(i_internal_stall_2),
        .i_flush(i_flush),
        .i_data(stage1_to_stage2_data),
        .i_valid(stage1_to_stage2_valid),
        .o_stall(stage2_to_stage1_stall),
        .o_current_ce(stage2_to_stage1_current_ce),
        .i_stall(stage3_to_stage2_stall),
        .i_next_ce(stage3_to_stage2_current_ce),
        .o_data(stage2_to_stage3_data),
        .o_valid(stage2_to_stage3_valid)
    );

    // Instantiate stage_3
    stage_3 u_stage_3 (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_internal_stall(i_internal_stall_3),
        .i_flush(i_flush),
        .i_data(stage2_to_stage3_data),
        .i_valid(stage2_to_stage3_valid),
        .o_stall(stage3_to_stage2_stall),
        .o_current_ce(stage3_to_stage2_current_ce),
        .o_data(o_pipeline_data),
        .o_valid(o_pipeline_valid)
    );

	initial begin
                $dumpfile("waves.vcd");
                $dumpvars(0, tb_pipeline);
        end


endmodule
