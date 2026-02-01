`timescale 1ns / 1ps

module tb_spi_master;
//Host Side Signals
logic clk = 0;
logic rst_n;
logic [7:0] data_in;
logic din_valid;
logic din_ready;
//Slave Side Signals
logic sclk;
logic MOSI;
logic MISO = 0;
logic cs_n;

spi_master dut (.clk(clk), .rst_n(rst_n), .data_in(data_in), .din_valid(din_valid),
 .din_ready(din_ready), .sclk(sclk), .MOSI(MOSI), .MISO(MISO), .cs_n(cs_n));

always #5 clk = ~clk;

initial begin
    rst_n = 0;
    #20;
    $monitor("The Output = %h, Time = %t", MOSI, $time);
    rst_n = 1;
    din_valid = 1;
    data_in = 8'hA5;
    #10;
    din_valid = 0;
    #2000;
    
    $finish;
end
endmodule
