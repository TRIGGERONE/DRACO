/*
 * @Author: Haotian Lu
 * @Date: 2024-01-18 16:15:39 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-01-18 17:21:49
 */

`timescale 10 ns / 1 ns

`ifndef clk_divi_DEF
    `define clk_divi_DEF

module clk_division (
    input logic                     clk, reset,
    input int                       times,
    output reg                      clk_mul
);

    int count;
    
    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            // count <= 0;
            clk_mul <= 1'b0;
        end
        else if (count == 0) begin
            clk_mul = clk;
            count <= count + 1;
        end
        else if (count == times /2) begin
            clk_mul <= ~ clk_mul;
            count <= 1;
        end
        else begin
            count <= count + 1;
            clk_mul <= clk_mul;
        end
    end
    
endmodule

`endif //clk_divi_DEF