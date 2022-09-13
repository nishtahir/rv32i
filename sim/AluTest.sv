module AluTest;

    logic rst = 0;
    logic clk = 0;
    always #1 clk = !clk;

    logic [31:0] a = 0;
    logic [31:0] b = 0;
    logic [31:0] out;
    logic [3:0] control = 0;
    logic zero;
    
    Alu uut(
        .a(a),
        .b(b),
        .control(control),
        .out(out),
        .zero(zero)
    );

    initial begin
        $dumpfile("../build/AluTest.vcd");
        $dumpvars(0, AluTest);

        // Check Add
        #2
        a = 10;
        b = 20;
        control = 0;

        // Check Sub
        #2
        a = 45;
        b = 25;
        control = 1;

        #2
        a = 45;
        b = 25;
        control = 1;

        #2
        // Check Zero
        a = 0;
        b = 0;
        control = 2;

        #2
        // Check carry
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        control = 0;

        #2
        // Check overflow
        a = 32'h7FFFFFFF;
        b = 32'h00000001;
        control = 0;

        // Check SLT
        #2
        a = 32'h000000FF;
        b = 32'h00000F00;
        control = 4;

        #2
        a = 32'h000000FF;
        b = 32'h00000F00;
        control = 4;

               #2
        a = 32'h100000FF;
        b = 32'h00000F00;
        control = 4;

        #20 
        $finish;
    end

endmodule
