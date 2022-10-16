module AluDecoder (
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [2:0] alu_op,
    output logic [3:0] alu_control
);
    logic [12:0] alu_instr;
    assign alu_instr = {alu_op, funct3, funct7};

    always_comb begin
        // Generate ALU control signal
        casez (alu_instr)
            13'b000_???_???????: alu_control = 0; // add
            13'b001_???_???????: alu_control = 1; // sub
            13'b010_000_0100000: alu_control = 1; // sub
            13'b010_000_0000000: alu_control = 0; // add
            13'b010_010_???????: alu_control = 4; // slti
            13'b010_110_???????: alu_control = 3; // or
            13'b010_111_???????: alu_control = 2; // and
            13'b010_100_???????: alu_control = 5; // xor
            13'b010_011_???????: alu_control = 6; // sltiu
            13'b010_001_???????: alu_control = 7; // slli
            13'b010_101_00?????: alu_control = 8; // srl
            13'b010_101_01?????: alu_control = 9; // sra

            // Branches
            13'b011_000_???????: alu_control = 5; // xor
            13'b011_001_???????: alu_control = 5; // xor
            13'b011_100_???????: alu_control = 4; // slt
            13'b011_110_???????: alu_control = 6; // sltu
            13'b011_101_???????: alu_control = 4; // slt
            13'b011_111_???????: alu_control = 6; // sltu
            // JALR and
            13'b100_???_???????: alu_control = 2; // and
            default: alu_control = 0;
        endcase
    end
endmodule