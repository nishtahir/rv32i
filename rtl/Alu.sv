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

    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam SLT = 4'b0100;

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
            SLT: out = ($signed(a) < $signed(b)) ? 1 : 0;
            default: out = 0;
        endcase
    end

    assign zero = out == 0;
    assign neg = out[31];
    
endmodule
