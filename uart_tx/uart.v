module uart_tx_8bit (input wire clk,rst_n,tx_start,
    input wire [7:0] data,output reg tx,tx_busy);

    parameter CLK_FREQ=27000000;
    parameter BAUD_RATE=115200;
    localparam BAUD_TICK=CLK_FREQ/BAUD_RATE;
    reg [3:0] bit_idx=0;
    reg [13:0] tick_count=0;
    reg [9:0] tx_shift=10'b1111111111;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx<=1;
            tx_busy<=0;
            bit_idx<=0;
            tick_count<=0;
        end else begin
            if (tx_start && !tx_busy) begin
                tx_shift<={1'b1,data,1'b0};
                tx_busy<=1;
                bit_idx<=0;
                tick_count<=0;
            end else if (tx_busy) begin
                if (tick_count==BAUD_TICK-1) begin
                    tick_count<=0;
                    tx<=tx_shift[0];
                    tx_shift<={1'b1,tx_shift[9:1]};  // shift right
                    bit_idx<=bit_idx+1;
                    if (bit_idx==9) begin
                        tx_busy<=0;
                        tx<=1;
                    end
                end else begin
                    tick_count<=tick_count+1;
                end
            end
        end
    end
endmodule