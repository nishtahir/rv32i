module ImmSignExtendTest();

    logic rst = 1;
    logic clk = 0;

    logic [31:0] instr = 0;
    logic [2:0] imm_sel = 0;
    logic [31:0] out;


    ImmGen uut(
        .instr(instr),
        .imm_sel(imm_sel),
        .out(out)
    );

    always #1 clk = !clk;
    initial begin
        $dumpfile("../build/ImmSignExtendTest.vcd");
        $dumpvars(0, ImmSignExtendTest);

        #2 
        instr = 32'hFFC4A303;
        imm_sel = 0;

        #2 
        instr = 32'h0064A423;
        imm_sel = 1;

        #2
        instr = 32'hFE420AE3;
        imm_sel = 2;

        #20 $finish;
    end
endmodule