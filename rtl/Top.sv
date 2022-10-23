module Top (
    input logic clk,
    input logic rst,
    input logic usb_rx,
    // input logic [23:0] io_dip,
    
    output logic usb_tx,
    output logic [23:0] io_led
    // output logic LED_G,
    // output logic LED_R,
    // output logic LED_B,

    // LCD PMOD
    // output logic P2_1,
    // output logic P2_2,
    // output logic P2_3,
    // output logic P2_4,
    // output logic P2_9, 
    // output logic P2_10,
    // output logic P2_11,
    // output logic P2_12,

    // output logic P3_1,
    // output logic P3_2,
    // output logic P3_3,
    // output logic P3_4

    // Touch PMOD
    // output logic P3_1, 
    // output logic P3_2,
    // output logic P3_3,
    // output logic P3_4,
    // output logic P3_9,
    // output logic P3_10,
    // output logic P3_11,
    // output logic P3_12
);
    logic global_clk;
    logic sys_clk;
    logic uart_clk;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;

    // assign P2_10 = rst;
    // // https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi/chip-select-cs
    // assign P2_1 = ~spi_busy; // Chip select
    // assign P2_2 = spi_miso;
    // assign P2_4 = spi_sck;
    

    // UartClock uart_clk_gen(
    //     .clock_in(clk),
    //     .uart_clk(uart_clk),
    //     .global_clk(global_clk)
    // );

    

    ClockDivider sys_clk_gen(
        .clk(clk),
        .rst(~rst),
        .out(sys_clk)
    );

    // UartCore uart(
    //     .clk(uart_clk),
    //     .rst(rst),
    //     .tx_send(1'b1),
    //     .rx_read(1'b1),
    //     .uart_io_reg(io_uart_io_reg),
    //     .uart_csr_reg(io_uart_csr_reg),
    //     .uart_tx(uart_tx),
    //     .uart_rx(uart_rx)
    // );

    NextCore riscv(
        .clk(sys_clk),
        .rst(~rst),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg)
    );

    // assign rst = SW[0];
    // assign LED_R = ~io_gpio_io_reg[0];
    // assign LED_G = ~io_gpio_io_reg[1];
    // assign LED_B = ~io_gpio_io_reg[2];

    // assign io_led[0] = rst;

    assign io_led[7:0] = io_gpio_io_reg[7:0];
    assign io_led[15:8] = io_uart_io_reg[7:0];
    assign io_led[23:16] = io_uart_csr_reg[7:0];
    // assign LED_R = ~rst;
    // assign P2_3 = LED_R;

endmodule
