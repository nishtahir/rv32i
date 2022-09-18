module ImmGen (
    input logic [31:0] instr,
    input logic [2:0] imm_sel,
    output logic [31:0] out
);

    logic [31:0] imm_i;
    logic [31:0] imm_s;
    logic [31:0] imm_b;
    logic [31:0] imm_j;
    logic [31:0] imm_u;

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
        imm_u = {instr[31:12], 12'h000};

        case (imm_sel)
            3'b000: out = imm_i; 
            3'b001: out = imm_s;
            3'b010: out = imm_b;
            3'b011: out = imm_j;
            3'b100: out = imm_u;
            default: out = imm_i;
        endcase
    end
endmodule
