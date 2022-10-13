module NextCoreTest;
    task _assert(input condition, input [1024*8-1:0] message);
        if(!condition) begin
            $display("Assertion Error: %s", message);
            $finish(2);
        end
    endtask

    logic rst = 0;
    logic clk = 1;
    always #1 clk = !clk;

    logic [7:0] io_addr;
    logic [31:0] io_data;
    logic [31:0] io_uart_io_reg;
    logic [31:0] io_uart_csr_reg;
    logic [31:0] io_gpio_io_reg;    

    NextCore uut(
        .clk(clk),
        .rst(rst),
        .io_addr(io_addr),
        .io_data(io_data),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg)
    );

    initial begin
        $dumpfile("../build/NextCoreTest.vcd");
        $dumpvars(0, NextCoreTest);


 
        // #2 
        // _assert(reg_waddr === 5'h01, "addi x1 , x0, 1000");
        // _assert(reg_wdata === 32'h000003E8, "addi x1 , x0,   1000");
        // _assert(reg_write === 1, "addi x1 , x0,   1000");
        
        // #2 
        // _assert(reg_waddr === 5'h02, "andi x2 , x1, 2000");
        // _assert(reg_wdata === 32'h000003C0, "andi x2 , x1,   2000");
        // _assert(reg_write === 1, "andi x2 , x1,   2000");

        // #2
        // _assert(reg_waddr === 5'h03, "or x3, x2, x1");
        // _assert(reg_wdata === 32'h000003E8, "or x3, x2, x1");
        // _assert(reg_write === 1, "or x3, x2, x1");

        // #2
        // _assert(reg_waddr === 5'h04, "ori x4, x3, 23");
        // _assert(reg_wdata === 32'h000003FF, "ori x4, x3, 23");
        // _assert(reg_write === 1, "ori x4, x3, 23");

        // #2
        // _assert(reg_waddr === 5'h05, "slti x5, x4, 10");
        // _assert(reg_wdata === 32'h00000000, "slti x5, x4, 10");
        // _assert(reg_write === 1, "slti x5, x4, 10");

        // #2
        // _assert(reg_waddr === 5'h05, "slti x5, x5, 10");
        // _assert(reg_wdata === 32'h00000001, "slti x5, x5, 1");
        // _assert(reg_write === 1, "slti x5, x5, 1");

        // #2
        // _assert(reg_waddr === 5'h06, "sub x6, x4, x5");
        // _assert(reg_wdata === 32'h000003FE, "sub x6, x4, x5");
        // _assert(reg_write === 1, "sub x6, x4, x5");

        // #2
        // _assert(reg_waddr === 5'h08, "sw x6, 8(x0)");
        // _assert(reg_wdata === 32'h00000008, "sw x6, 8(x0)");
        // _assert(reg_write === 0, "sw x6, 8(x0)");
        // #2
        // _assert(reg_waddr === 5'h07, "lw x7, 8(x0)");
        // _assert(reg_wdata === 32'h000003FE, "lw x7, 8(x0)");

        // #2
        // _assert(reg_waddr === 5'h08, "xori x8, x7, 33");
        // _assert(reg_wdata === 32'h000003DF, "xori x8, x7, 33");

        // #2
        // _assert(reg_waddr === 5'h09, "xor x9, x5, x7");
        // _assert(reg_wdata === 32'h000003FF, "xor x9, x5, x7");

        // #2
        // _assert(reg_waddr === 5'h0A, "sltiu x10, x9, 1022");
        // _assert(reg_wdata === 32'h00000000, "sltiu x10, x9, 1022");

        // #2
        // _assert(reg_waddr === 5'h0A, "sltiu x10, x8, 1022");
        // _assert(reg_wdata === 32'h00000001, "sltiu x10, x8, 1022");

        // #2
        // _assert(reg_waddr === 5'h0B, "slli x11,x9, 2");
        // _assert(reg_wdata === 32'h00000FFC, "slli x11,x9, 2");

        // #2
        // _assert(reg_waddr === 5'h0C, "sll x12, x11, x10");
        // _assert(reg_wdata === 32'h00001FF8, "sll x12, x11, x10");

        // #2
        // _assert(reg_waddr === 5'h0D, "slt x13, x12, x11");
        // _assert(reg_wdata === 32'h00000000, "slt x13, x12, x11");

        // #2
        // _assert(reg_waddr === 5'h0D, "slt x13, x11, x12");
        // _assert(reg_wdata === 32'h00000001, "slt x13, x11, x12");

        // #2
        // _assert(reg_waddr === 5'h0D, "sltu x13, x12, x11");
        // _assert(reg_wdata === 32'h00000000, "slt x13, x12, x11");

        // #2
        // _assert(reg_waddr === 5'h0D, "sltu x13, x11, x12");
        // _assert(reg_wdata === 32'h00000001, "slt x13, x11, x12");

        // #2
        // _assert(reg_waddr === 5'h0E, "srli x14, x12, 4");
        // _assert(reg_wdata === 32'h000001FF, "srli x14, x12, 4");

        // #2
        // _assert(reg_waddr === 5'h0F, "srl x15, x12, x13");
        // _assert(reg_wdata === 32'h00000FFC, "srl x15, x12, x13");

        // #2
        // _assert(reg_waddr === 5'h10, "and x16, x15, x14");
        // _assert(reg_wdata === 32'h000001FC, "and x16, x15, x14");

        // #2
        // _assert(reg_waddr === 5'h11, "addi x17, x0, 4095");
        // _assert(reg_wdata === 32'hFFFFFFFF, "addi x17, x0, 4095");

        // #2
        // _assert(reg_waddr === 5'h12, "srai x18, x17, 1");
        // _assert(reg_wdata === 32'hFFFFFFFF, "srai x18, x17, 1");

        // #2
        // _assert(reg_waddr === 5'h13, "sra x19, x18, x10");
        // _assert(reg_wdata === 32'hFFFFFFFF, "sra x19, x18, x10");

        // #2
        // _assert(reg_waddr === 5'h14, "lb x20, 8(x0)");
        // _assert(reg_wdata === 32'hFFFFFFFE, "lb x20, 8(x0)");

        // #2
        // _assert(reg_waddr === 5'h14, "lh x20, 8(x0)");
        // _assert(reg_wdata === 32'h000003FE, "lh x20, 8(x0)");

        // #2
        // _assert(reg_waddr === 5'h14, "lbu x20, 8(x0)");
        // _assert(reg_wdata === 32'h000000FE, "lh x20, 8(x0)");

        // #2
        // _assert(reg_waddr === 5'h14, "lhu x20, 8(x0)");
        // _assert(reg_wdata === 32'h000003FE, "lh x20, 8(x0)");

        // #2
        // _assert(reg_waddr === 5'h0C, "sb x17, 12(x0)");
        // _assert(reg_wdata === 32'h0000000C, "sb x17, 12(x0)");
        // _assert(reg_write === 0, "sb x17, 12(x0)");

        // #2
        // _assert(reg_waddr === 5'h0C, "sh x17, 12(x0)");
        // _assert(reg_wdata === 32'h0000000C, "sh x17, 12(x0)");
        // _assert(reg_write === 0, "sh x17, 12(x0)");

        // #2
        // _assert(reg_waddr === 5'h15, "jal x21, 4");
        // _assert(reg_wdata === 32'h00000080, "jal x21, 4");

        // #2
        // _assert(pc === 32'h00000080, "jalr x21, x21, 4"); // next PC should be jump target
        // _assert(reg_waddr === 5'h15, "jalr x21, x21, 4");
        // _assert(reg_wdata === 32'h00000084, "jal x21, 4");

        // #2
        // _assert(pc === 32'h00000084, "beq x21, x21, 8"); // next PC should be PC + Branch offset
        // _assert(reg_write === 0, "beq x21, x21, 8");

        // #2
        // // Next instruction should be skipped
        // _assert(pc === 32'h0000008C, "beq x21, x21, 8"); // next PC should be jump target
        // _assert(reg_write === 0, "beq x21, x0, 8");

        // #2
        // // Next instruction should NOT be skipped        
        // _assert(pc === 32'h00000090, "bne x21, x0, 8"); // next PC should be jump target
        // _assert(reg_write === 0, "bne x21, x0, 8");

        // #2
        // _assert(pc === 32'h00000098, "bne x21, x0, 8"); // next PC should be jump target

        // #2
        // _assert(pc === 32'h000000A0, "blt x0, x21, 8");

        // #2
        // _assert(pc === 32'h000000A4, "blt x21, x0, 8");
        // // lui
        // _assert(reg_waddr === 5'h16, "lui x22, 524289");
        // _assert(reg_wdata === 32'h80001000, "lui x22, 524289");

        #10
        $finish;
    end

endmodule
