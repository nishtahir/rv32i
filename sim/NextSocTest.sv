module NextSocTest;

    logic clk = 0;
    always #1 clk = !clk;
    logic rst = 0;

    logic [1:0] SW = 2'b11;
    logic LED_G;
    logic LED_R;
    logic LED_B;
    logic uart_rx;
    logic uart_tx;

    NextSoc uut(
        .clk(clk),
        .rst(rst),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx)
    );
    
    initial begin
        $dumpfile("../build/NextSocTest.vcd");
        $dumpvars(0, NextSocTest);

        #1000 $finish;
    end

endmodule