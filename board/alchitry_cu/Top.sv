module Top (
    input logic clk,
    input logic rst,
    input logic usb_rx,
    output logic usb_tx,
    output logic [23:0] io_led
);

    logic sys_clk;

    SysClkGen sys_clk_gen(
        .clock_in(clk),
	    .clock_out(sys_clk),
    );

    NextSoc soc(
        .sys_clk(sys_clk),
        .uart_clk(clk),
        .rst(~rst),
        .uart_rx(usb_rx),
        .uart_tx(usb_tx),
        // TODO - pins need to be described as tri state buffer in order to function as GPIO pins
        // https://electronics.stackexchange.com/questions/356632/fpga-is-it-possible-to-change-the-pin-direction-type-during-runtime
        .gpio_a(io_led[7:0])
    );

endmodule
