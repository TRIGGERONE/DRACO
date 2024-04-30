/*
 * @Author: Haotian Lu
 * @Date: 2023-12-27 19:16:58 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-04-06 17:50:56
 */
`timescale 1 ns / 100 ps

`ifndef PE_1D_DEF
    `define PE_system_DEF

`include "common_pkg_SCRIPT.sv"
`include "PE_1D.sv"

module PE_system  (
    input logic                                                             clk, reset, ena,
    input var phase_t_mem                                                   coupling_phase,
    input int                                                               coupling_factor [NUM_SPINS - 1:0] [NUM_SPINS - 1:0], 
    output reg [NL_OUT_PHASE_BITWIDTH + 2 * NUM_SPINS_EXP - 1: 0]           Hamiltonian
);

    reg [NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1: 0]                      Hamiltonian_mem [NUM_SPINS - 1: 0];
    reg [NUM_SPINS - 1: 0]                                                  signal_random [NUM_SPINS - 1: 0];
    reg [NL_OUT_PHASE_BITWIDTH + 2 * NUM_SPINS_EXP - 1: 0]                  Hamiltonian_local;

    phase_t_mem                                                             phase_update;
    phase_t_mem                                                             phase_mem;
    int                                                                     cnt = 0;

    always @(posedge clk) begin
        if (reset) begin
            Hamiltonian <= 'x;
        end
        else begin
            if (Hamiltonian_local == 'x || Hamiltonian_local == '0) begin
                Hamiltonian <= '0; 
            end
            else begin
                Hamiltonian <= Hamiltonian_local / 128;
            end
            phase_mem <= phase_update;
            cnt = cnt + 1;
        end
    end

    genvar i;
    generate
        for (i = 0; i < NUM_SPINS; i = i + 1) begin
            PE_1D  #(
                .global_index(i)
            )  PE_ins(
                .clk(clk),
                .reset(reset),
                .ena(ena),
                .grad_count(5),
                .self_phase(coupling_phase[i]),
                .coupling_phase(coupling_phase),
                .coupling_factor(coupling_factor[i]),
                .sample_time(4),
                .random_signal(signal_random[i]),
                .self_phase_update(),
                .out_phase(phase_update[i]),
                .Hamiltonian(Hamiltonian_mem[i])
            );
        end
    endgenerate

    system_adder adder_H(
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .input_matrix(Hamiltonian_mem),
        .sum(Hamiltonian_local)
    );
    
endmodule

`endif