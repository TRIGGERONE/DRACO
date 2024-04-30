/*
 * @Author: Haotian Lu
 * @Date: 2024-01-17 16:27:26 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-01-17 17:53:45
 */
// ! This is helped by TRNG

`timescale 10 ns / 1 ns

`include "common_pkg_Script.sv"

`ifndef in_PE_phase_rand_DEF
    `define in_PE_phase_rand_DEF

module in_PE_phase_rand (     
    input logic                         clk, ena, reset,
    input phase_t                       in_self_phase,
    output phase_t                      self_phase_rand
);
    phase_t_reg                         out_phase;

    always_ff @( posedge clk ) begin 
        if( reset == '1 ) begin
            out_phase = 'x;     // ? To output a X's state
        end
        else if (ena) begin
            out_phase <= $random();
        end
        else if ( ~ena ) begin
            out_phase <= in_self_phase;
        end
    end

    assign self_phase_rand = out_phase;
    
endmodule

`endif //macro