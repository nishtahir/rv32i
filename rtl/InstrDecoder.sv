module InstrDecoder(
    input logic [6:0] opcode,
    output logic [2:0] imm_sel
);
    always_comb begin
        imm_sel = 0;
        case(opcode)
            7'b0000011: begin // I-type load
                // No-op
            end
            7'b0100011: begin // S-type store 
                imm_sel = 1;
            end
            7'b0110011: begin // R-type arithmetic
                // No-op
            end
            7'b1100011: begin // B-type branch
                imm_sel = 2;                
            end
            7'b0010011: begin // I-type arithmetic immediate
                // No-op
            end
            7'b1101111: begin // J-type Jump
                imm_sel = 3;
            end
            7'b1100111: begin // I-type Jump
                // No-op
            end
            7'b0110111: begin // lui
                imm_sel = 4;
            end
        endcase
    end
endmodule