module Top (
    input logic clk,
    input logic uart_rx,
    input logic[1:0] SW,
    output logic LED_G,
    output logic LED_R,
    output logic LED_B,
    output logic uart_tx
);
    logic rst;
    logic global_clk;
    logic uart_clk;
    logic sys_clk;
    logic [31:0] io_uart;

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

    UartTx tx(
        .clk(uart_clk),
        .rst(rst),
        .send(io_uart[8]),
        .data(io_uart[7:0]),
        .uart_tx(uart_tx)
    );

    Core riscv(
        .clk(sys_clk),
        .rst(rst),
        .io_uart(io_uart)
    );

    assign rst = ~SW[0];
    assign LED_G = ~io_uart[0];
    assign LED_R = ~io_uart[1];
    assign LED_B = ~io_uart[2];

endmodule