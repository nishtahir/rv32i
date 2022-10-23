module TopTest;

    logic clk = 0;
    always #1 clk = !clk;
    logic rst = 1;

    logic [1:0] SW = 2'b11;
    logic LED_G;
    logic LED_R;
    logic LED_B;
    logic uart_rx;
    logic uart_tx;

    Top uut(
        .clk(clk),
        .rst(rst)
    );
    
    initial begin
        $dumpfile("../build/TopTest.vcd");
        $dumpvars(0, TopTest);



        #500 $finish;
    end

endmodule