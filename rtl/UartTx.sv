module UartTx #(
  parameter CLK_FREQUENCY_HZ  = 100_000_000,
  parameter BAUD = 9600
) (
  input logic clk,
  input logic rst,
  input logic send,
  input logic [7: 0] data,
  output logic uart_tx,
  output logic busy
);

  // Formula for baud counter is clk / baud
  // 100Mhz / 6600 = 10416 rounded down
  localparam MAX_BAUD_COUNTER = CLK_FREQUENCY_HZ / BAUD ;

  // https://www.cs.utexas.edu/users/moore/acl2/manuals/current/manual/index-seo.php/VL2014____VL-CLOG2
  logic [$clog2(MAX_BAUD_COUNTER):0] baud_counter = 0;
  logic [3:0] bit_counter = 0;
  logic [9:0] sr_register = 0;

  logic shift;
  logic load;
  logic clear;

  typedef enum logic [1:0] {IDLE, SENDING} UartTx;
  UartTx state = IDLE;
  UartTx next_state;

  assign busy = state === SENDING;

  always @(posedge clk) begin
    if(rst) begin
      state <= IDLE;
      bit_counter <= 0;
      baud_counter <= 0;
    end
    else begin
      baud_counter <= baud_counter + 1;
      if (baud_counter == MAX_BAUD_COUNTER) begin
        state <= next_state; // idle to transmitting
        baud_counter <= 0;
        if(load) begin
          // [stop_bit, ..., start_bit] ===> 
          sr_register <= {1'b1, data, 1'b0};
        end
        if(clear) begin
          bit_counter <= 0;
        end
        if(shift) begin
          sr_register <= sr_register >> 1; // shift right 
          bit_counter <= bit_counter + 1;
        end
      end
    end

  end

  always @(posedge clk) begin
    load <= 0;
    shift <= 0;
    clear <= 0;
    uart_tx <= 1;

    case(state) 
    IDLE: begin
      if(send) begin
        next_state <= SENDING;
        load <= 1;
        shift <= 0;
        clear <= 0; 
      end
      else begin
        next_state <= IDLE;
        uart_tx <= 1; 
      end
    end
    SENDING: begin
      if(bit_counter == 10) begin
        next_state <= IDLE; // go to idle state
        clear <= 1;
      end 
      else begin
        next_state <= SENDING; // stay in transmit
        uart_tx <= sr_register[0];
        shift <= 1; // shift right by 1
      end
    end
    default: begin
      next_state <= IDLE;
    end
    endcase
  end  
endmodule