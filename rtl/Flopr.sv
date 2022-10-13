module Flopr #(parameter WIDTH = 32)(
    input logic clk, 
    input logic rst, 
    input logic [WIDTH - 1:0] in,
    output logic [WIDTH - 1:0] out = 0
);
    always_ff @(posedge clk, posedge rst) begin
        if (rst) out <= 0;
        else out <= in;
    end
endmodule