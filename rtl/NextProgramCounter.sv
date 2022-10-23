module NextProgramCounter(
    input logic clk,
    input logic rst,
    input logic wen,
    input logic [31: 0] next,
    output logic [31: 0] pc = 0
);
    
    always_ff @(posedge clk, posedge rst) begin
        if(rst) begin
            pc <= 0;
        end
        else if (wen) begin
            pc <= next;
        end
    end
endmodule
