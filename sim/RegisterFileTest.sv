module RegisterFileTest;

    logic rst = 1;
    logic clk = 0;
    always #1 clk = !clk;

    logic we = 0;
    logic [4: 0] raddr1;
    logic [4: 0] raddr2;
    logic [4: 0] waddr;
    logic [31: 0] wdata;
    logic [31: 0] rd1;
    logic [31: 0] rd2;

    RegisterFile uut(
        .clk(clk),
        .we(we),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rd1(rd1),
        .rd2(rd2)
    );

    initial begin
        $dumpfile("../build/RegisterFileTest.vcd");
        $dumpvars(0, RegisterFileTest);

        raddr1 = 0;
        raddr2 = 0;
        waddr = 0;
        wdata = 0;

        #2
        waddr = 2;
        wdata = 255;
        we = 1;

        #2
        we = 0;
        raddr1 = 2;
        waddr = 0;
        wdata = 0;

        #2
        waddr = 4;
        wdata = 511;
        we = 1;

        #2
        we = 0;
        waddr = 0;
        wdata = 0;
        raddr2 = 4;


        #20 $finish;
    end

endmodule
