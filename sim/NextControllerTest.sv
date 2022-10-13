module NextControllerTest;

    task _assert(input condition, input [1024*8-1:0] message);
        if(!condition) begin
            $display("Assertion Error: %s", message);
            $finish(2);
        end
    endtask

    logic rst = 0;
    logic clk = 0;
    always #1 clk = !clk;

    logic alu_zero;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic instr_flop_wen;
    logic pc_wen;
    logic addr_src;
    logic mem_write;
    logic mem_read;
    logic reg_write;
    logic [3:0] alu_control;
    logic [2:0] imm_sel;
    logic [1:0] result_src;
    logic [1:0] alu_a_src;
    logic [1:0] alu_b_src;
        
    NextController uut (
        .clk(clk),
        .rst(rst),
        .alu_zero(alu_zero),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .instr_flop_wen(instr_flop_wen),
        .pc_wen(pc_wen),
        .addr_src(addr_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .reg_write(reg_write),
        .alu_control(alu_control),
        .imm_sel(imm_sel),
        .result_src(result_src),
        .alu_a_src(alu_a_src),
        .alu_b_src(alu_b_src)
    );

    initial begin
        $dumpfile("../build/NextControllerTest.vcd");
        $dumpvars(0, NextControllerTest);

        // Pulse reset
        rst = 1;
        
        #1
        rst = 0;
        opcode = 7'b0000011; 
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        alu_zero = 0;
        _assert(uut.state === 0, "uut.state != FETCH");
        _assert(addr_src === 0, "b0110011 addr_src != 0");
        // Calculate and write PC + 4
        _assert(alu_a_src === 0, "alu_a_src != PC");
        _assert(alu_b_src === 2, "alu_b_src != 4");
        _assert(pc_wen === 1, "pc_wen != 1");
        _assert(result_src === 2, "result_src != alu_out");

        #2
        _assert(uut.state === 1, "uut.state != DECODE");

        #2
        _assert(uut.state === 2, "uut.state != MEM_ADDR");
        _assert(alu_a_src === 2, "alu_a_src != rd1");
        _assert(alu_b_src === 1, "alu_b_src != imm");

        #2
        _assert(uut.state === 3, "uut.state != MEM_READ");
        // data memry write addr should be the load addr
        _assert(addr_src === 1, "addr_src != alu res addr");

        #2
        _assert(uut.state === 4, "uut.state != MEM_WB");
        _assert(result_src === 1, "result_src != data_memory");
        _assert(reg_write === 1, "reg_write != 1");

        #2
        // SW
        opcode = 7'b0100011; 
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        alu_zero = 0;
        _assert(uut.state === 0, "uut.state != FETCH");

        #2
        _assert(uut.state === 1, "uut.state != DECODE");

        #2
        _assert(uut.state === 2, "uut.state != MEM_ADDR");
        _assert(alu_a_src === 2, "alu_a_src != rd1");
        _assert(alu_b_src === 1, "alu_b_src != imm");

        #2
        _assert(uut.state === 5, "uut.state != MEM_WRITE");
        _assert(mem_write === 1, "mem_write != 1");
        _assert(addr_src === 1, "addr_src != alu res addr");

        #2
        // R Type
        opcode = 7'b0110011; 
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        alu_zero = 0;
        _assert(uut.state === 0, "uut.state != FETCH");

        #2
        _assert(uut.state === 1, "uut.state != DECODE");

        #2
        _assert(uut.state === 6, "uut.state != EXEC_R");
        _assert(alu_a_src === 2, "alu_a_src != rd1");
        _assert(alu_b_src === 0, "alu_b_src != rd2");

        #2
        _assert(uut.state === 7, "uut.state != ALU_WB");
        _assert(result_src === 0, "result_src != 0");
        _assert(reg_write === 1, "reg_write != 1");

        #2
        // I type Immediate
        opcode = 7'b0010011; 
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        alu_zero = 0;
        _assert(uut.state === 0, "uut.state != FETCH");

        #2
        _assert(uut.state === 1, "uut.state != DECODE");

        #2
        _assert(uut.state === 8, "uut.state != EXEC_I");
        _assert(alu_a_src === 2, "alu_a_src != rd1");
        _assert(alu_b_src === 1, "alu_b_src != immgen");

        #2
        _assert(uut.state === 7, "uut.state != ALU_WB");
        _assert(result_src === 0, "result_src != 0");
        _assert(reg_write === 1, "reg_write != 1");
        
        #2
        // B type Immediate
        opcode = 7'b1100011; 
        alu_zero = 1;
        _assert(uut.state === 0, "uut.state != FETCH");

        #2
        _assert(uut.state === 1, "uut.state != DECODE");

        #2
        _assert(uut.state === 9, "uut.state != EXEC_B");
        _assert(alu_a_src === 2, "alu_a_src != rd1");
        _assert(alu_b_src === 0, "alu_b_src != immgen");
        _assert(result_src === 0, "result_src != 0");
        _assert(pc_wen === 1, "pc_wen");

        #2
        // J type Immediate
        opcode = 7'b1101111; 
        alu_zero = 1;
        _assert(uut.state === 0, "uut.state != FETCH");

        #2
        _assert(uut.state === 1, "uut.state != DECODE");

        #2
        _assert(uut.state === 10, "uut.state != EXEC_J");
        _assert(alu_a_src === 1, "alu_a_src != rd1");
        _assert(alu_b_src === 2, "alu_b_src != immgen");
        _assert(result_src === 0, "result_src != 0");
        _assert(pc_wen === 1, "pc_wen");
   
        #10
        $finish;
    end

endmodule
