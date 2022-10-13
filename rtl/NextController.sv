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
    output logic [1:0] result_src,
    output logic [1:0] alu_a_src,
    output logic [1:0] alu_b_src
);

    localparam OP_LW = 7'b0000011;
    localparam OP_SW = 7'b0100011;
    localparam OP_R = 7'b0110011;
    localparam OP_I = 7'b0010011;
    localparam OP_B = 7'b1100011;
    localparam OP_J = 7'b1101111;
    
    logic [1:0] alu_op;
    logic pc_update;
    logic branch;


    assign pc_wen = (alu_zero & branch) | pc_update;

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
    enum int unsigned { 
        FETCH = 0, 
        DECODE = 1, 
        MEM_ADDR = 2, 
        MEM_READ = 3, 
        MEM_WB = 4, 
        MEM_WRITE = 5, 
        EXEC_R = 6,
        ALU_WB = 7,
        EXEC_I = 8,
        EXEC_B = 9,
        EXEC_J = 10
    } state, next_state;

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
            DECODE: begin
                case(opcode)
                    OP_R: next_state = EXEC_R;
                    OP_I: next_state = EXEC_I;
                    OP_B: next_state = EXEC_B;
                    OP_J: next_state = EXEC_J;
                    default: next_state = MEM_ADDR;
                endcase
            end
            MEM_ADDR: begin
                case(opcode)
                    OP_SW: next_state = MEM_WRITE;
                    default: next_state = MEM_READ;
                endcase
            end
            MEM_READ: next_state = MEM_WB;
            EXEC_J, EXEC_I, EXEC_R: next_state = ALU_WB; 
            EXEC_B, ALU_WB, MEM_WB, MEM_WRITE: next_state = FETCH;
        endcase
    end

    always_comb begin
        // imm_sel = 0;
        mem_write = 0;
        addr_src = 0;
        instr_flop_wen = 0;
        alu_a_src = 0;
        alu_b_src = 0;
        result_src = 0;
        reg_write = 0;
        alu_op = 0;
        branch = 0;
        pc_update = 0;
        
        unique case (state)
            FETCH: begin
                instr_flop_wen = 1;
                alu_a_src = 0;
                alu_b_src = 2;
                pc_update = 1;
                result_src = 2;
            end
            DECODE: begin
                // No-op
            end
            MEM_ADDR: begin
                alu_a_src = 2;
                alu_b_src = 1;
            end
            MEM_READ: begin
                addr_src = 1;
            end
            MEM_WB: begin
                result_src = 1;
                reg_write = 1;
            end
            MEM_WRITE: begin
                addr_src = 1;
                mem_write = 1;
            end     
            EXEC_R: begin
                alu_a_src = 2;
                alu_b_src = 0;
            end
            ALU_WB: begin
                reg_write = 1;
            end
            EXEC_I: begin
                alu_a_src = 2;
                alu_b_src = 1;
            end
            EXEC_B: begin
                branch = 1;
                alu_a_src = 2;
                alu_b_src = 0;
            end
            EXEC_J: begin
                pc_update = 1; 
                alu_a_src = 1;
                alu_b_src = 2;
            end
        endcase
    end
    
endmodule