module NextIO (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    input logic io_uart_tx_busy,
    input logic io_uart_rx_busy,
    output logic io_uart_send,
    output logic io_uart_read,
    output logic [31:0] rdata = 0,
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

    // Mem writes
    always @(posedge clk) begin
        if (wen) begin
            mem[waddr[4:0]] <= wdata;
        end
        if (ren) begin
            rdata <= mem[raddr[4:0]];
        end
    end

    logic was_busy = 0;

    // [rx_busy, tx_busy, rx_read, tx_send]
    always @(posedge clk) begin
        if(io_uart_tx_busy === 1) begin
            was_busy = 1;
        end

        if(io_uart_tx_busy === 0 & was_busy) begin
            // If we were busy but not anymore, reset the send bit
            was_busy <= 0;
            mem[2][0] <= 0;
        end

        // if(io_uart_rx_busy === 1) begin
        //     // Reset read bit
        //     mem[2][1] = 0;
        // end
    end

    assign io_gpio_io_reg = mem[0];
    assign io_uart_io_reg = mem[1];
    assign io_uart_csr_reg = mem[2];

    assign io_uart_send = mem[2][0];
    assign io_uart_read = mem[2][1];



endmodule