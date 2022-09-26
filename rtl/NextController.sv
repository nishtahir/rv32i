module NextController (
    input logic clk,
    input logic rst,
    input logic alu_zero,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic instr_flop_wen,
    output logic pc_wen,
    output logic waddr_src,
    output logic addr_src,
    output logic mem_write,
    output logic mem_read,
    output logic reg_write,
    output logic [3:0] alu_control,
    output logic [2:0] imm_sel,
    output logic [1:0] pc_src,
    output logic [1:0] result_src,
    output logic [1:0] alu_a_src,
    output logic [1:0] alu_b_src
);
    logic [1:0] alu_op;

    AluDecoder alu_decoder(
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    InstrDecoder instr_decoder(
        .opcode(opcode),
        .imm_sel(imm_sel)
    );

    // https://www.intel.com/content/www/us/en/docs/programmable/683082/22-1/systemverilog-state-machine-coding-example.html
    enum int unsigned { FETCH = 0, DECODE = 1, MEM_ADDR = 2, MEM_READ = 3, MEM_WB = 4 } state, next_state;

    always_ff @(posedge clk, posedge rst) begin
	    if(rst)
		    state <= FETCH;
	    else
		    state <= next_state;
    end

    always_comb begin
        next_state = FETCH;
        unique case (state)
            FETCH: next_state = DECODE;
            DECODE: next_state = MEM_ADDR;
            MEM_ADDR: next_state = MEM_READ;
            MEM_READ: next_state = MEM_WB;
            MEM_WB: next_state = FETCH;             
        endcase
    end

    always_comb begin
        addr_src = 0;
        instr_flop_wen = 0;
        alu_a_src = 0;
        alu_b_src = 0;
        result_src = 0;
        reg_write = 0;
        alu_op = 0;
        
        unique case (state)
            FETCH: begin
                addr_src = 0;
                instr_flop_wen = 1;
            end
            DECODE: begin
                // No-op
            end
            MEM_ADDR: begin
                alu_a_src = 2;
                alu_b_src = 0;
            end
            MEM_READ: begin
                result_src = 0;
                addr_src = 1;
            end
            MEM_WB:begin
                result_src = 0;
                reg_write = 1;
            end         
        endcase
    end
    
endmodule