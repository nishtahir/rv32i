module UartTxTest;
  logic clk = 0;
  always #1 clk = !clk;

  logic reset = 0;
  logic send = 0;
  logic [7:0] data = 8'b10101010;

  logic ready;
  logic uart_tx;

  UartTx #(
    .CLK_FREQUENCY_HZ(100), 
    .BAUD(10)
  ) uut (
    .clk(clk),
    .rst(reset),
    .send(send),
    .data(data),
    .uart_tx(uart_tx)
  );

  initial begin
    $dumpfile("../build/UartTxTest.vcd");
    $dumpvars(0, UartTxTest);

    #2 reset = 1;
    #2 reset = 0;

    #2 send = 1;
    #2 send = 0;

    #2 assert(reset == 0);
    #100 $finish;
  end

endmodule
