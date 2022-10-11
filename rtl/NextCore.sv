module NextCore (
    input logic clk,
    input logic rst,
    // Debug signals
    output logic [31:0] instr
);

    logic reg_write;
    logic [31:0] pc;
    logic [4:0] reg_raddr1;
    logic [4:0] reg_raddr2;
    logic [4:0] reg_waddr;
    logic [31:0] reg_wdata;
    
    logic mem_write;
    logic mem_read;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;

    // Buffer signals
    logic [31:0] alu_result;
    logic [31:0] rd1_result;
    logic [31:0] rd2_result;
    logic [31:0] old_pc;
 
    // Control signals
    logic instr_flop_wen;
    logic pc_wen;
    logic waddr_src;
    logic addr_src;
    logic [3:0] alu_control;
    logic [2:0] imm_sel;
    logic [1:0] pc_src;
    logic [1:0] result_src;
    logic [1:0] alu_a_src;
    logic [1:0] alu_b_src;

    // Data signals
    logic alu_zero;
    logic [2:0] funct3;
    logic [31:0] pc_next;
    logic [31:0] imm_ext;
    logic [31:0] alu_out;
    logic [31:0] alu_a;
    logic [31:0] alu_b;

    logic [31:0] rdata;
    logic [31:0] result_out;
    logic [31:0] rd1;
    logic [31:0] rd2;
    

    assign reg_raddr1 = instr[19:15];
    assign reg_raddr2 = instr[24:20];
    assign reg_waddr = instr[11:7];
    assign reg_wdata = result_out;
    assign pc_next = result_out;
    assign mem_wdata = rd2;

    NextController controller(
        .alu_zero(alu_zero),
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .instr_flop_wen(instr_flop_wen),
        .pc_wen(pc_wen),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .reg_write(reg_write),
        .waddr_src(waddr_src),
        .addr_src(addr_src),
        .alu_control(alu_control),
        .imm_sel(imm_sel),
        .pc_src(pc_src),
        .result_src(result_src),
        .alu_a_src(alu_a_src),
        .alu_b_src(alu_b_src)
    );

    NextProgramCounter counter(
        .clk(clk),
        .rst(rst),
        .next(pc_next),
        .pc(pc),
        .wen(pc_wen)
    );

    NextMemory mem(
        .clk(clk),
        .wen(mem_write),
        .ren(mem_read),
        .waddr(mem_addr[15:0]),
        .raddr(mem_addr[15:0]),
        .wdata(mem_wdata),
        .rdata(mem_rdata)
    );

    Flopenr instr_flop (
        .clk(clk), 
        .rst(rst), 
        .en(instr_flop_wen),
        .in(mem_rdata),
        .out(instr)
    );

    RegisterFile regfile(
        .clk(clk),
        .we(reg_write),
        .raddr1(reg_raddr1), // rs1
        .raddr2(reg_raddr2), // rs2
        .waddr(reg_waddr),   // rd
        .wdata(reg_wdata),  
        .rd1(rd1_result),
        .rd2(rd2_result)
    );

    Flopr rd1_flop (
        .clk(clk), 
        .rst(rst), 
        .in(rd1_result),
        .out(rd1)
    );

    Flopr rd2_flop (
        .clk(clk), 
        .rst(rst), 
        .in(rd2_result),
        .out(rd2)
    );


    ImmGen imm_gen (
        .instr(instr),
        .imm_sel(imm_sel),
        .out(imm_ext)
    );

    Alu alu(
        .a(alu_a),
        .b(alu_b),
        .control(alu_control),
        .zero(alu_zero),
        .out(alu_result)
    );

    Flopr alu_out_flop (
        .clk(clk), 
        .rst(rst), 
        .in(alu_result),
        .out(alu_out)
    );

    Flopr rdata_flop (
        .clk(clk), 
        .rst(rst), 
        .in(mem_rdata),
        .out(rdata)
    );

    Mux3 alu_a_mux (
        .select(alu_a_src),
        .d00(pc), 
        .d01(old_pc), 
        .d10(rd1),
        .q(alu_a)
    );

    Mux3 alu_b_mux (
        .select(alu_b_src),
        .d00(rd2), 
        .d01(imm_ext), 
        .d10(4),
        .q(alu_b)
    );

    Mux3 alu_result_mux (
        .select(result_src),
        .d00(alu_out), 
        .d01(rdata), 
        .d10(alu_result),
        .q(result_out)
    );

    Mux2 mem_addr_mux (
        .d0(pc),
        .d1(result_out),
        .q(mem_addr)
    );

    Flopr pc_flop (
        .clk(clk), 
        .rst(rst), 
        .in(pc),
        .out(old_pc)
    );
    
endmodule