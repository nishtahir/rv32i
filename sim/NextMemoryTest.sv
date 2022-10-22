module NextMemoryTest;

    logic rst = 1;
    logic clk = 1;
    always #1 clk = !clk;

    logic wen = 0;
    logic ren = 1;
    logic [15:0] waddr = 0;
    logic [15:0] raddr = 0;
    logic [31:0] wdata = 0;
    logic [31:0] rdata;
    logic [31:0] io_gpio_io_reg;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;

    NextMemory uut(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .rdata(rdata),
        .io_gpio_io_reg(io_gpio_io_reg),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg)
    );

    initial begin
        $dumpfile("../build/NextMemoryTest.vcd");
        $dumpvars(0, NextMemoryTest);

        #2
        waddr = 15'h0200;
        raddr = 15'h0200;
        wen = 1;
        wdata = 99;

        #2
        waddr = 15'h0000;
        raddr = 15'h0000;
        wen = 0;
        wdata = 0;

        #2

        #20 $finish;
    end

endmodule
