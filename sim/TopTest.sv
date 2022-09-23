module TopTest;

    logic clk = 0;
    always #1 clk = !clk;

    logic [1:0] SW = 2'b11;
    logic LED_G;
    logic LED_R;
    logic LED_B;
    logic uart_rx;
    logic uart_tx;

    Top uut(
        .clk(clk),
        .uart_rx(uart_rx),
        .SW(SW),
        .uart_tx(uart_tx),
        .LED_G(LED_G),
        .LED_R(LED_R),
        .LED_B(LED_B) 
    );
    
    initial begin
        $dumpfile("../build/TopTest.vcd");
        $dumpvars(0, TopTest);



        #100 $finish;
    end

endmodule