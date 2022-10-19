module NextIO (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata,
    output logic [31:0] io_gpio_io_reg,
    output logic [31:0] io_uart_io_reg,
    output logic [31:0] io_uart_csr_reg
);
    localparam MEM_WIDTH = 32;
    localparam MEM_DEPTH = 32;

    logic [MEM_WIDTH - 1:0]  mem [0:MEM_DEPTH - 1];

    initial begin
        $readmemh("../nextio.mem", mem, 0, MEM_DEPTH - 1);
    end

    always @(posedge clk) begin
        if (wen) begin
            mem[waddr[4:0]] <= wdata;
        end
        if (ren) begin
            rdata <= mem[raddr[4:0]];
        end
    end

    assign io_gpio_io_reg = mem[0];
    assign io_uart_io_reg = mem[1];
    assign io_uart_csr_reg = mem[2];

endmodule