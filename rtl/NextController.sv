module NextController (
    input logic clk,
    input logic rst,
    input logic alu_zero,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic instr_flop_wen,
    output logic pc_wen,
    output logic mem_read,
    output logic mem_write,
    output logic reg_write,
    output logic addr_src,
    output logic [3:0] alu_control,
    output logic [2:0] imm_sel,
    output logic [1:0] result_src,
    output logic [1:0] alu_a_src,
    output logic [1:0] alu_b_src
);

    localparam OP_LW    = 7'b0000011;
    localparam OP_SW    = 7'b0100011;
    localparam OP_R     = 7'b0110011;
    localparam OP_I     = 7'b0010011;
    localparam OP_B     = 7'b1100011;
    localparam OP_J     = 7'b1101111;
    localparam OP_JR    = 7'b1100111;
    localparam OP_LUI   = 7'b0110111;
    localparam OP_AUIPC = 7'b0010111;
    
    logic pc_update;
    logic branch;
    logic [2:0] alu_op;

    assign mem_read = 1;
    assign pc_wen =  branch | pc_update;

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
    typedef enum int unsigned { 
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
        EXEC_J = 10,
        EXEC_JR = 11,
        IMM_WB = 12,
        EXEC_AUIPC = 13,
        START_UP = 14,
        MEM_W_BUF = 15,
        MEM_R_BUF = 16
    } ControllerState;

    ControllerState state = START_UP;
    ControllerState next_state = FETCH;

    always_ff @(posedge clk, posedge rst) begin
	    if(rst)
		    state <= START_UP;
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
                    OP_AUIPC: next_state = EXEC_AUIPC;
                    default: next_state = MEM_ADDR;
                endcase
            end
            MEM_ADDR: begin
                case(opcode)
                    OP_LW:  next_state = MEM_READ;
                    OP_SW:  next_state = MEM_WRITE;
                    OP_JR:  next_state = EXEC_JR;
                    OP_LUI: next_state = IMM_WB;
                    default: next_state = MEM_READ;
                endcase 
            end
            MEM_READ: next_state = MEM_R_BUF;
            MEM_R_BUF: next_state = MEM_WB;
            MEM_WRITE: next_state = MEM_W_BUF;
            EXEC_AUIPC, EXEC_J, EXEC_JR, EXEC_I, EXEC_R: next_state = ALU_WB; 
            START_UP, IMM_WB, EXEC_B, ALU_WB, MEM_WB, MEM_W_BUF: next_state = FETCH;
        endcase
    end

    always_comb begin
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
            START_UP: begin
                
            end
            FETCH: begin
                instr_flop_wen = 1;
                alu_a_src = 0;
                alu_b_src = 2;
                pc_update = 1;
                result_src = 2;
            end
            DECODE: begin
                alu_a_src = 1;
                alu_b_src = 1;
            end
            MEM_ADDR: begin
                alu_a_src = 2;
                alu_b_src = 1;
            end
            MEM_READ: begin
                alu_a_src = 2;
                alu_b_src = 1;
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
                alu_op = 2;
            end
            ALU_WB: begin
                reg_write = 1;
            end
            EXEC_I: begin
                alu_a_src = 2;
                alu_b_src = 1;
                alu_op = 2;
            end
            EXEC_B: begin
                alu_a_src = 2;
                alu_b_src = 0;
                alu_op = 3;
                // There's probably a better way to do this,
                // but I've been at this too long, it works and I'm tired...
                casez (funct3)
                    3'b000: begin                   // beq
                        branch = alu_zero ? 1 : 0;
                    end
                    3'b001: begin                   // bne
                        branch = alu_zero ? 0 : 1;
                    end
                    3'b110,                         // bleu
                    3'b100: begin                   // ble
                        branch = alu_zero ? 0 : 1; 
                    end
                    3'b111,                         // bgeu
                    3'b101: begin                   // bge
                        branch = alu_zero ? 1 : 0;
                    end
                endcase
            end
            EXEC_J: begin
                pc_update = 1; 
                alu_a_src = 1;
                alu_b_src = 2;
            end
            EXEC_JR: begin
                pc_update = 1; 
                alu_a_src = 3;
                alu_b_src = 3;
                alu_op = 4;
            end
            IMM_WB: begin
                reg_write = 1;
                result_src = 3;
            end
            EXEC_AUIPC: begin
                alu_a_src = 1;
                alu_b_src = 1;
            end
            MEM_W_BUF: begin
            end
            MEM_R_BUF: begin
                addr_src = 1;
            end
        endcase
    end
    
endmodule