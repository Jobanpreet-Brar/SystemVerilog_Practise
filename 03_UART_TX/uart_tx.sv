`timescale 1ns / 1ps
module uart_tx(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [7:0]data_in,
    output logic tx_out,
    output logic done
    );
    
    logic [9:0]shifter;
    logic [3:0]bit_index;
    
    typedef enum logic [1:0]{
        IDLE = 2'b00,
        SENDING = 2'b01,
        DONE = 2'b10 
        } state_t;
        
    state_t state;
        
    always_ff @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
            tx_out <= 1;
            done <= 0;
            shifter <= 0;
            bit_index <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE : begin
                    tx_out <= 1;
                    if (load) begin
                        shifter <= {1'b1,data_in,1'b0};
                        state <= SENDING;
                        bit_index <= 0;
                    end
                end
                SENDING : begin
                    tx_out <= shifter[0];
                    shifter <= shifter>>1;
                    bit_index <= bit_index+1;
                    if (bit_index==9) begin
                        state <= DONE;
                    end
                end
                
                DONE : begin
                    done <= 1;
                    tx_out <= 1;
                    state <= IDLE;
                end
                
                default : begin
                    state <= IDLE;
                end
           endcase
        end
    end
endmodule
