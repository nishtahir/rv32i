// Combined instruction and Data Memory
module NextMemory (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    input logic [7:0] io_addr,    
    output logic [31:0] rdata,
    output logic [31:0] io_data,
    output logic [31:0] io_uart_io_reg,
    output logic [31:0] io_uart_csr_reg,
    output logic [31:0] io_gpio_io_reg
);

    // Calculate the number of bits required for the address
    localparam MEM_WIDTH = 32;
    localparam MEM_DEPTH = 256;

    logic [MEM_WIDTH - 1:0]  mem [0:MEM_DEPTH - 1];

    assign io_data = mem[io_addr];

    // initial begin
    //     // Zero out RAM
    //     for (integer i = 0; i < MEM_DEPTH; i = i + 1) begin
    //         mem[i] = 0;
    //     end
    // end
    initial begin
        $readmemh("../nextrom.mem", mem, 0, MEM_DEPTH - 1);
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