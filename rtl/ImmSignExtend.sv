module ImmSignExtend (
    input logic [31:0] instr,
    input logic [1:0] imm_sel,
    output logic [31:0] out
);

    logic [31:0] imm_i;
    logic [31:0] imm_s;
    logic [31:0] imm_b;
    logic [31:0] imm_j;

    SignExtend #(.WIDTH(12)) i_type(
        .in(instr[31:20]),
        .out(imm_i)
    );

    SignExtend #(.WIDTH(12)) s_type(
        .in({instr[31:25], instr[11:7]}),
        .out(imm_s)
    );

    SignExtend #(.WIDTH(13)) b_type(
        // > The only difference between the S and B formats is that the 12-bit immediate field is used to encode
        //   branch offsets in multiples of 2 in the B format. Instead of shifting all bits in the instruction-encoded
        //   immediate left by one in hardware as is conventionally done, the middle bits (imm[10:1]) and sign
        //   bit stay in fixed positions, while the lowest bit in S format (inst[7]) encodes a high-order bit in B
        //   format.
        // 
        // Since the value is always multiples of 2, the imm[0] offset bit can be assumed to always be a 0
        // https://stackoverflow.com/questions/58414772/why-are-risc-v-s-b-and-u-j-instruction-types-encoded-in-this-way
        .in({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}),
        .out(imm_b)
    );

    SignExtend #(.WIDTH(21)) j_type(
        .in({instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}),
        .out(imm_j)
    );

    always_comb begin
        case (imm_sel)
            2'b00: out = imm_i; 
            2'b01: out = imm_s;
            2'b10: out = imm_b;
            2'b11: out = imm_j;
            default: out = imm_i;
        endcase
    end
endmodule
