module AluDecoder (
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [1:0] alu_op,
    output logic [3:0] alu_control
);
    logic [11:0] alu_instr;
    assign alu_instr = {alu_op, funct3, funct7};

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
            12'b11_100_???????: alu_control = 4; // slt
            12'b11_110_???????: alu_control = 6; // sltu
            12'b11_101_???????: alu_control = 4; // slt
            12'b11_111_???????: alu_control = 6; // sltu
            default: alu_control = 0;
        endcase
    end
endmodule