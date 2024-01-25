module Tx_Controller(input wire clk, input wire seq_detect, input[15:0] data_in, output reg Tx_Enable, output reg Tx, output reg Tx_complete);

    // reg[15:0] data = data_in;
    reg tx_reg = 1;
    integer i_tx = 0;
    initial Tx = 1;
    reg tx_en = 1;
    reg rst;
    initial rst = 0;
    initial Tx_complete = 0;
    initial Tx_Enable = 0;
    wire o_clock;

    baud_clk b1(.i_clk(clk), .o_clock(o_clock));

    always @ (seq_detect) begin
        // repeat(1)
        //     @(posedge clk);
        if(seq_detect == 1)begin
            Tx_Enable <= 1;

            repeat(24)
                @(posedge clk);
            Tx_Enable <= 0;
        end

    end
       
    always @(o_clock) begin

       if(clk == 1) begin
        if(Tx_Enable == 1) begin
            // if(rst == 1) begin
            //   #10  rst = 0;
            //     i_tx = 1;
            //     Tx_complete = 0;
            // end

            // else begin
                i_tx <= i_tx + 1;

                case (i_tx)
                    // 0: begin
                    //     @(posedge Tx_Enable) begin
                    //         rst = 0;
                    //     end
                    // end
                    1 : begin
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
                    24 : begin
                        rst <= 1;
                        i_tx <= 0;
                        Tx_complete <= 1;
                        //Tx_Enable <= 0;
                    end

                    default: tx_reg <= 1;
                endcase
            // end
            end
       
        else begin
            @(posedge Tx_Enable) begin
                rst <= 0;
            end
        end
        end
        Tx <= tx_reg;
    end


endmodule

module baud_clk(input i_clk, output reg o_clock);
   
    reg[4:0] count;
    initial count = 0;
    initial o_clock = 1;

    always @(posedge i_clk) begin
        count = count + 1;
        if(count == 25) begin     // Choose the value of count for changing the
            o_clock = ~o_clock;   // baud clock given the master clock.  
            count = 0;

        end
    end
       

endmodule


module sequence_detector(
    input clk,
    input reset,
    input Rx,
    output reg detected
);
   
    reg sync_flag =0;
    function [7:0]shifter(input reg [7:0] Slave_Addr);
   
        integer i;
        for (i = 0;i<8;i = i + 1) begin
            shifter[7-i] = Slave_Addr[i];
        end
       
    endfunction

    parameter Slave_Addr = 8'h01;
    parameter slave_addr = shifter(Slave_Addr);
    reg[10:0] seq = {1'b0, slave_addr, 1'b1, 1'b1};
    reg [10:0] state = 0;  // State register to store the current sequence
    wire o_clock;

    baud_clk b1(.i_clk(clk), .o_clock(o_clock));

    always @(Rx) begin
        if(Rx == 0) begin
            if(sync_flag == 0)begin
               // state <= {state[9:0], Rx};
                sync_flag <= 1;
            end
        end
        else begin
            if(state == seq) begin
                sync_flag <= 0;
            end
        end
    end

    always @(posedge o_clock) begin
        // if (sync_flag == 0 && Rx == 0) begin
        //     detected <= 0;
        //     sync_flag = 1;
        // end else begin
       
        if(sync_flag)begin
            state <= {state[9:0], Rx};  // Shift in the new input bit
            if (state == seq) begin  // Check if the sequence is detected
                detected <= 1;
                //sync_flag <= 0;
            end else begin
                detected <= 0;
            end
        end
        // end
    end
endmodule

module transmitter_with_detector(
    input clk,
    input Rx,
    input [15:0] byte_in,
    output wire Tx_complete,
    output wire Tx_Enable,
    output wire Tx,
    output sequence_detected
);

    reg reset;
    // wire sequence_detected;
    // wire Tx_complete;
    wire rst;

    initial reset = 0;
    // initial Tx_Enable = 0;
   
    sequence_detector detector(.clk(clk), .reset(reset), .Rx(Rx), .detected(sequence_detected));

    Tx_Controller t1(.clk(clk), .seq_detect(sequence_detected), .data_in(byte_in), .Tx_Enable(Tx_Enable), .Tx(Tx), .Tx_complete(Tx_complete));


endmodule