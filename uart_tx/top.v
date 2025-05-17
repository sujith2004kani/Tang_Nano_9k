module uart_tx_top(input wire clk,rst_n,output wire tx);
    parameter CLK_FREQ=27000000;
    parameter BAUD_RATE=115200;
    parameter MSG_LEN=7;

    reg [7:0] message [0:MSG_LEN-1];
    reg [2:0] char_idx;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_busy;
    reg [1:0] state;

    // UART TX
    uart_tx_8bit#(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE))
        uart_tx_inst(.clk(clk),.rst_n(rst_n),.tx_start(tx_start),.data(tx_data),.tx(tx),.tx_busy(tx_busy));

    // "HELLO\r\n"
    initial begin
        message[0]=8'd72;  // H
        message[1]=8'd69;  // E
        message[2]=8'd76;  // L
        message[3]=8'd76;  // L
        message[4]=8'd79;  // O
        message[5]=8'd13;  // Carriage return
        message[6]=8'd10;  // Line feed
    end

    // FSM States
    localparam IDLE=2'b00;
    localparam LOAD=2'b01;
    localparam WAIT=2'b10;
    localparam DELAY=2'b11;
    reg [25:0] delay_count;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state<=DELAY; char_idx<=0;
            tx_start<=0; tx_data<=0;
            delay_count<=0;
            end 
        else begin
            case(state)
                DELAY:begin
                      delay_count<=delay_count+1;
                      if(delay_count==27'd13_500_000) begin // ~0.5 sec at 27 MHz
                        delay_count<=0;
                        char_idx<=0;
                        state<=LOAD;
                        end
                      end
                LOAD:begin
                     if(!tx_busy) begin
                        tx_data<=message[char_idx];
                        tx_start<=1;
                        state<=WAIT;
                        end
                     end
                WAIT:begin
                     tx_start<=0;
                     if(tx_busy)
                        state<=IDLE;
                     end
                IDLE:begin
                     if(!tx_busy) begin
                        if(char_idx<MSG_LEN-1) begin
                            char_idx<=char_idx+1;
                            state<=LOAD;
                        end 
                        else begin
                            state<=DELAY;
                        end
                     end
                     end
                default:state<=DELAY;
            endcase
        end
    end
endmodule