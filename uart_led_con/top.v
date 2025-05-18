module uart_rx_top (
    input wire clk,
    input wire rst_n,
    input wire rx,
    output wire [5:0] led
);

    parameter CLK_FREQ = 27000000;
    parameter BAUD_RATE = 115200;

    wire [7:0] rx_data;
    wire data_ready;
    reg [5:0] led_val;

    uart_rx_8bit #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) 
    uart_rx_inst(.clk(clk),.rst_n(rst_n),.rx(rx),.data_out(rx_data),.data_ready(data_ready));

    //LED register interface (maps received value to LED)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led_val<= 6'b000000;
        else if (data_ready) begin
            if (rx_data[5:0]<6)  
                led_val<=(6'b000001<<rx_data[5:0]);
            else
                led_val<=6'b000000; 
        end
    end
    assign led = ~led_val;
endmodule