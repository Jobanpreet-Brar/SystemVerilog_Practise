`timescale 1ns / 1ps

module spi_master(
    //Host Side Signals
    input logic clk,
    input logic rst_n,
    input logic [7:0] data_in,
    input logic din_valid,
    output logic din_ready,
    //Slave Side Signals
    output logic sclk,
    output logic MOSI,
    input logic MISO,
    output logic cs_n 
    );
    
    typedef enum logic {IDLE, TRANSFER} state_t;
    state_t state;
    logic [3:0]clk_div_cnt;
    logic [2:0]bit_cnt;
    logic [7:0]shift_reg;
    
    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= IDLE;
            din_ready <= 0;
            MOSI <= 0;
            sclk <= 0;
            cs_n <= 1;
            clk_div_cnt <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE : begin
                    din_ready <= 1;
                    shift_reg <= data_in;
                    if (din_valid == 1) begin
                        cs_n <= 0;
                        state <= TRANSFER;
                    end
                end
                
                TRANSFER : begin
                    din_ready <= 0;
                    MOSI <= shift_reg[7];
                    if (clk_div_cnt < 4'b1001) begin
                        clk_div_cnt <= clk_div_cnt + 1;
                    end else begin
                        shift_reg <= {shift_reg[6:0], 1'b0};
                        clk_div_cnt <= 0;
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7) begin
                            cs_n <= 1;
                            state <= IDLE;
                            bit_cnt <= 0;
                        end
                    end
                    if (clk_div_cnt < 4'b0101) begin
                        sclk <= 0;
                    end else begin
                        sclk <= 1;
                    end
                end
                default : state <= IDLE;            
            endcase
        end
    end
endmodule
