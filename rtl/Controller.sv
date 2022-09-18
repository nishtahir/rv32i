module Controller (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic alu_zero,
    output logic alu_src,
    output logic memwrite,
    output logic memread,
    output logic regwrite,
    output logic [3:0] alu_control,
    output logic [1:0] pc_src,
    output logic [1:0] imm_sel,
    output logic [1:0] result_src
);
    logic [1:0] alu_op;
    logic [11: 0] alu_instr;
    logic branch;
    logic jump;

    // We always want this enabled
    assign memread = 1;
    
    always_comb begin
        alu_src = 0;
        imm_sel = 0;
        pc_src = 0;
        result_src = 0;
        regwrite = 0;
        memwrite = 0;
        alu_op = 0;
        jump = 0;

        // https://cepdnaclk.github.io/e16-co502-RV32IM-pipeline-implementation-group3/RV32IM%20-%20Sheet1.pdf
        // I couldn't find a reference that names the opcodes specifially so rather than invent my own naming
        // scheme, i'm adding them here as is.
        case(opcode)
            7'b0000011: begin // I-type load
                regwrite = 1;
                alu_src = 1;
                result_src = 1;
            end
            7'b0100011: begin // S-type store 
                imm_sel = 1;
                alu_src = 1;
                memwrite = 1;
            end
            7'b0110011: begin // R-type arithmetic
                regwrite = 1;
                alu_op = 2;
            end
            7'b1100011: begin // B-type branch
                imm_sel = 2;
                alu_op = 1;
                pc_src = alu_zero ? 1 : 0;
            end
            7'b0010011: begin // I-type arithmetic immediate
                regwrite = 1;
                imm_sel = 0;
                alu_src = 1;
                alu_op = 2;
            end
            7'b1101111: begin // J-type Jump
                regwrite = 1;
                imm_sel = 3;
                result_src = 2;
                pc_src = 1;
            end
            7'b1100111: begin // I-type Jump
                regwrite = 1;
                result_src = 2;
                pc_src = 2;
            end
        endcase
        // pc_src = (alu_zero & branch) | jump;

        // Concat signals to derive ALU control signal
        alu_instr = {alu_op, funct3, funct7};
    end

    // Generate ALU control signal
    always_comb begin
        casez (alu_instr)
            12'b00_???_???????: alu_control = 0; // add
            12'b01_???_???????: alu_control = 1; // sub
            12'b??_000_0100000: alu_control = 1; // sub
            12'b??_000_0000000: alu_control = 0; // add
            12'b??_010_???????: alu_control = 4; // slti
            12'b??_110_???????: alu_control = 3; // or
            12'b??_111_???????: alu_control = 2; // and
            12'b??_100_???????: alu_control = 5; // xor
            12'b??_011_???????: alu_control = 6; // sltiu
            12'b??_001_???????: alu_control = 7; // slli
            12'b??_101_00?????: alu_control = 8; // srl
            12'b??_101_01?????: alu_control = 9; // sra
            default: alu_control = 0;
        endcase
    end

endmodule
