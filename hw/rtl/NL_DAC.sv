/*
 * @Author: Haotian Lu
 * @Date: 2023-12-26 17:33:36 
 * @Last Modified by: Haotian Lu
 * @Last Modified time: 2023-12-26 23:30:50
 */
`timescale 1 ns / 100 ps

`include "common_pkg_SCRIPT.sv"

module Non_Linear_DAC ( // ? Combinaional logic, no need to use timing signal? 
        input logic                                         ena,    mode,
        input phase_t                                       phase_1,
        input phase_t                                       phase_2,
        output NL_out_phase_t                               Result_NL  //first bit to determine positive or negative
    );
    
    phase_t_reg                                             delta_phase;
    reg [PHASE_BITWIDTH - 3:0]                              intermediate_phase;
    NL_out_phase_t                                          result;

    assign delta_phase = phase_1 - phase_2;

    // FIXME: Use CAM to assign different values for cases
    // Now use combinational logic or assignment as LUTs to access the values from in-PE reg banks
    // Use LUTs to store all inter_s below
    NL_out_phase_t_reg inter_0, inter_1, inter_2, inter_3, inter_4, inter_5, inter_6, inter_7, inter_8, inter_9, inter_10, inter_11, inter_12, inter_13, inter_14, inter_15;
    
    assign inter_0  =   7'b0000000;
    assign inter_1  =   7'b0001111;    
    assign inter_2  =   7'b0011101;
    assign inter_3  =   7'b0101010;
    assign inter_4  =   7'b0110110;
    assign inter_5  =   7'b1000001;
    assign inter_6  =   7'b1001011;
    assign inter_7  =   7'b1010100;
    assign inter_8  =   7'b1011101;
    assign inter_9  =   7'b1100100;
    assign inter_10 =   7'b1101011;
    assign inter_11 =   7'b1110000;
    assign inter_12 =   7'b1110101;
    assign inter_13 =   7'b1111000;
    assign inter_14 =   7'b1111011;
    assign inter_15 =   7'b1111100;
    //FIXME: Use CAM to assign different values for cases
    
    always @(*) begin
        if (mode == 1'b0 && ena) begin     // this mode is for cosine evaluation
            intermediate_phase = delta_phase[PHASE_BITWIDTH - 3:0];
            case (delta_phase[PHASE_BITWIDTH - 1: PHASE_BITWIDTH -2])
                2'b00: begin
                    case (intermediate_phase)
                        4'b0000: begin result = {1'b0, inter_0};    end
                        4'b0001: begin result = {1'b0, inter_1};    end
                        4'b0010: begin result = {1'b0, inter_2};    end
                        4'b0011: begin result = {1'b0, inter_3};    end
                        4'b0100: begin result = {1'b0, inter_4};    end
                        4'b0101: begin result = {1'b0, inter_5};    end
                        4'b0110: begin result = {1'b0, inter_6};    end
                        4'b0111: begin result = {1'b0, inter_7};    end
                        4'b1000: begin result = {1'b0, inter_8};    end
                        4'b1001: begin result = {1'b0, inter_9};    end
                        4'b1010: begin result = {1'b0, inter_10};   end
                        4'b1011: begin result = {1'b0, inter_11};   end
                        4'b1100: begin result = {1'b0, inter_12};   end
                        4'b1101: begin result = {1'b0, inter_13};   end
                        4'b1110: begin result = {1'b0, inter_14};   end
                        4'b1111: begin result = {1'b0, inter_15};   end
                        default: begin result = {1'b0, inter_0};    end
                    endcase
                end 
                2'b01: begin
                    case (intermediate_phase)
                        4'b1111: begin result = {1'b0, inter_1};    end
                        4'b1110: begin result = {1'b0, inter_1};    end
                        4'b1101: begin result = {1'b0, inter_2};    end
                        4'b1100: begin result = {1'b0, inter_3};    end
                        4'b1011: begin result = {1'b0, inter_4};    end
                        4'b1010: begin result = {1'b0, inter_5};    end
                        4'b1001: begin result = {1'b0, inter_6};    end
                        4'b1000: begin result = {1'b0, inter_7};    end
                        4'b0111: begin result = {1'b0, inter_8};    end
                        4'b0110: begin result = {1'b0, inter_9};    end
                        4'b0101: begin result = {1'b0, inter_10};   end
                        4'b0100: begin result = {1'b0, inter_11};   end
                        4'b0011: begin result = {1'b0, inter_12};   end
                        4'b0010: begin result = {1'b0, inter_13};   end
                        4'b0001: begin result = {1'b0, inter_14};   end
                        4'b0000: begin result = {1'b0, inter_15};   end
                    endcase
                end
                2'b10: begin
                    case(intermediate_phase)
                        4'b0000: begin result = {1'b1, inter_0};    end
                        4'b0001: begin result = {1'b1, inter_1};    end
                        4'b0010: begin result = {1'b1, inter_2};    end
                        4'b0011: begin result = {1'b1, inter_3};    end
                        4'b0100: begin result = {1'b1, inter_4};    end
                        4'b0101: begin result = {1'b1, inter_5};    end
                        4'b0110: begin result = {1'b1, inter_6};    end
                        4'b0111: begin result = {1'b1, inter_7};    end
                        4'b1000: begin result = {1'b1, inter_8};    end
                        4'b1001: begin result = {1'b1, inter_9};    end
                        4'b1010: begin result = {1'b1, inter_10};   end
                        4'b1011: begin result = {1'b1, inter_11};   end
                        4'b1100: begin result = {1'b1, inter_12};   end
                        4'b1101: begin result = {1'b1, inter_13};   end
                        4'b1110: begin result = {1'b1, inter_14};   end
                        4'b1111: begin result = {1'b1, inter_15};   end
                    endcase
                end
                2'b11: begin
                    case(intermediate_phase)
                        4'b1111: begin result = {1'b1, inter_1};    end
                        4'b1110: begin result = {1'b1, inter_1};    end
                        4'b1101: begin result = {1'b1, inter_2};    end
                        4'b1100: begin result = {1'b1, inter_3};    end
                        4'b1011: begin result = {1'b1, inter_4};    end
                        4'b1010: begin result = {1'b1, inter_5};    end
                        4'b1001: begin result = {1'b1, inter_6};    end
                        4'b1000: begin result = {1'b1, inter_7};    end
                        4'b0111: begin result = {1'b1, inter_8};    end
                        4'b0110: begin result = {1'b1, inter_9};    end
                        4'b0101: begin result = {1'b1, inter_10};   end
                        4'b0100: begin result = {1'b1, inter_11};   end
                        4'b0011: begin result = {1'b1, inter_12};   end
                        4'b0010: begin result = {1'b1, inter_13};   end
                        4'b0001: begin result = {1'b1, inter_14};   end
                        4'b0000: begin result = {1'b1, inter_15};   end
                    endcase
                end
                default: begin  result = '0;   end
            endcase
        end
        else if (mode == 1'b1 && ena) begin    // this mode is for sine evaluation
            case (delta_phase[PHASE_BITWIDTH - 1: PHASE_BITWIDTH - 2])
                2'b00: begin
                    case (delta_phase[PHASE_BITWIDTH - 3:0])
                        4'b1111: begin result = {1'b0, inter_1};    end
                        4'b1110: begin result = {1'b0, inter_1};    end
                        4'b1101: begin result = {1'b0, inter_2};    end
                        4'b1100: begin result = {1'b0, inter_3};    end
                        4'b1011: begin result = {1'b0, inter_4};    end
                        4'b1010: begin result = {1'b0, inter_5};    end
                        4'b1001: begin result = {1'b0, inter_6};    end
                        4'b1000: begin result = {1'b0, inter_7};    end
                        4'b0111: begin result = {1'b0, inter_8};    end
                        4'b0110: begin result = {1'b0, inter_9};    end
                        4'b0101: begin result = {1'b0, inter_10};   end
                        4'b0100: begin result = {1'b0, inter_11};   end
                        4'b0011: begin result = {1'b0, inter_12};   end
                        4'b0010: begin result = {1'b0, inter_13};   end
                        4'b0001: begin result = {1'b0, inter_14};   end
                        4'b0000: begin result = {1'b0, inter_15};   end
                    endcase
                end 
                2'b01: begin
                    case (delta_phase[PHASE_BITWIDTH - 3:0])
                        4'b0000: begin result = {1'b1, inter_0};    end
                        4'b0001: begin result = {1'b1, inter_1};    end
                        4'b0010: begin result = {1'b1, inter_2};    end
                        4'b0011: begin result = {1'b1, inter_3};    end
                        4'b0100: begin result = {1'b1, inter_4};    end
                        4'b0101: begin result = {1'b1, inter_5};    end
                        4'b0110: begin result = {1'b1, inter_6};    end
                        4'b0111: begin result = {1'b1, inter_7};    end
                        4'b1000: begin result = {1'b1, inter_8};    end
                        4'b1001: begin result = {1'b1, inter_9};    end
                        4'b1010: begin result = {1'b1, inter_10};   end
                        4'b1011: begin result = {1'b1, inter_11};   end
                        4'b1100: begin result = {1'b1, inter_12};   end
                        4'b1101: begin result = {1'b1, inter_13};   end
                        4'b1110: begin result = {1'b1, inter_14};   end
                        4'b1111: begin result = {1'b1, inter_15};   end
                    endcase
                end
                2'b10: begin
                    case(delta_phase[PHASE_BITWIDTH - 3:0])
                        4'b1111: begin result = {1'b1, inter_1};    end
                        4'b1110: begin result = {1'b1, inter_1};    end
                        4'b1101: begin result = {1'b1, inter_2};    end
                        4'b1100: begin result = {1'b1, inter_3};    end
                        4'b1011: begin result = {1'b1, inter_4};    end
                        4'b1010: begin result = {1'b1, inter_5};    end
                        4'b1001: begin result = {1'b1, inter_6};    end
                        4'b1000: begin result = {1'b1, inter_7};    end
                        4'b0111: begin result = {1'b1, inter_8};    end
                        4'b0110: begin result = {1'b1, inter_9};    end
                        4'b0101: begin result = {1'b1, inter_10};   end
                        4'b0100: begin result = {1'b1, inter_11};   end
                        4'b0011: begin result = {1'b1, inter_12};   end
                        4'b0010: begin result = {1'b1, inter_13};   end
                        4'b0001: begin result = {1'b1, inter_14};   end
                        4'b0000: begin result = {1'b1, inter_15};   end
                    endcase
                end
                2'b11: begin
                    case(delta_phase[PHASE_BITWIDTH - 3:0])
                        4'b0000: begin result = {1'b0, inter_0};    end
                        4'b0001: begin result = {1'b0, inter_1};    end
                        4'b0010: begin result = {1'b0, inter_2};    end
                        4'b0011: begin result = {1'b0, inter_3};    end
                        4'b0100: begin result = {1'b0, inter_4};    end
                        4'b0101: begin result = {1'b0, inter_5};    end
                        4'b0110: begin result = {1'b0, inter_6};    end
                        4'b0111: begin result = {1'b0, inter_7};    end
                        4'b1000: begin result = {1'b0, inter_8};    end
                        4'b1001: begin result = {1'b0, inter_9};    end
                        4'b1010: begin result = {1'b0, inter_10};   end
                        4'b1011: begin result = {1'b0, inter_11};   end
                        4'b1100: begin result = {1'b0, inter_12};   end
                        4'b1101: begin result = {1'b0, inter_13};   end
                        4'b1110: begin result = {1'b0, inter_14};   end
                        4'b1111: begin result = {1'b0, inter_15};   end
                    endcase
                end
                default: begin  result = '0;               end
            endcase
        end

        Result_NL = result;
    end
endmodule