/**
* Basic 3 way multiplexer implementation to contain the
* multiplexer comparator logic within a module. We're not inlining
* the case specific to make the diagrams by netlistsvg easier to read.
*/
module Mux2 #(parameter WIDTH = 32) (
    input logic select, 
    input logic [WIDTH - 1:0] d0,
    input logic [WIDTH - 1:0] d1,
    output logic [WIDTH - 1:0] q 
);
    always_comb begin
        if(select)
            q = d1;
        else
            q = d0;
    end

endmodule