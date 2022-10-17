module Top (
    input logic clk,
    input logic uart_rx,
    input logic [1:0] SW,
    output logic uart_tx,
    
    output logic LED_G,
    output logic LED_R,
    output logic LED_B,

    // LCD PMOD
    output logic P2_1,
    output logic P2_2,
    output logic P2_3,
    output logic P2_4,
    output logic P2_9, 
    output logic P2_10,
    output logic P2_11,
    output logic P2_12

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
    logic rst;
    logic global_clk;
    logic uart_clk;
    logic sys_clk;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;

    logic spi_mosi;
    logic spi_miso;
    logic spi_sck;
    logic spi_send;
    logic spi_busy;
    logic spi_din;
    logic [7:0] spi_dout;

    assign P2_10 = rst;
    // https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi/chip-select-cs
    assign P2_1 = ~spi_busy; // Chip select
    assign P2_2 = spi_miso;
    assign P2_4 = spi_sck;
    

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

    NextCore riscv(
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

    // assign P2_1 = 0;
    // assign P2_2 = 1;
    // assign P2_12 = 1;

    // SpiMaster #(
    //     .CLK_DIV(4)
    // ) spi (
    //     .clk(global_clk),
    //     .rst(rst),
    //     .miso(spi_miso),
    //     .mosi(spi_mosi),
    //     .sck(spi_sck),
    //     .start(spi_send),
    //     .data_in(spi_din),
    //     .data_out(spi_dout),
    //     .busy(spi_busy)
    // );
    
endmodule