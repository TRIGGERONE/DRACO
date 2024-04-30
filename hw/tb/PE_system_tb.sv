/*
 * @Author: Haotian Lu
 * @Date: 2024-04-06 13:39:16 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-04-06 17:53:39
 */
`timescale 10 ns / 1 ns

`include "common_pkg_SCRIPT.sv"
`include "PE_system.sv"

module PE_system_tb();

reg clk, reset, grad_counter_ena, ena;

int grad_count = 5;

phase_t_mem                                                     coupling_phase;
int                                                             coupling_factor [NUM_SPINS - 1:0][NUM_SPINS - 1:0];
wire [NL_OUT_PHASE_BITWIDTH + 2 * NUM_SPINS_EXP - 1: 0]         Hamiltonian;

initial begin
    clk = 1'b1;
    reset = 1'b0;
    ena = 1'b1;
    grad_counter_ena = 1'b1;

    for (int i = 0; i < NUM_SPINS; i = i + 1) begin
        for (int j = i; j < NUM_SPINS; j = j + 1) begin
            if ((i + j) % 3 == 0) begin
                coupling_factor[i][j] = 2;
                coupling_factor[j][i] = 2;
            end
            else if ((i + j) % 3 == 1) begin
                coupling_factor[i][j] = 0;
                coupling_factor[j][i] = 0;
            end
            else begin
                coupling_factor[i][j] = -2;
                coupling_factor[j][i] = -2;
            end
        end
    end
    assert (std::randomize(coupling_phase));
end

always #2 clk = ~ clk;

always #60 reset = ~reset;

PE_system PE_array(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .coupling_phase(coupling_phase),
    .coupling_factor(coupling_factor),
    .Hamiltonian(Hamiltonian)
);

endmodule