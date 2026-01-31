`timescale 1ns / 1ps
module led_blinker(
  input logic clk,
  input logic rst,
  output logic led);
  
  reg [23:0]count;
  always_ff @(posedge clk) begin
    if (rst) 
      count <= '0;
    else
      count <= count + 1;
  end
  assign led = count[4];
endmodule
