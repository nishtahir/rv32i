module ProgramCounter(
    input logic clk,
    input logic rst,
    input logic [31: 0] next,
    output logic [31: 0] pc,
    output logic [31: 0] pcplus4
);
    logic [31: 0] counter = 0;
    
    assign pc = counter;
    assign pcplus4 = counter + 4;

    always @(posedge clk) begin
        if(rst)
            counter = 0;
        else
            counter = next;
    end
endmodule
