/*
 * @Author: Haotian Lu
 * @Date: 2023-12-27 18:58:32 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2023-12-27 19:38:23
 */
`timescale 1 ns / 100 ps
`include "adder.sv"
`include "common_pkg_SCRIPT.sv"
module adder_tb();

reg     [NL_OUT_PHASE_BITWIDTH - 1 :0]   in_A [NUM_SPINS - 1: 0];
wire    [NL_OUT_PHASE_BITWIDTH - 1 + NUM_SPINS_EXP: 0]  sum;
reg     clk, reset, ena;

initial begin
    for(int i = 0; i < NUM_SPINS; i = i + 1) begin
        in_A[i] = i;
    end
    clk = 1'b1;
    ena = 1'b1;
    reset = 1'b0;
    // sum = 14'h10;
end

// always #20 in_A = in_A + 2'b10;
// always #30 in_B = in_B + 2'b01;
always #40 clk  = ~clk;

// adder #(
//     .bitwidth (3'd6)
// )
// u_adder(
//     .INPUT_A (in_A ),
//     .INPUT_B (in_B ),
//     .CIN     (cin     ),
//     .SUM     (sum     ),
//     .COUT    (cout    )
// );

Adder64to1 unitest(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .input_matrix(in_A),
    .sum(sum)
);

endmodule