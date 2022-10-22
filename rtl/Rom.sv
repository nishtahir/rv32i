module Rom #(
    parameter MEM_WIDTH = 32,
    parameter MEM_DEPTH = 64
) (
    input logic [ADDR_WIDTH - 1: 0] addr,
    output logic [MEM_WIDTH - 1: 0] dout
);
    // Calculate the number of bits required for the address
    localparam ADDR_WIDTH = $clog2(MEM_DEPTH);
    logic [MEM_WIDTH - 1: 0] mem [MEM_DEPTH - 1 : 0];

    initial begin
        $readmemh("../testrom.mem", mem, 0, MEM_DEPTH - 1);
    end

    always_comb begin
        dout = mem[addr];
    end

endmodule
