module SignExtendTest;

    logic rst = 1;
    logic clk = 0;
    always #1 clk = !clk;

    logic [15: 0] in = 0;
    logic [31: 0] out;

    SignExtend uut(
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("../build/SignExtendTest.vcd");
        $dumpvars(0, SignExtendTest);

        #2
        in = 16'b1111111111111100;

        #2
        in = 16'b0111111111111100;

        #20 $finish;
    end

endmodule
