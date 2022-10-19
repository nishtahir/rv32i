module NextAddressDecoder (
    input logic wen,
    input logic ren,
    input logic[15:0] addr,
    output logic[1:0] ren_src,
    output logic[1:0] wen_src,
    output logic[1:0] out_src
);

    always_comb begin
        wen_src = 0;
        ren_src = 0;
        out_src = 0;
        case (addr[15:8])
            8'h02: begin
                if(wen) begin
                    wen_src = 1;
                end
                if(ren) begin
                    ren_src = 1;
                end
                out_src = 1;
            end
        endcase
    end

endmodule