module ResultExtender (
    input logic [31:0] in,
    input logic [2:0] funct3,
    output logic [31:0] out
);

    logic [31:0] b;
    logic [31:0] h;

    SignExtend #(.WIDTH(8)) b_ext(
        .in(in[7:0]),
        .out(b)
    );

    SignExtend #(.WIDTH(16)) h_ext(
        .in(in[15:0]),
        .out(h)
    );

    always_comb begin
        case (funct3)
            3'b000: out = b;
            3'b001: out = h;
            // Zero extend
            3'b100: out = {{24{1'b0}}, in[7:0]}; // lbu
            3'b101: out = {{16{1'b0}}, in[15:0]}; // lhu
            default: out = in;
        endcase
    end    
endmodule