/*
 * @Author: Haotian Lu
 * @Date: 2023-12-27 18:26:49 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2023-12-27 19:25:07
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"

`ifndef alu_adder_def
    `define alu_adder_def
module alu_adder #(
    parameter bitwidth
)
(
    input logic                                     clk, reset, ena,
    input logic unsigned [bitwidth - 1:0]             INPUT_A,
    input logic unsigned [bitwidth - 1:0]             INPUT_B,
    // input logic                             CIN,
    output logic unsigned [bitwidth:0]               SUM
    // output logic [bitwidth - 1:0]           COUT
);
    reg signed [bitwidth - 1:0]                     in_A, in_B;

    always_comb begin
        if (ena) begin
            in_A = INPUT_A;
            in_B = INPUT_B;
        end
        else begin
            in_A = 'x;
            in_B = 'x;
        end
    end

    always_ff @( posedge clk ) begin
        if (reset) begin
            SUM <= '0;
        end
        else begin
            SUM <= in_A + in_B;
        end
    end
    
endmodule


module Adder64to1 (
    input logic                                                     clk, reset, ena,
    input [NL_OUT_PHASE_BITWIDTH - 1 : 0]                           input_matrix [NUM_SPINS - 1: 0],
    output logic [NL_OUT_PHASE_BITWIDTH - 1 + NUM_SPINS_EXP: 0]     sum
);

    always @(posedge clk) begin
        sum <= 0;
        if (reset) begin
            sum <= sum;
        end
        else if (ena) begin
            sum <= input_matrix[0] + input_matrix[1] + input_matrix[2] + input_matrix[3] + input_matrix[4]
            + input_matrix[5] + input_matrix[6] + input_matrix[7] + input_matrix[8]
            + input_matrix[9] + input_matrix[10] + input_matrix[11] + input_matrix[12]
            + input_matrix[13] + input_matrix[14] + input_matrix[15] + input_matrix[16]
            + input_matrix[17] + input_matrix[18] + input_matrix[19] + input_matrix[20]
            + input_matrix[21] + input_matrix[22] + input_matrix[23] + input_matrix[24]
            + input_matrix[25] + input_matrix[26] + input_matrix[27] + input_matrix[28]
            + input_matrix[29] + input_matrix[30] + input_matrix[31] + input_matrix[32]
            + input_matrix[33] + input_matrix[34] + input_matrix[35] + input_matrix[36]
            + input_matrix[37] + input_matrix[38] + input_matrix[39] + input_matrix[40]
            + input_matrix[41] + input_matrix[42] + input_matrix[43] + input_matrix[44]
            + input_matrix[45] + input_matrix[46] + input_matrix[47] + input_matrix[48]
            + input_matrix[49] + input_matrix[50] + input_matrix[51] + input_matrix[52]
            + input_matrix[53] + input_matrix[54] + input_matrix[55] + input_matrix[56]
            + input_matrix[57] + input_matrix[58] + input_matrix[59] + input_matrix[60]
            + input_matrix[61] + input_matrix[62] + input_matrix[63];
        end
        else begin
            sum <= '0;
        end

        // local_sum <= '0;
    end
endmodule

module system_adder(
    input logic                                                     clk, reset, ena,
    input [NL_OUT_PHASE_BITWIDTH + NUM_SPINS_EXP - 1: 0]            input_matrix [NUM_SPINS - 1: 0],
    output logic [NL_OUT_PHASE_BITWIDTH + 2 * NUM_SPINS_EXP - 1: 0]     sum
);

    always @(posedge clk) begin
        sum <= 0;
        if (reset) begin
            sum <= sum;
        end
        else if (ena) begin
            sum <= input_matrix[0] + input_matrix[1] + input_matrix[2] + input_matrix[3] + input_matrix[4]
            + input_matrix[5] + input_matrix[6] + input_matrix[7] + input_matrix[8]
            + input_matrix[9] + input_matrix[10] + input_matrix[11] + input_matrix[12]
            + input_matrix[13] + input_matrix[14] + input_matrix[15] + input_matrix[16]
            + input_matrix[17] + input_matrix[18] + input_matrix[19] + input_matrix[20]
            + input_matrix[21] + input_matrix[22] + input_matrix[23] + input_matrix[24]
            + input_matrix[25] + input_matrix[26] + input_matrix[27] + input_matrix[28]
            + input_matrix[29] + input_matrix[30] + input_matrix[31] + input_matrix[32]
            + input_matrix[33] + input_matrix[34] + input_matrix[35] + input_matrix[36]
            + input_matrix[37] + input_matrix[38] + input_matrix[39] + input_matrix[40]
            + input_matrix[41] + input_matrix[42] + input_matrix[43] + input_matrix[44]
            + input_matrix[45] + input_matrix[46] + input_matrix[47] + input_matrix[48]
            + input_matrix[49] + input_matrix[50] + input_matrix[51] + input_matrix[52]
            + input_matrix[53] + input_matrix[54] + input_matrix[55] + input_matrix[56]
            + input_matrix[57] + input_matrix[58] + input_matrix[59] + input_matrix[60]
            + input_matrix[61] + input_matrix[62] + input_matrix[63];
        end
        else begin
            sum <= '0;
        end

        // local_sum <= '0;
    end
endmodule

`endif //alu_adder_def