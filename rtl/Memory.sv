module Memory (
    input logic clk,
    input logic wen,
    input logic ren,
    input logic [13:0] waddr,
    input logic [13:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata,
    input logic [7:0] io_addr,    
    output logic [31:0] io_data,
    output logic [31:0] io_uart
);

    logic wen1;
    logic wen2;
    logic wen3;
    logic [1:0] dec_out;
    logic [31:0] ram_out;
    logic [31:0] io_mem [7:0];

    AddressDecoder decoder(
        .wen(wen),
        .ren(ren),
        .addr(waddr),
        .wen1(wen1),
        .wen2(wen2),
        .wen3(wen3),
        .out_sel(dec_out)
    );

    Ram ram (
        .clk(clk),
        .wen(wen1),
        .ren(ren),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .rdata(ram_out)
    );

    initial begin
        // Zero out RAM
        for (integer i = 0; i < 7; i = i + 1) begin
            io_mem[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (wen2) begin
            io_mem[waddr[3:0]] = wdata;
        end
    end

    always_comb begin
        case(dec_out)
            1: rdata = io_mem[raddr[3:0]]; 
            default: rdata = ram_out;
        endcase 
    end

    assign io_data = io_mem[io_addr];
    assign io_uart = io_mem[0];
endmodule