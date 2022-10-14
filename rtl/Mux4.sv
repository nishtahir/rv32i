/**
* 4 way multiplexer implementation to contain comparator logic within a module. 
* We're not inlining the case to make the diagrams by netlistsvg easier to read.
*/
module Mux4 #(parameter WIDTH = 32) (
    input logic [1:0] select, 
    input logic [WIDTH - 1:0] d00,
    input logic [WIDTH - 1:0] d01,
    input logic [WIDTH - 1:0] d10,
    input logic [WIDTH - 1:0] d11,
    output logic [WIDTH - 1:0] q 
);
    always_comb begin
        case (select)
            2'b00: q = d00;
            2'b01: q = d01; 
            2'b10: q = d10;
            2'b11: q = d11;
            default: q = 0;             
        endcase
    end

endmodule