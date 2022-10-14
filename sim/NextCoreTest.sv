module NextCoreTest;
    task _assert(input condition, input [1024*8-1:0] message);
        if(!condition) begin
            $display("Assertion Error: %s", message);
            $finish(2);
        end
    endtask

    logic rst = 0;
    logic clk = 1;
    always #1 clk = !clk;

    logic [7:0] io_addr;
    logic [31:0] io_data;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;    

    NextCore uut(
        .clk(clk),
        .rst(rst),
        .io_addr(io_addr),
        .io_data(io_data),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg)
    );

    initial begin
        $dumpfile("../build/NextCoreTest.vcd");
        $dumpvars(0, NextCoreTest);

        #300
        $finish;
    end

endmodule
