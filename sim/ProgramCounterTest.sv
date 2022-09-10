module ProgramCounterTest;

    logic rst = 1;
    logic clk = 0;
    logic [31: 0] next = 0;
    logic [31: 0] current;
    logic [31: 0] plus4;

    ProgramCounter uut(
        .clk(clk),
        .rst(rst),
        .next(next),
        .pc(current),
        .pcplus4(plus4)
    );

    always #1 clk = !clk;
    initial begin
        $dumpfile("../build/ProgramCounterTest.vcd");
        $dumpvars(0, ProgramCounterTest);

        #2 rst = 0;
        #2 next = 16;

        #4 next = 8;

        #6 rst = 1;
        #6 next = 24;

        #8 rst = 0;
        
        #20 $finish;
    end

endmodule
