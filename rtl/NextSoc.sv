module NextSoc (
    input logic clk,
    input logic rst,
    input logic uart_rx,
    output logic uart_tx,
    output logic [7:0] gpio_a
);
    logic global_clk;
    logic sys_clk;
    logic uart_clk;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;

    UartClock uart_clk_gen(
        .clock_in(clk),
        .uart_clk(uart_clk),
        .global_clk(global_clk)
    );

    ClockDivider sys_clk_gen(
        .clk(clk),
        .rst(rst),
        .out(sys_clk)
    );

    UartCore uart(
        .clk(uart_clk),
        .rst(rst),
        .tx_send(1'b1),
        .rx_read(1'b1),
        .uart_io_reg(io_uart_io_reg),
        .uart_csr_reg(io_uart_csr_reg),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx)
    );

    NextCore riscv(
        .clk(sys_clk),
        .rst(rst),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg)
    );

    assign gpio_a= io_gpio_io_reg[7:0];

endmodule
