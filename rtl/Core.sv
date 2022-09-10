module Core (
    input logic clk,
    input logic rst,
    input logic [31: 0] instr,
    input logic [31: 0] readdata,
    output logic memwrite,
    output logic [31: 0] pc,
    output logic [31: 0] aluresult,
    output logic [31: 0] writedata
);

logic alusrc;
logic regwrite;
logic jump;

logic [1: 0] memtoreg;
logic [1: 0] immsrc;
logic [2: 0] alucontrol;

endmodule