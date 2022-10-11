module AddressDecoderTest;

    logic rst = 0;
    logic clk = 0;
    always #1 clk = !clk;

    logic wen;
    logic ren;
    logic[15:0] addr;
    logic wen1;
    logic wen2;
    logic[1:0] out_sel;

    AddressDecoder uut(
        .wen(wen),
        .ren(ren),
        .addr(addr),
        .wen1(wen1),
        .wen2(wen2),
        .out_sel(out_sel)
    );

    initial begin
        $dumpfile("../build/AddressDecoderTest.vcd");
        $dumpvars(0, AddressDecoderTest);

        #2
        addr = 0;

        #2
        addr = 14'h2001;
        
        #2
        addr = 14'h3000;
        
        #20 
        $finish;
    end

endmodule
