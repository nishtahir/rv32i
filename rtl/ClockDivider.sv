module ClockDivider(
    input logic clk, 
    input logic rst, 
    output logic out
);
    always @(posedge clk) begin
        if (rst) begin
            out = 1'b0;
        end
        else begin
            out = ~out;	
        end
    end
endmodule
 