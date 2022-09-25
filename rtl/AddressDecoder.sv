module AddressDecoder (
    input logic wen,
    input logic ren,
    input logic[15:0] addr,
    output logic wen1,
    output logic wen2,
    output logic[1:0] out_sel
);
    always_comb begin
        wen1 = 0;
        wen2 = 0;
        case (addr[15:8])
            8'hFF: begin // 0x3C00 // 15360
                if(wen) begin
                    wen2 = 1;
                end
                out_sel = 1;
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