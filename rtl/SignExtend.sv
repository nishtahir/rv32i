module SignExtend #(parameter WIDTH = 15)(
    input  logic [WIDTH - 1:0] in,
    output logic [31:0] out
);
    assign out = {{(32 - WIDTH){in[WIDTH - 1]}}, in};
endmodule
