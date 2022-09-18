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
    logic [2:0] control_type;
    logic [5:0] control_instr;
    logic [11: 0] alu_instr;

    // We always want this enabled
    assign memread = 1;
    
    always_comb begin
        alu_src = 0;
        imm_sel = 0;
        result_src = 0;
        regwrite = 0;
        memwrite = 0;
        alu_op = 0;
        control_type = 0;

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
                control_type = 1;
                alu_op = 3;
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
                control_type = 2;
            end
            7'b1100111: begin // I-type Jump
                regwrite = 1;
                result_src = 2;
                control_type = 3;
            end
        endcase

        // Concat signals to derive ALU control signal
        control_instr = {control_type, funct3};
        alu_instr = {alu_op, funct3, funct7};
    end

    always_comb begin
        // Generate ALU control signal
        casez (alu_instr)
            12'b00_???_???????: alu_control = 0; // add
            12'b01_???_???????: alu_control = 1; // sub
            12'b10_000_0100000: alu_control = 1; // sub
            12'b10_000_0000000: alu_control = 0; // add
            12'b10_010_???????: alu_control = 4; // slti
            12'b10_110_???????: alu_control = 3; // or
            12'b10_111_???????: alu_control = 2; // and
            12'b10_100_???????: alu_control = 5; // xor
            12'b10_011_???????: alu_control = 6; // sltiu
            12'b10_001_???????: alu_control = 7; // slli
            12'b10_101_00?????: alu_control = 8; // srl
            12'b10_101_01?????: alu_control = 9; // sra
            12'b11_000_???????: alu_control = 5; // xor
            12'b11_001_???????: alu_control = 5; // xor
            default: alu_control = 0;
        endcase

        // Generate Branch control signal
        casez (control_instr)
            6'b001_000: pc_src = alu_zero ? 1 : 0;  // beq
            6'b001_001: pc_src = alu_zero ? 0 : 1; // bne
            6'b010_???: pc_src = 1; // jump
            6'b011_???: pc_src = 2; // i-jump
            default: pc_src = 0;
        endcase
    end

endmodule
