`timescale 1ns / 1ps
module tb_uart_tx;
    logic clk=0;
    logic rst;
    logic load=0;
    logic [7:0]data_in;
    logic tx_out;
    logic done;
    
    uart_tx dut (.rst(rst), .clk(clk), .load(load), 
    .data_in(data_in), .tx_out(tx_out), .done(done));
    
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        data_in = 8'hA5;
        #10;
        $monitor("The input = %8b, The output = %b, Time = %t", data_in, tx_out, $time);
        rst=0;
        load=1;
        #10;
        load=0;
        #200
        
        $finish;
    end
endmodule
