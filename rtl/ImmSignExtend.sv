module ImmSignExtend #(parameter WIDTH = 15) (
    input logic [31:0] instr,
    input logic [2:0] imm_sel,
    output logic [31:0] out
);

    logic [31:0] imm_i;
    logic [31:0] imm_s;

    SignExtend #(.WIDTH(12)) itype(
        .in(instr[31:20]),
        .out(imm_i)
    );

    SignExtend #(.WIDTH(12)) stype(
        .in({instr[31:25], instr[11:7]}),
        .out(imm_s)
    );

    always_comb begin
        case (imm_sel)
            1: out = imm_s;
            default: out = imm_i;
        endcase
    end
endmodule