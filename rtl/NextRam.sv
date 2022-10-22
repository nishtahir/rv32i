module NextRam (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata
);
    localparam MEM_WIDTH = 32;
    localparam MEM_DEPTH = 2048;

    logic [MEM_WIDTH - 1:0]  mem [0:MEM_DEPTH - 1];

    initial begin
        `ifdef SIMULATION
        $readmemh("../testrom.mem", mem, 0, MEM_DEPTH - 1);
        `else
        $readmemh("../nextrom.mem", mem, 0, MEM_DEPTH - 1);
        `endif
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