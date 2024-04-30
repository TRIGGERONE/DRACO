/*
 * @Author: Haotian Lu
 * @Date: 2024-01-04 18:29:40 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2024-04-06 15:20:17
 */

`ifndef GENERAL_PKG
    `define GENERAL_PKG

    `ifdef GATE_NETLIST
        `define USE_TREE_MACRO
    `endif
    
    package general_pkg;
        parameter RESET_STATE = 0;
    endpackage

    import general_pkg::*;

`endif

`ifndef HW_CONFIG_PKG
    `define HW_CONFIG_PKG

    `define PHASE_BITWIDTH  6
    `define NUM_SPINS       64
    // ?: Interconnection parameters

    package hw_config_pkg;

        parameter PHASE_BITWIDTH        = 6;
        parameter NUM_SPINS             = 64;
        parameter NUM_SPINS_EXP         = $clog2(NUM_SPINS);
        parameter NL_OUT_PHASE_BITWIDTH = PHASE_BITWIDTH + 2;

        //PE index address related
        parameter ADDR_BITWIDTH         = $clog2(NUM_SPINS);
        // parameter seed =  ;
        //

        typedef logic [PHASE_BITWIDTH - 1:0]                    phase_t;
        typedef reg [PHASE_BITWIDTH - 1:0]                      phase_t_reg;
        typedef phase_t [NUM_SPINS - 1:0]                       phase_t_mem;
        typedef logic signed [NL_OUT_PHASE_BITWIDTH - 1:0]      NL_out_phase_t;
        typedef reg signed [NL_OUT_PHASE_BITWIDTH - 1:0]        NL_out_phase_t_reg;
        typedef NL_out_phase_t [NUM_SPINS_EXP - 1:0]            NL_out_phase_t_mem;
        
    endpackage

        import hw_config_pkg::*;

`endif