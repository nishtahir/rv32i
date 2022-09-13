module TopTest;

    logic rst = 0;
    logic clk = 0;
    always #1 clk = !clk;

    logic [31:0] writedata;
    logic [31:0] dataaddr;
    logic [31:0] pc;
    logic [31:0] instr;
    logic memwrite;
    
    Top uut(
        .clk(clk),
        .rst(rst),
        .writedata(writedata),
        .dataaddr(dataaddr),
        .pc(pc),
        .instr(instr)
    );

    initial begin
        $dumpfile("../build/TopTest.vcd");
        $dumpvars(0, TopTest);


        #10 
        $finish;
    end

endmodule
