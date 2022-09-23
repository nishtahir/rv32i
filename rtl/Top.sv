module Top (
    input logic clk,
    input logic uart_rx,
    input logic [1:0] SW,
    output logic uart_tx,
    output logic LED_G,
    output logic LED_R,
    output logic LED_B
);
    logic rst;
    logic global_clk;
    logic uart_clk;
    logic sys_clk;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;

    UartClock uart_clk_gen(
        .clock_in(clk),
        .uart_clk(uart_clk),
        .global_clk(global_clk)
    );

    ClockDivider sys_clk_gen(
        .clk(global_clk),
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

    Core riscv(
        .clk(sys_clk),
        .rst(rst),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg)
    );

    assign rst = ~SW[0];
    assign LED_R = ~io_gpio_io_reg[0];
    assign LED_G = ~io_gpio_io_reg[1];
    assign LED_B = ~io_gpio_io_reg[2];
endmodule