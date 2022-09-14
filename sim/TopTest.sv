module TopTest;
    task _assert(input condition, input [1024*8-1:0] message);
        if(!condition) begin
            $display("Assertion Error: %s", message);
            $finish(2);
        end
    endtask

    logic rst = 0;
    logic clk = 1;
    always #1 clk = !clk;

    logic [4:0] reg_waddr;
    logic [31:0] reg_wdata;
    logic [31:0] pc;
    logic [31:0] instr;
    logic memwrite;
    logic reg_write;
    
    Top uut(
        .clk(clk),
        .rst(rst),
        .reg_waddr(reg_waddr),
        .reg_wdata(reg_wdata),
        .reg_write(reg_write),
        .pc(pc),
        .instr(instr)
    );

    initial begin
        $dumpfile("../build/TopTest.vcd");
        $dumpvars(0, TopTest);
 
        #2 
        _assert(reg_waddr === 5'h01, "addi x1 , x0, 1000");
        _assert(reg_wdata === 32'h000003E8, "addi x1 , x0,   1000");
        _assert(reg_write === 1, "addi x1 , x0,   1000");
        
        #2 
        _assert(reg_waddr === 5'h02, "andi x2 , x1, 2000");
        _assert(reg_wdata === 32'h000003C0, "andi x2 , x1,   2000");
        _assert(reg_write === 1, "andi x2 , x1,   2000");

        #2
        _assert(reg_waddr === 5'h03, "or x3, x2, x1");
        _assert(reg_wdata === 32'h000003E8, "or x3, x2, x1");
        _assert(reg_write === 1, "or x3, x2, x1");

        #2
        _assert(reg_waddr === 5'h04, "ori x4, x3, 23");
        _assert(reg_wdata === 32'h000003FF, "ori x4, x3, 23");
        _assert(reg_write === 1, "ori x4, x3, 23");

        #2
        _assert(reg_waddr === 5'h05, "slti x5, x4, 10");
        _assert(reg_wdata === 32'h00000000, "slti x5, x4, 10");
        _assert(reg_write === 1, "slti x5, x4, 10");

        #2
        _assert(reg_waddr === 5'h05, "slti x5, x5, 10");
        _assert(reg_wdata === 32'h00000001, "slti x5, x5, 1");
        _assert(reg_write === 1, "slti x5, x5, 1");

        #2
        _assert(reg_waddr === 5'h06, "sub x6, x4, x5");
        _assert(reg_wdata === 32'h000003FE, "sub x6, x4, x5");
        _assert(reg_write === 1, "sub x6, x4, x5");

        #2
        _assert(reg_waddr === 5'h08, "sw x6, 8(x0)");
        _assert(reg_wdata === 32'h00000008, "sw x6, 8(x0)");
        _assert(reg_write === 0, "sw x6, 8(x0)");
        #2
        _assert(reg_waddr === 5'h07, "lw x7, 8(x0)");
        _assert(reg_wdata === 32'h000003FE, "lw x7, 8(x0)");

        #2
        _assert(reg_waddr === 5'h08, "xori x8, x7, 33");
        _assert(reg_wdata === 32'h000003DF, "xori x8, x7, 33");

        #2
        _assert(reg_waddr === 5'h09, "xor x9, x5, x7");
        _assert(reg_wdata === 32'h000003FF, "xor x9, x5, x7");

        #10 
        $finish;
    end

endmodule
