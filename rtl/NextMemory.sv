// Combined instruction and Data Memory
module NextMemory (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata,
);
    // Calculate the number of bits required for the address
    localparam MEM_WIDTH = 32;
    `ifdef SIMULATION
    localparam MEM_DEPTH = 64;
    `else
    localparam MEM_DEPTH = 2048;
    `endif

    logic [MEM_WIDTH - 1:0]  mem [0:MEM_DEPTH - 1];

    initial begin
        $readmemh("../nextrom.mem", mem, 0, MEM_DEPTH - 1);
    end

    always @(posedge clk) begin
        if (wen) begin
            mem[waddr] <= wdata;
        end
        if (ren) begin
            rdata <= mem[raddr];
        end
    end
    
endmodule