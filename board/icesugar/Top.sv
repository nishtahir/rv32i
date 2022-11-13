module Top (
    input logic clk,
    input logic uart_rx,
    output logic uart_tx,
    output logic LED_G,
    output logic LED_R,
    output logic LED_B
);

    logic rst = 0;
    logic sys_clk;
    logic uart_clk;
    logic [7: 0] gpio_a;

    UartClock uart_clk_gen(
        .clock_in(clk),
        .uart_clk(uart_clk),
	    .global_clk(sys_clk)
    );

    NextSoc soc(
        .sys_clk(sys_clk),
        .uart_clk(uart_clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        // TODO - pins need to be described as tri state buffer in order to function as GPIO pins
        // https://electronics.stackexchange.com/questions/356632/fpga-is-it-possible-to-change-the-pin-direction-type-during-runtime
        .gpio_a(gpio_a)
    );

    assign LED_R = gpio_a[0];
    assign LED_G = gpio_a[1];
    assign LED_B = gpio_a[2];

endmodule
