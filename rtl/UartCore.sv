module UartCore (
    input logic clk,
    input logic rst,
    // TODO - clear on write
    input logic tx_send,
    // TODO - clear on read
    input logic rx_read,
    input logic uart_rx,
    input logic[31:0] uart_io_reg,
    output logic tx_busy,
    output logic rx_busy,
    output logic uart_tx
);

    UartTx tx(
        .clk(clk),
        .rst(rst),
        .send(tx_send),
        .busy(tx_busy),
        .data(uart_io_reg[7:0]),
        .uart_tx(uart_tx)
    );

    UartRx rx(
        .clk(clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .data(uart_io_reg[15:8])
    );

endmodule