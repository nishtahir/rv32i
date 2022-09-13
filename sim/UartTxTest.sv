module UartTxTest;
  /* Make a reset that pulses once. */
  reg clk = 0;
  always #1 clk = !clk;

  reg reset = 0;
  reg send = 0;
  reg [7:0] data = 8'b10101010;

  wire ready;
  wire uart_tx;

  UartTx uut (
    .clk(clk),
    .rst(reset),
    .send(send),
    .data(data),
    .uart_tx(uart_tx)
  );

  initial begin
    $dumpfile("../build/UartTxTest.vcd");
    $dumpvars(0, UartTxTest);
    #5 reset = 1;
    #10 reset = 0;
    #10 send = 1;
    #15 send = 0;
    #20 assert(reset == 0);
    //   # 100 $stop;
    #300 $finish;
  end

  // initial
    // $monitor("At time %t, value = %h (%0d)", $time, value, value);
endmodule
