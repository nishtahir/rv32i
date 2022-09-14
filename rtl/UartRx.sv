module UartRx #(
  parameter CLK_FREQUENCY_HZ  = 100_000_000,
  parameter BAUD = 9600
) (
  input logic clk,
  input logic rst,
  input logic uart_rx,
  output logic [7: 0] data
);

  typedef enum logic [1:0] {IDLE, RECEIVING} State;
  State state;
  State next_state;

  localparam DIV_SAMPLE = 4;
  localparam DIV_COUNTER = CLK_FREQUENCY_HZ /  (BAUD * DIV_SAMPLE);
  localparam MID_POINT = DIV_SAMPLE / 2;
  localparam DIV_PER_BIT = 10;
  // Formula for baud counter is clk / baud
  // 100Mhz / (9600 * sample) rounded down
  localparam MAX_BAUD_COUNTER = CLK_FREQUENCY_HZ / (BAUD * DIV_SAMPLE) ;

  logic [$clog2(MAX_BAUD_COUNTER):0] baud_counter = 0;
  logic [3:0] bit_counter = 0;
  logic [1:0] sample_counter = 0;
  logic [9:0] data_register = 0;

  assign data = data_register[8: 1];

  logic shift;
  logic clear_sample;
  logic inc_sample;
  logic clear_bit;
  logic inc_bit;

  always @(posedge clk) begin
    if(rst) begin
      state <= IDLE;
      sample_counter <= 0;
      bit_counter <= 0;
      baud_counter <= 0;
    end
    else begin
      baud_counter <= baud_counter + 1;
      if (baud_counter == MAX_BAUD_COUNTER - 1) begin
        baud_counter <= 0;
        state <= next_state; // idle to transmitting
        if(shift) begin
          data_register <= {uart_rx, data_register[9:1]}; // shift data in from the left 
        end
        if(clear_sample) begin
          sample_counter <= 0;
        end
        if(inc_sample) begin
          sample_counter <= sample_counter + 1;
        end
        if(clear_bit) begin
          bit_counter <= 0;
        end
        if(inc_bit) begin
          bit_counter <= bit_counter + 1;
        end
      end
    end

  end

  always @(posedge clk) begin
    shift <= 0;
    clear_sample <= 0;
    inc_sample <= 0;
    clear_bit <= 0;
    inc_bit <= 0;    
    next_state <= IDLE;

    case(state) 
    IDLE: begin
      if(uart_rx) begin // RX Line is high - this is the idle behavior
        next_state <= IDLE ; // Stay in idle state
      end
      else begin
        next_state <= RECEIVING; // line was pulled low.
        clear_bit <= 1;
        clear_sample <= 1; 
      end
    end
    RECEIVING: begin
      next_state <= RECEIVING; // Stay in receiving state
      if(sample_counter == MID_POINT - 1) begin
        shift <= 1; // We're at the mid point in the sample. Capture the value
      end 
      if(sample_counter == DIV_SAMPLE - 1) begin
        // we're at the end of this bit sample

        if(bit_counter == DIV_PER_BIT - 1) begin
          // We've seen 10 bits
          next_state <= IDLE;  // transition back to the idle state
        end
        inc_bit <= 1;
        clear_sample <= 1;
      end
      else begin
        inc_sample <= 1;
      end
    end
    default: begin
      next_state <= IDLE;
    end
    endcase
  end  
endmodule