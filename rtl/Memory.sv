module Memory (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata,
    input logic [7:0] io_addr,    
    output logic [31:0] io_data,
    output logic [31:0] io_uart_io_reg,
    output logic [31:0] io_uart_csr_reg,
    output logic [31:0] io_gpio_io_reg
);

    logic wen1;
    logic wen2;
    logic wen3;
    logic [1:0] dec_out;
    logic [31:0] ram_out;
    logic [31:0] io_mem [7:0];
    logic [13: 0] waddr_aligned;
    logic [13: 0] raddr_aligned;

    // Memory is word aligned. 
    // Last 2 bits are always 0
    assign waddr_aligned = waddr[13:2];
    assign raddr_aligned = raddr[13:2];

    assign io_data = io_mem[io_addr];
    assign io_uart_io_reg = io_mem[0];
    assign io_uart_csr_reg = io_mem[1];
    assign io_gpio_io_reg = io_mem[2];

    AddressDecoder decoder(
        .wen(wen),
        .ren(ren),
        .addr(waddr_aligned),
        .wen1(wen1),
        .wen2(wen2),
        .wen3(wen3),
        .out_sel(dec_out)
    );

    Ram ram (
        .clk(clk),
        .wen(wen1),
        .ren(ren),
        .waddr(waddr_aligned),
        .raddr(raddr_aligned),
        .wdata(wdata),
        .rdata(ram_out)
    );

    initial begin
        // Zero out RAM
        for (integer i = 0; i < 7; i = i + 1) begin
            io_mem[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (wen2) begin
            io_mem[waddr_aligned[3:0]] = wdata;
        end
    end

    always_comb begin
        case(dec_out)
            1: rdata = io_mem[raddr_aligned[3:0]]; 
            default: rdata = ram_out;
        endcase 
    end

endmodule
