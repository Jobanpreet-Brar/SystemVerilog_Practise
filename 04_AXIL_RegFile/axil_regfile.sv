`timescale 1ns / 1ps

module axil_regfile (
    input  logic        clk,
    input  logic        rst_n,

    // ─── WRITE CHANNEL ───
    input  logic [4:0]  awaddr,
    input  logic        awvalid,
    output logic        awready,
    input  logic [31:0] wdata,
    input  logic        wvalid,
    output logic        wready,
    output logic [1:0]  bresp,
    output logic        bvalid,
    input  logic        bready,

    // ─── READ CHANNEL ───
    input  logic [4:0]  araddr,
    input  logic        arvalid,
    output logic        arready,
    output logic [31:0] rdata,
    output logic [1:0]  rresp,
    output logic        rvalid,
    input  logic        rready
);

    // ─── INTERNAL REGISTERS ───
    logic [31:0] reg0_ctrl;
    logic [31:0] reg1_status;
    logic [31:0] reg2_scratch;
    logic [31:0] reg3_scratch;
    logic [31:0] reg4_traffic;
    
    assign reg1_status = 32'hFEED_FACE; 

    // Always Ready behavior
    assign awready = 1'b1; 
    assign wready  = 1'b1;
    assign bresp   = 2'b00; // OKAY
    
    assign arready = 1'b1;
    assign rresp   = 2'b00; // OKAY

    // ─────────────────────────────────────────────────────────────
    // PART 1: WRITE LOGIC
    // ─────────────────────────────────────────────────────────────
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bvalid       <= 0;
            reg0_ctrl    <= 0;
            reg2_scratch <= 0;
            reg3_scratch <= 0;
            reg4_traffic <= 0;
        end else begin
           if (awvalid && wvalid && !bvalid) begin
            bvalid <= 1;
            case(awaddr[4:2])
                3'b000 : begin
                    reg0_ctrl <= wdata;
                    reg4_traffic <= reg4_traffic + 1;
                end
                3'b010 : begin
                    reg2_scratch <= wdata;
                    reg4_traffic <= reg4_traffic + 1;
                end
                3'b011 : begin
                    reg3_scratch <= wdata;
                    reg4_traffic <= reg4_traffic + 1;
                end
                3'b100 : ;
                3'b001 : ;
                default : ; 
            endcase
           end
           if (bvalid && bready) bvalid <= 0;
        end
    end

    // ─────────────────────────────────────────────────────────────
    // PART 2: READ LOGIC
    // ─────────────────────────────────────────────────────────────
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rvalid <= 0;
            rdata  <= 0;
        end else begin
            if (arvalid && !rvalid) begin
                rvalid <= 1;
                case (araddr[4:2])
                    3'b000 : rdata <= reg0_ctrl;
                    3'b001 : rdata <= reg1_status;
                    3'b010 : rdata <= reg2_scratch;
                    3'b011 : rdata <= reg3_scratch;
                    3'b100 : rdata <= reg4_traffic;
                    default : rdata <= 32'h0;
                endcase
            end
            if (rvalid && rready) rvalid <= 0;
        end
    end

endmodule
