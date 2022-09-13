module ControllerTest;

    logic rst = 0;
    logic clk = 0;
    always #1 clk = !clk;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic alu_zero;
    logic alu_src;
    logic result_src;
    logic pc_src;
    logic memwrite;
    logic memread;
    logic regwrite;
    logic [3:0] alu_control;
    logic [1:0] imm_sel;
    
    Controller uut(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_zero(alu_zero),
        .alu_src(alu_src),
        .result_src(result_src),
        .pc_src(pc_src),
        .memwrite(memwrite),
        .memread(memread),
        .regwrite(regwrite),
        .alu_control(alu_control),
        .imm_sel(imm_sel)
    );

    initial begin
        $dumpfile("../build/ControllerTest.vcd");
        $dumpvars(0, ControllerTest);

        // Check Add
        #2
        opcode = 7'b0110011; 
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #2 // LW
        opcode = 7'b0000011; 
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        
        #2 // sub
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        
        #2 // and
        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        
        #2 // beq
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'bxxxxxxx;
        
        #2
        $finish;
    end

endmodule
