module NextMemoryTest;

    logic rst = 1;
    logic clk = 1;
    always #1 clk = !clk;

    // Test signals
    logic [31:0] addr = 0;
    
    logic wen = 0;
    logic ren = 1;
    logic [31:0] wdata = 0;
    logic [31:0] rdata;
    logic [31:0] io_gpio_io_reg;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;

    NextMemory uut(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .waddr(addr[15: 2]),
        .raddr(addr[15: 2]),
        .ben(addr[1:0]),
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
        addr = 32'h11C;

        #2
        wdata = 32'h3E6;
        wen = 1;


        
        // wdata = 99;

        // #2
        // waddr = 15'h0000;
        // raddr = 15'h0000;
        // wen = 0;
        // wdata = 0;

        // #2

        #20 $finish;
    end

endmodule
