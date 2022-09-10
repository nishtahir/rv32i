module Top (
    input logic clk,
    input logic rst,
    output logic memwrite,
    output logic [31: 0] writedata,
    output logic [31: 0] dataaddr,
    // Debug signals
    output logic [31: 0] pc,
    output logic [31: 0] instr,
    output logic [31: 0] rd1,
    output logic [31: 0] rd2
);

    logic [31: 0] pcplus4; 
    logic [31: 0] readdata;
    logic [31: 0] immext;

    logic [3: 0] alu_control;
    logic [31: 0] alu_out;

    ProgramCounter counter(
        .clk(clk),
        .rst(rst),
        .next(pcplus4),
        .pc(pc),
        .pcplus4(pcplus4)
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
        .wen(0),
        .ren(1),
        .waddr(0),
        .raddr(alu_out),
        .wdata(0),
        .rdata(writedata)
    );

    RegisterFile regwrite(
        .clk(clk),
        .we(1),
        .raddr1(instr[19: 15]), // rs1
        .raddr2(instr[24: 20]), // rs2
        .waddr(instr[11: 7]),   // rd
        .wdata(writedata),  
        .rd1(rd1),
        .rd2(rd2)
    );

    ImmSignExtend extend (
        .instr(instr),
        .imm_sel(1),
        .out(immext)
    );

    Alu alu(
        .a(rd1),
        .b(immext),
        .control(0),
        .out(alu_out)
    );

// Core riscv(
//     .clk(clk),
//     .rst(rst),
//     .instr(instr),
//     .memwrite(memwrite),
//     .pc(pc),
//     .aluresult(dataaddr),
//     .readdata(readdata),
//     .writedata(writedata)
// );

endmodule


