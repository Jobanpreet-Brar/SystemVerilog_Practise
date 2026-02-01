`timescale 1ns / 1ps

module tb_axil_regfile;

    // Signals
    logic        clk = 0;
    logic        rst_n = 0;

    // Write Channel
    logic [4:0]  awaddr;
    logic        awvalid;
    logic        awready;
    logic [31:0] wdata;
    logic        wvalid;
    logic        wready;
    logic [1:0]  bresp;
    logic        bvalid;
    logic        bready;

    // Read Channel
    logic [4:0]  araddr;
    logic        arvalid;
    logic        arready;
    logic [31:0] rdata;
    logic [1:0]  rresp;
    logic        rvalid;
    logic        rready;

    // 2. Instantiate the DUT
    axil_regfile dut (
        .clk(clk),
        .rst_n(rst_n),
        // Write
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata),   .wvalid(wvalid),   .wready(wready),
        .bresp(bresp),   .bvalid(bvalid),   .bready(bready),
        // Read
        .araddr(araddr), .arvalid(arvalid), .arready(arready),
        .rdata(rdata),   .rresp(rresp),     .rvalid(rvalid), .rready(rready)
    );

    // 3. Clock Generation (10ns period)
    always #5 clk = ~clk;

    // ─────────────────────────────────────────────────────────────
    // TASK: AXI WRITE (Master Driver)
    // ─────────────────────────────────────────────────────────────
    task axi_write(input [4:0] addr, input [31:0] data);
        begin
            // A. Setup Phase: Drive Address and Data
            @(posedge clk); // Wait for edge
            awaddr  <= addr;
            awvalid <= 1;
            wdata   <= data;
            wvalid  <= 1;
            bready  <= 0;   // Not ready for response yet

            // B. Wait for Slave to accept Address AND Data
            // (In our simple slave, this happens instantly, but good BFM waits)
            do begin
                @(posedge clk);
            end while ((awready == 0) || (wready == 0));

            // C. Hold Phase: Clear Valid signals once accepted
            awvalid <= 0;
            wvalid  <= 0;
            
            // D. Response Phase: Wait for 'bvalid'
            bready <= 1; // Tell slave we are ready to hear the result
            do begin
                @(posedge clk);
            end while (bvalid == 0); // Wait until slave says "Done"

            // E. Cleanup
            bready <= 0;
        end
    endtask

    // ─────────────────────────────────────────────────────────────
    // TASK: AXI READ (Master Driver) - YOUR JOB
    // ─────────────────────────────────────────────────────────────
    task axi_read(input [4:0] addr, output [31:0] data);
        begin
            // 1. Setup: Drive Address and valid
            araddr <= addr;
            arvalid <= 1;
            
            // 2. Wait for Address Accept (arready)
            do begin
                @(posedge clk);
            end while (arready == 0);
            // 3. Clear Address Valid
            arvalid <= 0;
            
            //    (Also set rready <= 1 here)
            rready <= 1;
            // 4. Wait for Data Valid (rvalid)
            do begin
                @(posedge clk);
            end while (rvalid == 0);
            // 5. Capture Data (data = rdata) and Cleanup
            data = rdata;
            rready <= 0;
        end
    endtask

    // ─────────────────────────────────────────────────────────────
    // MAIN TEST SEQUENCE
    // ─────────────────────────────────────────────────────────────
    logic [31:0] read_val;

    initial begin
        // Reset
        rst_n = 0;
        #20;
        rst_n = 1;
        #20;

        $display("--- Starting AXI Verification ---");

        // TEST 1: Check Traffic Counter (Should be 0)
        axi_read(5'h10, read_val);
        @(posedge clk);
        if (read_val == 0) $display("PASS: Initial Traffic is 0");
        else               $error("FAIL: Traffic is %0d", read_val);

        // TEST 2: Perform Writes
        $display("--- Writing to Reg0 and Reg2 ---");
        axi_write(5'h00, 32'h12345678); 
        axi_write(5'h08, 32'hABCDEF00);

        // TEST 3: Check Traffic Counter (Should be 2)
        axi_read(5'h10, read_val);
        @(posedge clk);
        if (read_val == 2) $display("PASS: Final Traffic is 2");
        else               $error("FAIL: Traffic is %0d", read_val);
        
        #100;
        $finish;
    end

endmodule
