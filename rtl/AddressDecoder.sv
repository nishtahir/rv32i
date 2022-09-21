module AddressDecoder (
    input logic wen,
    input logic ren,
    input logic[13:0] addr,
    output logic wen1,
    output logic wen2,
    output logic wen3,
    output logic[1:0] out_sel
);
    always_comb begin
        wen1 = 0;
        wen2 = 0;
        wen3 = 0;
        case (addr[13:10])
            4'b1000: begin
                if(wen) begin
                    wen2 = 1;
                end
                out_sel = 1;
            end
            4'b1100: begin
                if(wen) begin
                    wen3 = 1;
                end
                out_sel = 2;
            end
            default: begin
                if(wen) begin
                    wen1 = 1; 
                end
                out_sel = 0;
            end
        endcase 
    end   
endmodule