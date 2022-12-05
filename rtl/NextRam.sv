module NextRam (
    input logic clk,
    input logic wen,
    input logic ren,
    input [1:0] ben,
    input logic [15:0] waddr,
    input logic [15:0] raddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata
);
    localparam MEM_DEPTH = 2048;
    localparam MEM_WIDTH = 32;


    logic [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1]; 

    initial begin
        `ifdef SIMULATION
        $readmemh("../mem/testrom.mem", mem, 0, MEM_DEPTH - 1);
        `else
        $readmemh("../mem/nextrom.mem", mem, 0, MEM_DEPTH - 1);
        `endif
    end

    always @(posedge clk) begin
        if (wen) begin
            case (ben)
                2'b00 : mem[waddr] <= wdata; // no offset
                2'b01 : mem[waddr][31:8] <= wdata[23:0]; // offset by 8
                2'b10 : mem[waddr][31:16] <= wdata[15:0]; // offset by 16
                2'b11 : mem[waddr][31:24] <= wdata[7:0]; // offset by 24
            endcase
            // for (int i = 0; i < NUM_BYTES; i = i + 1) begin
            //     if(ben[i]) ram[waddr][i] <= wdata[i*BYTE_WIDTH +: BYTE_WIDTH];
            // end
        end
        if (ren) begin
            rdata <= mem[raddr];
        end
    end
    
endmodule