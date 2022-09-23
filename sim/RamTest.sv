module RamTest;

    logic rst = 1;
    logic clk = 0;
    always #1 clk = !clk;

    logic wen = 0;
    logic ren = 1;

    logic [13:0] waddr = 0;
    logic [13:0] raddr = 0;
    logic [31:0] wdata = 0;
    logic [31:0] rdata;

    Ram uut(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .rdata(rdata)
    );

    initial begin
        $dumpfile("../build/RamTest.vcd");
        $dumpvars(0, RamTest);

        #2
         wen = 1;
        waddr = 1;
        wdata = 256;
        #2 
        wen = 0;
        wdata = 0;
        waddr = 0;
        raddr = 1;

        #20 $finish;
    end

endmodule
