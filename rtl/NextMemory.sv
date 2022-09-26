// Combined instruction and Data Memory
module NextMemory (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata
);

    // Calculate the number of bits required for the address
    localparam MEM_WIDTH = 32;
    localparam MEM_DEPTH = 256;

    logic [MEM_WIDTH - 1:0]  mem [0:MEM_DEPTH - 1];

    initial begin
        // Zero out RAM
        for (integer i = 0; i < MEM_DEPTH; i = i + 1) begin
            mem[i] = 0;
        end
    end

    // Interact with the memory block
    always @(posedge clk) begin
        if (wen) begin
            mem[waddr] = wdata;
        end
    end

    always_comb begin
        if (ren) begin
            rdata = mem[raddr];
        end 
        else begin
            rdata = 0;
        end
    end
    
endmodule