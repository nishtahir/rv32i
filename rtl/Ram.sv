module Ram (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [13:0] waddr,
    input logic [13:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata
);
    `ifdef SIMULATION
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
	`else 
        logic [31:16] hi_bits; 
        logic [15:0] lo_bits; 

        // TODO - this isn't supported on every ice40 package
        SB_SPRAM256KA spram_0 (
            .ADDRESS(waddr),
            .DATAIN(wdata[31:16]),
            .MASKWREN({wen, wen, wen, wen}),
            .WREN(wen),
            .CHIPSELECT(1'b1),
            .CLOCK(clk),
            .STANDBY(1'b0),
            .SLEEP(1'b0),
            .POWEROFF(1'b1),
            .DATAOUT(hi_bits)
        );

        SB_SPRAM256KA spram_1 (
            .ADDRESS(waddr),
            .DATAIN(wdata[15:0]),
            .MASKWREN({wen, wen, wen, wen}),
            .WREN(wen),
            .CHIPSELECT(1'b1),
            .CLOCK(clk),
            .STANDBY(1'b0),
            .SLEEP(1'b0),
            .POWEROFF(1'b1),
            .DATAOUT(lo_bits)
        );

        assign rdata = {hi_bits, lo_bits};
    `endif


endmodule