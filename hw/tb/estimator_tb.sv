/*
 * @Author: Haotian Lu 
 * @Date: 2023-12-27 19:52:04 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2023-12-27 19:56:47
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"
module estimator_tb ();

reg                 clk;
reg                 reset;
reg                 ena;
phase_t             self_phase;
phase_t             coupling_phase;

NL_out_phase_t      out_gradient;
NL_out_phase_t      out_Hamiltonian;

initial begin
    clk = 1'b1;
    reset = 1'b0;
    ena = 1'b1;
    self_phase = 6'b010101;
    coupling_phase = 6'b100100;
end

always #2 clk = ~clk;
always #8 coupling_phase = coupling_phase + 2'b10;

#60 ena = ~ena;
#80 reset = ~reset;

estimator u_estimator(
    .clk             (clk             ),
    .reset           (reset           ),
    .ena             (ena             ),
    .self_phase      (self_phase      ),
    .coupling_phase  (coupling_phase  ),
    .coupling_factor (1),
    .out_gradient    (out_gradient    ),
    .out_Hamiltonian (out_Hamiltonian )
);

endmodule
