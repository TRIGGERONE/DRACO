/*
 * @Author: Haotian Lu
 * @Date: 2023-12-26 23:11:43 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2023-12-28 17:03:02
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"

`include "NL_DAC.sv"

module estimator (
    input logic                                         clk,    reset,    ena,
    input phase_t                                       self_phase,
    input phase_t                                       coupling_phase,
    input int                                           coupling_factor,
    // input logic [num_spin_exp - 1:0]                    global_index,
    output NL_out_phase_t                               out_gradient,
    output NL_out_phase_t                               out_Hamiltonian
);
    phase_t_reg                                         local_self_phase, local_coupling_phase;
    NL_out_phase_t                                      local_grad, local_Hamiltonian;

    //! Difference between local_self_phase and self_phase?
    //! Load self_phase from in-PE MEM into estimator and 

    always_ff @( posedge clk ) begin
        if (reset) begin
            local_self_phase <= '0;
            local_coupling_phase <= '0;
            out_gradient <= '0;
            out_Hamiltonian <= '0;
        end
        else if (coupling_factor != 0) begin
            local_self_phase <= self_phase;
            local_coupling_phase <= coupling_phase;
            out_gradient <= coupling_factor * local_grad;
            out_Hamiltonian <= coupling_factor * local_Hamiltonian;
        end
        else begin
            local_self_phase <= self_phase;
            local_coupling_phase <= coupling_phase;
            out_gradient <= '0;
            out_Hamiltonian <= '0;
        end
    end

    Non_Linear_DAC in_PE_grad_dac    (
        .ena            (ena                        ),
        .mode           (1'b0                       ),
        .phase_1        (local_self_phase           ),
        .phase_2        (local_coupling_phase       ),
        .Result_NL      (local_grad                 )
    );

    Non_Linear_DAC in_PE_H_dac (
        .ena        (ena                     ),    
        .mode       (1'b1                    ),
        .phase_1    (local_self_phase        ),
        .phase_2    (local_coupling_phase    ),
        .Result_NL  (local_Hamiltonian       )
    );

endmodule