module UartRxTest;
  logic rst = 1;
  logic clk = 0;
  always #1 clk = !clk;

  logic uart_rx = 1;
  logic [7:0] data;

  UartRx  #(
    .CLK_FREQUENCY_HZ(100), 
    .BAUD(10)
  ) uart_rx_uut (
    .clk(clk),
    .rst(rst),
    .data(data),
    .uart_rx(uart_rx)
  );

  initial begin
    $dumpfile("../build/UartRxTest.vcd");
    $dumpvars(0, UartRxTest);

    #2 uart_rx = 0;
    #2 uart_rx = 1;

    #2 $finish;
  end
endmodule
