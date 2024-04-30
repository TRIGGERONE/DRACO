/*
 * @Author: Haotian Lu
 * @Date: 2023-12-26 22:56:36 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-04-06 17:35:13
 */
`timescale 10 ns / 1 ns

`ifndef PE_1D_DEF
    `define PE_1D_DEF
`include "common_pkg_SCRIPT.sv"

`include "adder.sv"
`include "grad_counter.sv"
`include "estimator.sv"
`include "index_generator.sv"
// `include "basic_blocks.sv"

//! Top module of Processing Element, include 
//! (1) estimator (grad_estimator + H_estimator) (2) grad_counter (3) Timing and address 
//! control unit
module PE_1D #(
    parameter global_index
    ) (
    input logic                                                     clk, reset, ena, clk_mul,
    // input logic                                                  grad_counter_ena,
    input int                                                       grad_count,
    // input logic [NUM_SPINS_EXP - 1:0]                            global_index,
    input phase_t_reg                                               self_phase,
    input var phase_t_mem                                           coupling_phase,
    input int                                                       coupling_factor [NUM_SPINS - 1:0] ,

    input int                                                       sample_time,

    output logic [NUM_SPINS - 1: 0]                                 random_signal,
    output phase_t_reg                                              self_phase_update,
    output phase_t_reg                                              out_phase,              
    output logic [NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1: 0]     Hamiltonian
);
    // phase_t_reg                                                  self_phase = coupling_phase[global_index]; 
    reg [NL_OUT_PHASE_BITWIDTH - 1: 0]                              out_grad [NUM_SPINS - 1 : 0];
    reg [NL_OUT_PHASE_BITWIDTH - 1: 0]                              out_H [NUM_SPINS - 1 : 0];

    // reg [3 - 1:0]                                           coupling_mask [NUM_SPINS - 1:0] = coupling_factor;
    reg [NUM_SPINS_EXP - 1:0]                                       index [4 - 1: 0];

    phase_t_reg                                                     local_phase = self_phase;
    phase_t_reg                                                     self_phase_temp;

    integer                                                         count = 0; // ? Used to count the number of self_phase update iterations
    reg [NUM_SPINS - 1: 0]                                          random_self_phase;
    reg                                                             ena_real;
    // assign coupling_phase[global_index] = self_phase;

    int                                                             sampled_time = 0;
    reg [NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1: 0]              grad_sum;
    reg [NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1: 0]              H_sum;


    always_ff @( posedge clk ) begin
        self_phase_temp <= (count == 0 || count == 1 || count == 2) ? self_phase : self_phase_update;
        local_phase <= self_phase;

        if (count <= 5) begin   // ! Initialization of self_phase_update
            if (grad_sum[NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1] == 1'b0) begin
                self_phase_update <= self_phase_temp - grad_sum[NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 2]; 
            end
            else if (grad_sum[NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1] == 1'b1) begin
                self_phase_update <= self_phase_temp + grad_sum[NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 2];
            end
            count <= count + 1;
        end
        else begin
            self_phase_update <= self_phase_update;
        end
        Hamiltonian <= H_sum;
    end

    always_ff @(posedge clk) begin
        if (sampled_time < sample_time) begin
            ena_real <= ena;
            out_phase <= self_phase_update;
        end
        else begin
            ena_real <= 0;
            out_phase <= out_phase;
        end
    end

    // This section: count the coupled index
    reg [NUM_SPINS_EXP - 1: 0] coupled_index;
    always @(*) begin
        coupled_index = global_index;   //Initialization
        for (int i = 0; i < NUM_SPINS; i = i + 1) begin
            if (coupling_factor[i] == 0) begin
                coupled_index = {coupled_index[NUM_SPINS_EXP - 1: 0], i};
            end
        end
    end

    index_generator #(
        .sample(4)
    ) in_PE_index_generator(
    	.clk      (clk      ),
        .reset    (reset    ),
        .ena      (ena_real ),
        // .seed_dis (         ),
        .index    (index)
    );

    genvar i;
    generate
        for (i = 0; i < NUM_SPINS; i = i + 1) begin
            estimator in_PE_estimator(
                .clk(clk),
                .reset(reset),
                .ena(ena_real),
                .self_phase((count == 0 || count == 1 || count == 2) ? self_phase: self_phase_update),
                .coupling_phase(coupling_phase[i]),
                .coupling_factor(coupling_factor[i]),
                .out_gradient (out_grad[i]),
                .out_Hamiltonian(out_H[i])
            );

            grad_counter in_PE_grad_counter(
                .clk(clk),
                .reset(reset),
                .grad_count_T(5),
                .self_grad(out_grad[i]),
                .grad_counter_ena(ena_real),
                .random_self_phase(random_self_phase[i])
            );

            assign random_signal[i] = (random_self_phase[i]) ? 1'b1 : 1'b0;
        end
    endgenerate

    // ? pre-process to make index_1 and index_2 not equal to the index of PE or un-coupled index
    
    Adder64to1 alu_adder_grad (
    	.clk            (clk           ),
        .reset          (reset         ),
        .ena            (ena_real      ),
        .input_matrix   (out_grad      ),
        .sum            (grad_sum      )
    );

    Adder64to1 alu_adder_H (
    	.clk            (clk           ),
        .reset          (reset         ),
        .ena            (ena_real      ),
        .input_matrix   (out_H         ),
        .sum            (H_sum         )
    );

    clk_division u_clk_division(
    	.clk     (clk     ),
        .reset   (reset   ),
        .times   (2       ),
        .clk_mul (clk_mul )
    );
    

endmodule
`endif //PE_1D_DEF

