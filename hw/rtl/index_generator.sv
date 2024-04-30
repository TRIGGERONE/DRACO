/*
 * @Author: Haotian Lu
 * @Date: 2024-01-05 15:51:12 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-01-14 16:14:26
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"

`ifndef index_generator_def
    `define index_generator_def

module index_generator #(
    parameter sample = 4
)(
    input                                               clk, reset, ena,
    // input integer                                       seed_dis,
    // input logic [NUM_SPINS - 1:0]                       mask,
    output logic [ADDR_BITWIDTH - 1:0]                  index [sample - 1: 0]
);
    // reg [NUM_SPINS - 1:0]                               seed = mask;  // Bit-wise AND

    always_ff @( posedge clk ) begin
        if (reset) begin
            for (int i = 0; i < sample; i = i + 1) begin
                index[i] = '0;
            end
        end
        else begin
            for (int i = 0; i < sample; i = i + 1) begin
                index[i] = $random();
            end
        end
    end
    
endmodule
`endif //index_generator_def