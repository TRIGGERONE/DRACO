/*
 * @Author: Haotian Lu
 * @Date: 2023-12-26 22:56:46 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2023-12-28 15:50:15
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"

`ifndef grad_counter_DEF
    `define grad_counter_DEF

module grad_counter
    (
        input logic                                     clk, reset,
        input NL_out_phase_t                            self_grad,
        input int                                       grad_count_T, 
        input logic                                     grad_counter_ena,
        // output logic [grad_count_bitwidth - 1:0]        grad_count,
        output logic                                    random_self_phase 
    );

    int grad_count =                                    grad_count_T;

    always @(posedge clk) begin
        if (reset && grad_counter_ena) begin
            grad_count <= grad_count_T; 
        end
        else begin
            if(grad_counter_ena && self_grad == '0) begin
                grad_count <= grad_count - 1;
            end
            else begin
                grad_count <= grad_count_T;
            end
        end

        random_self_phase <= (grad_count == 0) ? 1'b1 : 1'b0;
    end
    
endmodule

`endif //macro