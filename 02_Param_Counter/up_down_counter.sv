`timescale 1ns / 1ps
module up_down_counter #(parameter int unsigned WIDTH=2)(
    input logic direction,
    input logic clk,
    input logic rst,
    output logic overflow,
    output logic [WIDTH-1:0]out
    );
    always_ff @(posedge clk) begin
        overflow <= 0;
        if (rst) out <= 0;
        else begin
            if (direction) begin
                out <= out + 1;
                overflow <= (out=={WIDTH{1'b1}}) ? 1 : 0;
            end else begin
                out <= out - 1;
                overflow <= (out) ? 0 : 1 ;
            end 
        end
    end
endmodule
