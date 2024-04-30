/*
 * @Author: Haotian Lu
 * @Date: 2023-12-27 19:51:53 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-04-06 15:06:22
 */
`timescale 10 ns / 1 ns

`include "common_pkg_SCRIPT.sv"
`include "PE_1D.sv"

module PE_1D_tb();

reg clk, reset, grad_counter_ena, ena;

int grad_count = 5;

phase_t_reg                     self_phase;
phase_t_mem                     coupling_phase;

int                             coupling_factor [NUM_SPINS - 1:0];

logic [NUM_SPINS - 1: 0]        random_signal;
phase_t                         self_phase_update, out_phase;
NL_out_phase_t                  Hamiltonian;

int                             sample_time;

reg                             test_mode = 1'b1;   //! This bit is used to assign testing mode, coupling factor = '1 (fully-connected) else = '0 (irregular)

initial begin
    clk                 = 1'b1;
    reset               = 1'b0;
    ena                 = 1'b1;
    grad_counter_ena    = 1'b1;
    grad_count          = 5;
    self_phase          = '0;

    sample_time         = 4;

    if (test_mode) begin
        for (int i = 0; i < NUM_SPINS; i = i + 1) begin
            if (i % 3 == 0) begin
                coupling_factor[i] = -8;
            end
            else if (i % 3 == 1) begin
                coupling_factor[i] = 0;
            end
            else begin
                coupling_factor[i] = 8;
            end
        end
    end else begin
        assert (std::randomize(coupling_factor));
    end

    assert (std::randomize(coupling_phase));
end

always #20 clk = ~ clk;

PE_1D #(
    .global_index (0)
)   PE_1D_ins(
    .clk               (clk               ),
    .reset             (reset             ),
    .ena               (ena               ),
    // .grad_counter_ena  (grad_counter_ena  ),
    .sample_time       (sample_time       ),
    .grad_count        (grad_count        ),
    .self_phase        (coupling_phase[0] ),
    .coupling_phase    (coupling_phase    ),
    .coupling_factor   (coupling_factor   ),
    .random_signal     (random_signal     ),
    .self_phase_update (self_phase_update ),
    .out_phase         (out_phase         ),
    .Hamiltonian       (Hamiltonian       )
);

endmodule