`timescale 1ns / 1ps
module tb_led_blinker;
  logic led;
  logic clk = 0;
  logic rst;
  
  led_blinker dut (.rst(rst), .clk(clk), .led(led));
  
  always #25 clk <= ~clk;
  
initial begin
    rst = 1;
    #100;
    rst = 0;
    #50000;
    $monitor("Time: %0t | Reset: %b | LED: %b | Count (Hex): %b", 
             $time, rst, led, dut.count);
    $finish;
  end
endmodule
