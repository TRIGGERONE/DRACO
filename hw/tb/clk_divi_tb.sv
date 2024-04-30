/*
 * @Author: Haotian Lu
 * @Date: 2024-01-18 16:26:34 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-01-18 16:40:27
 */

`timescale 10 ns / 1 ns

module clk_division_tb();

reg clk, reset, clk_mul;
int times;

initial begin
    clk = 1'b0;
    reset = 1'b0;
    times = 10;
    // clk_mul = clk;
end

always #2 clk = ~ clk;

clk_division clk_division_test(
    .clk     (clk     ),
    .reset   (reset   ),
    .times   (times   ),
    .clk_mul (clk_mul )
);

endmodule
