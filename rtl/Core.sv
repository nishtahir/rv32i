module Core (
    input logic clk,
    input logic rst,
    output logic [7:0] io_addr,
    output logic [31:0] io_data,
    output logic [31:0] io_uart_io_reg,
    output logic [31:0] io_uart_csr_reg,
    output logic [31:0] io_gpio_io_reg,
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
    logic memwrite;
    logic memread;
    logic [1:0] pc_src;
    logic [3:0] alu_control;
    logic [1:0] result_src;
    logic [2:0] imm_sel;
    
    // Data signals
    logic [31:0] pc_target;
    logic [31:0] pc_next;
    logic [31:0] pc_plus_4; 
    logic [31:0] readdata;
    logic [31:0] readdata_ext;
    logic [31:0] wdata_ext;
    logic [31:0] immext;
    logic [31:0] alu_out;
    logic [2:0] funct3;

    assign reg_raddr1 = instr[19:15];
    assign reg_raddr2 = instr[24:20];
    assign reg_waddr = instr[11:7];
    assign funct3 = instr[14:12];

    ProgramCounter counter(
        .clk(clk),
        .rst(rst),
        .next(pc_next),
        .pc(pc),
        .pcplus4(pc_plus_4)
    );

    Rom #(
        .MEM_WIDTH(32),
        .MEM_DEPTH(64)
    ) imem (
        // We're assuming that the last 2 bits of the pc will always be 0
        // since they are assumed to be multiples of 4
        // This should be 6 bits wide since the memory depth is 2^6 = 64
        // https://arstechnica.com/civis/viewtopic.php?t=801655
        .addr(pc[7:2]),
        .dout(instr)
    );

    Memory mem (
        .clk(clk),
        .wen(memwrite),
        .ren(memread),
        .waddr(alu_out[15:0]),
        .raddr(alu_out[15:0]),
        .wdata(wdata_ext),
        .rdata(readdata),
        .io_addr(io_addr),
        .io_data(io_data),
        .io_uart_io_reg(io_uart_io_reg),
        .io_uart_csr_reg(io_uart_csr_reg),
        .io_gpio_io_reg(io_gpio_io_reg)
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

    ImmGen extend (
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

    RegisterTruncater rd_trunc(
        .in(rd2),
        .out(wdata_ext),
        .funct3(funct3)
    );

    always_comb begin
        case (result_src)
            2'b01: reg_wdata = readdata_ext;
            2'b10: reg_wdata = pc_plus_4; 
            2'b11: reg_wdata = immext;
            default: reg_wdata = alu_out; 
        endcase

        case (pc_src) 
            2'b01: pc_next = pc + immext;
            2'b10: pc_next = (rd1 + immext) & ~(32'h00000001);
            default: pc_next = pc_plus_4;
        endcase
    end

endmodule
