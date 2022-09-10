module Alu (
    input  logic [31: 0] a,
    input  logic [31: 0] b,
    input  logic [3: 0] control,
    output logic zero,
    output logic neg,
    output logic carry,
    output logic overflow,
    output logic [31: 0] out
);

    localparam ADD = 0;
    localparam SUB = 1;
    localparam AND = 2;
    localparam OR  = 3;

    // localparam XOR = 4'h4;

    // // Shift left logical
    // localparam SLL = 4'h5;
    // // Shift right logical
    // localparam SRL = 4'h7;
    // // Set less than
    // localparam SLT = 4'h8;
    // // Shift right arithmetic
    // localparam SRA = 4'h6;

    // // Not sure why we have nor 
    // localparam NOR = 4'h9;

    always_comb begin
        carry = 0;
        overflow = 0;
        case (control)
            ADD: begin
                {carry, out} = {1'b0, a} + {1'b0, b};
                // Signed bit of a and out are different and
                // Signed bit of a and b are the same
                overflow = (a[31] == ~out[31]) & (a[31] == b[31]);
            end
            SUB: begin
                {carry, out} = {1'b0, a} - {1'b0, b};
                // Signed bit of a and out are different and
                // Signed bit of a and b are different
                overflow = (a[31] == ~out[31]) & (a[31] == ~b[31]);
            end
            AND: out = a & b;
            OR : out = a | b;
            // SLL: 
            // XOR: out = a ^ b;
            // SUB: out = a - b;
            // SLT: 
            // SRL: 
            // SRA: 
            // NOR: 
            default: out = 0;
        endcase
    end

    assign zero = out == 0;
    assign neg = out[31];
    
endmodule