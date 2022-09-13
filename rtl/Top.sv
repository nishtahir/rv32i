module Top (
    input logic clk,
    input logic rst,
    output logic [31: 0] writedata,
    output logic [31: 0] dataaddr,
    // Debug signals
    output logic [31: 0] pc,
    output logic [31: 0] instr,
    output logic [31: 0] rd1,
    output logic [31: 0] rd2
);
    // Control signals
    logic alu_src;
    logic alu_zero;
    logic result_src;
    logic pc_src;
    logic memwrite;
    logic memread;
    logic regwrite;
    logic [3:0] alu_control;
    logic [3:0] imm_sel;
    
    // Data signals
    logic [31:0] pc_target;
    logic [31:0] pc_plus_4; 
    logic [31:0] readdata;
    logic [31:0] immext;
    logic [31:0] alu_out;

    ProgramCounter counter(
        .clk(clk),
        .rst(rst),
        .next(pc_src ? pc_target : pc_plus_4),
        .pc(pc),
        .pcplus4(pc_plus_4)
    );

    Rom #(
        .MEM_WIDTH(32),
        .MEM_DEPTH(64)
    ) imem (
        // We're assuming that the last 2 bits of the pc will always be 0
        // since they are assumed to be multiples ol 4
        // This should be 6 bits wide since the memory depth is 2^6 = 64
        // https://arstechnica.com/civis/viewtopic.php?t=801655
        .addr(pc[7: 2]),
        .dout(instr)
    );

    Ram #(
        .MEM_WIDTH(32),
        .MEM_DEPTH(256)
    ) datamem (
        .clk(clk),
        .wen(memwrite),
        .ren(memread),
        .waddr(alu_out),
        .raddr(alu_out),
        .wdata(rd2),
        .rdata(readdata)
    );

    RegisterFile regfile(
        .clk(clk),
        .we(regwrite),
        .raddr1(instr[19: 15]), // rs1
        .raddr2(instr[24: 20]), // rs2
        .waddr(instr[11: 7]),   // rd
        .wdata(result_src? readdata: alu_out),  
        .rd1(rd1),
        .rd2(rd2)
    );

    ImmSignExtend extend (
        .instr(instr),
        .imm_sel(imm_sel),
        .out(immext)
    );

    Alu alu(
        .a(rd1),
        .b(alu_src ? immext: rd2),
        .control(alu_control),
        .zero(alu_zero),
        .out(alu_out)
    );

    Controller controller(
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31: 25]),
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

    assign pc_target = pc + immext;
endmodule
