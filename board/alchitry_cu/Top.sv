module Top (
    input logic clk,
    input logic rst,
    input logic usb_rx,
    output logic usb_tx,
    output logic [23:0] io_led
);

    NextSoc soc(
        .clk(clk),
        .rst(~rst),
        .uart_rx(usb_rx),
        .uart_tx(usb_tx),
        // TODO - pins need to be described as tri state buffer in order to function as GPIO pins
        // https://electronics.stackexchange.com/questions/356632/fpga-is-it-possible-to-change-the-pin-direction-type-during-runtime
        .gpio_a(gpio_a[7:0])
    );

endmodule
