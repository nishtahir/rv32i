module RomTest;

    logic rst = 1;
    logic clk = 0;
    always #1 clk = !clk;

    logic [5:0] addr = 0;
    logic [31:0] dout;
    
    Rom #(
        .MEM_WIDTH(32),
        .MEM_DEPTH(64)
    ) uut(
        .addr(addr),
        .dout(dout)
    );

    initial begin
        $dumpfile("../build/RomTest.vcd");
        $dumpvars(0, RomTest);

        #2
        addr = 1;
        #1
        addr = 3;

        #20 $finish;
    end

endmodule
