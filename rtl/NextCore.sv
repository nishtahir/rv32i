module NextCore (
    input logic clk,
    input logic rst,
    input logic [7:0] io_addr,
    output logic [31:0] io_data,
    output logic [31:0] io_uart_io_reg,
    output logic [31:0] io_uart_csr_reg,
    output logic [31:0] io_gpio_io_reg
);

    logic reg_write;
    logic [31:0] instr;
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
    logic [1:0] result_src;
    logic [1:0] alu_a_src;
    logic [1:0] alu_b_src;

    // Data signals
    logic alu_zero;
    logic [31:0] pc_next;
    logic [31:0] imm_ext;
    logic [31:0] alu_out;
    logic [31:0] alu_a;
    logic [31:0] alu_b;

    logic [31:0] rdata;
    logic [31:0] rdata_ext;
    logic [31:0] wdata_ext;
    logic [31:0] result_out;
    logic [31:0] rd1;
    logic [31:0] rd2;
    
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign reg_raddr1 = instr[19:15];
    assign reg_raddr2 = instr[24:20];
    assign reg_waddr = instr[11:7];
    assign reg_wdata = result_out;
    assign pc_next = result_out;
    assign mem_wdata = wdata_ext;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    NextController controller(
        .clk(clk),
        .rst(rst),
        .alu_zero(alu_zero),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .instr_flop_wen(instr_flop_wen),
        .pc_wen(pc_wen),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .reg_write(reg_write),
        .addr_src(addr_src),
        .alu_control(alu_control),
        .imm_sel(imm_sel),
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
        // Assume memory access is byte aligned
        .waddr(mem_addr[17:2]),
        .raddr(mem_addr[17:2]),
        .wdata(mem_wdata),
        .rdata(mem_rdata),
        .io_gpio_io_reg(io_gpio_io_reg),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg)
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

    ResultExtender result_ext(
        .in(rdata),
        .funct3(funct3),
        .out(rdata_ext)
    );

    RegisterTruncater rd_trunc(
        .in(rd2),
        .out(wdata_ext),
        .funct3(funct3)
    );

    Mux4 alu_a_mux (
        .select(alu_a_src),
        .d00(pc), 
        .d01(old_pc), 
        .d10(rd1),
        .d11(alu_out),
        .q(alu_a)
    );

    Mux4 alu_b_mux (
        .select(alu_b_src),
        .d00(rd2), 
        .d01(imm_ext), 
        .d10(4),
        .d11(~(32'h00000001)),
        .q(alu_b)
    );

    Mux4 alu_result_mux (
        .select(result_src),
        .d00(alu_out), 
        .d01(rdata_ext), 
        .d10(alu_result),
        .d11(imm_ext),
        .q(result_out)
    );

    Mux2 mem_addr_mux (
        .select(addr_src),
        .d0(pc),
        .d1(result_out),
        .q(mem_addr)
    );

    Flopenr pc_flop (
        .en(instr_flop_wen),
        .clk(clk), 
        .rst(rst), 
        .in(pc),
        .out(old_pc)
    );

endmodule