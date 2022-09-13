module Ram #(
    parameter MEM_WIDTH = 32,
    parameter MEM_DEPTH = 256
    // ,
    // parameter INIT_FILE = ""
) (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [ADDR_WIDTH - 1:0] waddr,
    input logic [ADDR_WIDTH - 1:0] raddr,
    input logic [MEM_WIDTH - 1:0] wdata,
    output logic [MEM_WIDTH - 1:0] rdata
);
    // Calculate the number of bits required for the address
    localparam  ADDR_WIDTH = $clog2(MEM_DEPTH);

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
            mem[waddr] <= wdata;
        end
        
        // Read from memory
        if (ren) begin
            rdata <= mem[raddr];
        end
    end

    // Initialization (if available)
    // initial if (INIT_FILE) begin
    //     $readmemh(INIT_FILE, mem);
    // end

endmodule
