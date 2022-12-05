module NextSoc (
    input logic sys_clk,
    input logic uart_clk,
    input logic rst,
    input logic uart_rx,
    output logic uart_tx,
    output logic [7:0] gpio_a
);
    logic [7:0] io_uart_io_thr;
    logic [7:0] io_uart_io_rhr;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;
    logic io_uart_send;
    logic io_uart_read;
    logic io_uart_tx_busy;
    logic io_uart_rx_busy;

    UartCore uart(
        .clk(uart_clk),
        .rst(rst),
        .tx_send(io_uart_send),
        .rx_read(io_uart_read),
        .uart_io_reg(io_uart_io_reg),
        .uart_io_thr(io_uart_io_thr),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx),
        .tx_busy(io_uart_tx_busy),
        .rx_busy(io_uart_rx_busy),
        .uart_io_rhr(io_uart_io_rhr)
    );

    NextCore riscv(
        .clk(sys_clk),
        .rst(rst),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_io_thr(io_uart_io_thr),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg),
        .io_uart_send(io_uart_send),
        .io_uart_read(io_uart_read),
        .io_uart_tx_busy(io_uart_tx_busy),
        .io_uart_rx_busy(io_uart_rx_busy),
        .io_uart_io_rhr(io_uart_io_rhr)
    );

    assign gpio_a= io_uart_io_reg[15:8];
endmodule
