module uart_rx_8bit (input wire clk, rst_n,rx,
    output reg [7:0] data_out, output reg data_ready);

    parameter CLK_FREQ=27000000;
    parameter BAUD_RATE=115200;
    localparam BAUD_TICK=CLK_FREQ/BAUD_RATE;
    localparam HALF_BAUD=BAUD_TICK/2;

    reg [3:0] bit_idx;
    reg [13:0] tick_count;
    reg [9:0] rx_shift;
    reg [1:0] state;
    localparam IDLE=2'b00;
    localparam START=2'b01;
    localparam RECEIVE=2'b10;
    localparam DONE=2'b11;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            bit_idx<=0;    tick_count<=0;
            rx_shift<=0;   data_out<=0;
            data_ready<=0; state<=IDLE;
        end 
        else begin
            data_ready<=0;  // default low
            case(state)
                IDLE:begin
                     if(!rx) begin  // Start bit detected
                         tick_count<=0;
                         state<=START;
                     end
                     end
                START:begin
                      if(tick_count == HALF_BAUD) begin
                         tick_count<=0;
                         bit_idx<=0;
                         state<=RECEIVE;
                         end 
                      else begin
                        tick_count<=tick_count + 1;
                        end
                      end
                RECEIVE:begin
                        if(tick_count==BAUD_TICK-1) begin
                            tick_count<=0;
                            rx_shift<={rx,rx_shift[9:1]};
                            bit_idx<=bit_idx+1;
                            if(bit_idx==9) begin
                                data_out<=rx_shift[8:1];
                                data_ready<=1;
                                state<=IDLE;
                            end
                        end 
                        else begin
                            tick_count<=tick_count + 1;
                            end
                        end
                default:state<=IDLE;
            endcase
        end
    end
endmodule