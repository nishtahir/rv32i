module NextProgramCounter(
    input logic clk,
    input logic rst,
    input logic wen,
    input logic [31: 0] next,
    output logic [31: 0] pc = 0
);
    
    always_ff @(posedge clk) begin
        if(rst)
            pc <= 0;
        else if (wen)
            pc <= next;
    end
endmodule
