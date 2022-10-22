module RegisterFile (
    input logic clk,
    input logic we,
    input logic [4: 0] raddr1,
    input logic [4: 0] raddr2,
    input logic [4: 0] waddr,
    input logic [31: 0] wdata,
    output logic [31: 0] rd1,
    output logic [31: 0] rd2
);

localparam MEM_DEPTH = 32;
logic [MEM_DEPTH - 1:0] mem [MEM_DEPTH - 1:0];

initial begin
    for (integer i = 0; i < MEM_DEPTH; i = i + 1) begin
        mem[i] = 0;
    end
end


always_ff @(posedge clk) begin
    if(we) begin
        mem[waddr] = wdata;
    end
    // hardwire x0 to 0
    mem[0] = 0;
end

assign rd1 = mem[raddr1];
assign rd2 = mem[raddr2];

endmodule
