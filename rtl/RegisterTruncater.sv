module RegisterTruncater (
    input logic [31:0] in,
    input logic [2:0] funct3,
    output logic [31:0] out
);

    always_comb begin
        case (funct3)
            3'b000: out = {{24{1'b0}}, in[7:0]}; // sb
            3'b001: out = {{16{1'b0}}, in[15:0]}; // sh
            default: out = in;
        endcase
    end    
    
endmodule