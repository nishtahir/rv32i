module UartCore (
    input logic clk,
    input logic rst,
    // TODO - send on write
    input logic tx_send,
    // TODO - clear on read
    input logic rx_read,
    input logic uart_rx,
    input logic[31:0] uart_io_reg,
    input logic[31:0] uart_csr_reg,
    output logic uart_tx
);

    UartTx tx(
        .clk(clk),
        .rst(rst),
        .send(tx_send),
        .data(uart_io_reg[7:0]),
        .uart_tx(uart_tx)
    );

    // UartRx rx(
    //     .clk(clk),
    //     .rst(rst),
    //     .uart_rx(uart_rx),
    //     .data(uart_io_reg[15:8])
    // );

endmodule