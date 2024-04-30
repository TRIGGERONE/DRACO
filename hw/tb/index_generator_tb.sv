/*
 * @Author: Haotian Lu
 * @Date: 2024-01-05 16:06:31 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-01-05 17:30:54
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"
`include "index_generator.sv"

module index_generator_tb ();

reg [3:0] seed;
reg clk, reset, ena;

logic [ADDR_BITWIDTH - 1:0] index_1, index_2;

initial begin
    clk  = 1'b1;
    reset = 1'b0;
    ena = 1'b1;
end

index_generator u_index_generator(
    .clk      (clk      ),
    .reset    (reset    ),
    .ena      (ena      ),
    .seed_dis (seed     ),
    .index_1  (index_1  ),
    .index_2  (index_2  )
);

always #20 clk = ~clk;

endmodule
