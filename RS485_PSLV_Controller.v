module Tx_Controller(input wire clk, input wire seq_detect, input wire rst, input[15:0] data_in, output wire Tx_Enable, output wire Tx, output reg Tx_complete);

    // reg[15:0] data = data_in;
    reg tx_reg = 1;
    reg[31:0] i_tx = 32'h00000000;
    // initial Tx = 1;
    // reg rst;
    // initial rst = 0;
    initial Tx_complete = 0;
    reg tx_enable = 0;
    initial tx_enable = 0;
    // initial Tx_Enable = 0;
    wire o_clock;

    baud_clk b1(.i_clk(clk), .o_clk(o_clock));
       
    always @(posedge clk) begin

        if(!rst) begin
            tx_reg <= 1;
            tx_enable <= 0;
            i_tx = 0;
        end

        else begin

            if(seq_detect == 1)begin
                repeat(4)
                    @(posedge clk);

                tx_enable <= 1;

            end


            if(tx_enable == 1) begin

                  
                i_tx = i_tx + 1;

                case (i_tx)
                    // 0: begin
                    //     @(posedge Tx_Enable) begin
                    //         rst = 0;
                    //     end
                    // end
                    // 0 : i_tx = i_tx + 1;
                    1 : begin
                        repeat(2)
                            @(posedge clk);
                        Tx_complete <= 0;
                        tx_reg <= 0;
                    end
                    2 : tx_reg <= data_in[0];
                    3 : tx_reg <= data_in[1];
                    4 : tx_reg <= data_in[2];
                    5 : tx_reg <= data_in[3];
                    6 : tx_reg <= data_in[4];
                    7 : tx_reg <= data_in[5];
                    8 : tx_reg <= data_in[6];
                    9 : tx_reg <= data_in[7];
                    10 : tx_reg <= 0;
                    11 : tx_reg <= 1;
                    12 : tx_reg <= 0;
                    13 : tx_reg <= data_in[8];
                    14 : tx_reg <= data_in[9];
                    15 : tx_reg <= data_in[10];
                    16 : tx_reg <= data_in[11];
                    17 : tx_reg <= data_in[12];
                    18 : tx_reg <= data_in[13];
                    19 : tx_reg <= data_in[14];
                    20 : tx_reg <= data_in[15];
                    21 : tx_reg <= 0;
                    22 : tx_reg <= 1;
                    23 : begin
                        // rst <= 1;
                        i_tx = 32'h00000000;
                        Tx_complete <= 1;
                        tx_enable <= 0;
                    end

                    default: tx_reg <= 1;
                endcase
            end

            else begin
                tx_reg <= 1;
            end
        end
    end

    assign Tx = tx_reg;
    assign Tx_Enable = tx_enable;

endmodule

module baud_clk(input i_clk, output wire o_clk);
   
    reg o_clock = 1;
    reg[5:0] count = 6'd0;

    always @(posedge i_clk) begin
        count <= count + 5'd1;
        if(count >= 6'd24) begin     // Choose the value of count for changing the
            o_clock <= ~o_clock;   // baud clock given the master clock.  
            count <= 6'd0;

        end
    end
       
    assign o_clk = o_clock;

endmodule


module sequence_detector(
    input clk,
    input reset,
    input Rx,
    output wire detected,
    output reg[10:0] state
);
   
    reg sync_flag =0;
    reg detect = 1'b0;

    function [7:0]shifter(input reg [7:0] Slave_Addr);
   
        integer i;
        for (i = 0;i<8;i = i + 1) begin
            shifter[7-i] = Slave_Addr[i];
        end
       
    endfunction

    parameter Slave_Addr = 8'h01;
    parameter slave_addr = shifter(Slave_Addr);
    reg[10:0] seq = {1'b0, slave_addr, 1'b1, 1'b1};
   // reg [10:0] state = 0;  // State register to store the current sequence
    wire o_clock;

    baud_clk b1(.i_clk(clk), .o_clk(o_clock));

    always @(Rx) begin
        if(Rx == 0) begin
            if(sync_flag == 0)begin
               // state <= {state[9:0], Rx};
                sync_flag <= 1;
            end
        end
        else begin
            if(state == seq) begin
                //sync_flag <= 0;
            end
        end
    end

    always @(posedge clk) begin
        // if (sync_flag == 0 && Rx == 0) begin
        //     detected <= 0;
        //     sync_flag = 1;
        // end else begin
       
        if(sync_flag)begin
            state <= {state[9:0], Rx};  // Shift in the new input bit
            if (state == seq) begin  // Check if the sequence is detected
                detect <= 1'b1;
                //sync_flag <= 0;
            end else begin
                detect <= 1'b0;
            end
        end
        // end
    end

    assign detected = detect;
endmodule

module transmitter_with_detector(
    input clk,
    input Rx,
    input [15:0] byte_in,
    output wire Tx_complete,
    output wire Tx_Enable,
    output wire Tx,
    output sequence_detected,
    output[10:0] state
);

    reg reset;
    // wire sequence_detected;
    // wire Tx_complete;
    wire rst;

    initial reset = 0;
    // initial Tx_Enable = 0;
   
    sequence_detector detector(.clk(clk), .reset(reset), .Rx(Rx), .detected(sequence_detected), .state(state));

    Tx_Controller t1(.clk(clk), .seq_detect(sequence_detected), .rst(rst_tx), .data_in(byte_in), .Tx_Enable(Tx_Enable), .Tx(Tx), .Tx_complete(Tx_complete));


endmodule