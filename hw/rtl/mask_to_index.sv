/*
 * @Author: Haotian Lu
 * @Date: 2024-01-11 16:25:10 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-01-14 16:14:52
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"

`ifndef count_one_in_mask_DEF
    `define count_one_in_mask_DEF

module count_one_in_mask (
    input logic                                 clk, reset,
    input logic [NUM_SPINS - 1:0]               mask,
    output int                                  num_ones
    // input logic                                 mode,
    // output [$countbits(mask, '1) - 1:0]         sample_values
);
    reg [NUM_SPINS - 1:0]   SEED = mask;

    always_ff @( posedge clk ) begin
        if (reset) begin
            num_ones <= 0;
        end
        else begin
            num_ones <= $countones(SEED);
        end
    end
    
endmodule
`endif //count_one_in_mask_DEF

// module mask_to_index (
//     input logic                     clk, reset,
//     input logic [NUM_SPINS - 1:0]   mask,
//     output int                      ;
// );
    
// endmodule