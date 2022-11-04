module NextMemory (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    input logic [1:0] ben,
    input logic io_uart_tx_busy,
    input logic io_uart_rx_busy,
    output logic io_uart_send,
    output logic io_uart_read,
    output logic [31:0] rdata,
    output logic [31:0] io_gpio_io_reg,
    output logic [31:0] io_uart_io_reg,
    output logic [31:0] io_uart_csr_reg
); 

    logic [1:0] wen_src;
    logic [1:0] ren_src;
    logic [1:0] out_src;
    logic [31:0] ram_out;
    logic [31:0] io_out;

    NextAddressDecoder decoder(
        .wen(wen),
        .ren(ren),
        .addr(waddr),
        .wen_src(wen_src),
        .ren_src(ren_src),
        .out_src(out_src)
    );

    NextRam ram (
        .clk(clk),
        .wen((wen_src === 0) & wen),
        .ren((ren_src === 0) & ren),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .rdata(ram_out)
    );

    NextIO io (
        .clk(clk),
        .wen((wen_src === 1) & wen),
        .ren((ren_src === 1) & ren),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .rdata(io_out),
        .io_gpio_io_reg(io_gpio_io_reg),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_uart_send(io_uart_send),
        .io_uart_read(io_uart_read),
        .io_uart_tx_busy(io_uart_tx_busy),
        .io_uart_rx_busy(io_uart_rx_busy)
    );

    always_comb begin
        case (out_src)
            1: rdata = io_out;
            default: rdata = ram_out >> (ben * 8);
        endcase    
    end

endmodule