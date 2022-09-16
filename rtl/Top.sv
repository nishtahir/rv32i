module Top (
    input logic clk,
    input logic rst,
    // Debug signals
    output logic reg_write,
    output logic [31:0] pc,
    output logic [31:0] instr,
    output logic [4:0] reg_raddr1,
    output logic [4:0] reg_raddr2,
    output logic [4:0] reg_waddr,
    output logic [31:0] reg_wdata,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);
    // Control signals
    logic alu_src;
    logic alu_zero;
    logic result_src;
    logic pc_src;
    logic memwrite;
    logic memread;
    logic [3:0] alu_control;
    logic [1:0] imm_sel;
    
    // Data signals
    logic [31:0] pc_target;
    logic [31:0] pc_plus_4; 
    logic [31:0] readdata;
    logic [31:0] readdata_ext;
    logic [31:0] immext;
    logic [31:0] alu_out;
    logic [2:0] funct3;

    assign pc_target = pc + immext;
    assign reg_raddr1 = instr[19:15];
    assign reg_raddr2 = instr[24:20];
    assign reg_wdata = result_src ? readdata_ext: alu_out;
    assign reg_waddr = instr[11:7];
    assign funct3 = instr[14:12];

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
        .addr(pc[7:2]),
        .dout(instr)
    );

    Ram #(
        .MEM_WIDTH(32),
        .MEM_DEPTH(256)
    ) datamem (
        .clk(clk),
        .wen(memwrite),
        .ren(memread),
        .waddr(alu_out[7:0]),
        .raddr(alu_out[7:0]),
        .wdata(rd2),
        .rdata(readdata)
    );

    RegisterFile regfile(
        .clk(clk),
        .we(reg_write),
        .raddr1(reg_raddr1), // rs1
        .raddr2(reg_raddr2), // rs2
        .waddr(reg_waddr),   // rd
        .wdata(reg_wdata),  
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
        .funct3(funct3),
        .funct7(instr[31:25]),
        .alu_zero(alu_zero),
        .alu_src(alu_src),
        .result_src(result_src),
        .pc_src(pc_src),
        .memwrite(memwrite),
        .memread(memread),
        .regwrite(reg_write),
        .alu_control(alu_control),
        .imm_sel(imm_sel)
    );

    ResultExtender result_ext(
        .in(readdata),
        .out(readdata_ext),
        .funct3(funct3)
    );

endmodule
