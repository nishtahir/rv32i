module ClockDivider(
    input logic clk, 
    input logic rst, 
    output logic out = 0
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end
        else begin
            out <= ~out;	
        end
    end
endmodule
 