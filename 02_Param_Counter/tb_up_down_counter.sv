`timescale 1ns / 1ps
module tb_up_down_counter;
    logic clk = 0;
    logic rst, direction, ovf1, ovf2;
    localparam width1=4;
    localparam width2=8;
    
    logic [width1-1:0]out1;
    logic [width2-1:0]out2;
    up_down_counter #(.WIDTH(width1))dut1 (.rst(rst), .clk(clk), .direction(direction), .overflow(ovf1), .out(out1));
    
    up_down_counter #(.WIDTH(width2))dut2 (.rst(rst), .clk(clk), .direction(direction), .overflow(ovf2), .out(out2));
    always #5 clk <= ~clk;
    
    initial begin
        $monitor("Output1 = %h, Output2 = %h, Time = %t", out1, out2, $time);
        rst = 1;
        direction = 1;
        #10;
        rst = 0;
        #3000;
        direction = 0;
        #3000;
        
        $finish;
    end
endmodule
