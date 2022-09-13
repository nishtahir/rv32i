module UartRxTest;
  reg rst = 1;
  reg clk = 0;
  always #1 clk = !clk;

  reg uart_rx = 1;
  reg [7:0] data;

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

    #1 uart_rx = 0;
    #20 uart_rx = 1;

    #300 $finish;
  end
endmodule
