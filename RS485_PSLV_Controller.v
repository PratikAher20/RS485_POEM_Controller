
////////////////////

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

    always @ (posedge seq_detect) begin

        Tx_Enable = 1;

    end
        
    always @ (posedge clk, posedge Tx_Enable) begin

        if(Tx_Enable == 1) begin
            // if(rst == 1) begin
            //   #10  rst = 0;
            //     i_tx = 1;
            //     Tx_complete = 0;
            // end

            // else begin
                i_tx = i_tx + 1;

                case (i_tx)
                    // 0: begin
                    //     @(posedge Tx_Enable) begin
                    //         rst = 0;
                    //     end
                    // end 
                    1 : begin
                        Tx_complete = 0;
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
                        assign rst = 1;
                        i_tx = 0;
                        Tx_complete <= 1;
                        Tx_Enable = 0;
                    end 

                    default: tx_reg <= 1;
                endcase
            // end
        end
        else begin
            @(posedge Tx_Enable) begin
                rst = 0;
            end
        end
        assign Tx = tx_reg;
    end


endmodule


module sequence_detector(
    input clk,
    input reset,
    input Rx,
    output reg detected
);

    parameter Slave_Addr = 8'h01;
    // reg seq = {1'b0, Slave_Addr, 1'b1, 1'b1};
    reg [10:0] state = 0;  // State register to store the current sequence

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            detected <= 0;
        end else begin
            state <= {state[9:0], Rx};  // Shift in the new input bit
            if (state == 11'b01000000011) begin  // Check if the sequence is detected
                detected <= 1;
            end else begin
                detected <= 0;
            end
        end
    end

endmodule

module transmitter_with_detector(
    input clk,
    input Rx,
    input [15:0] byte_in,
    output reg Tx_Enable,
    output wire Tx
);

    reg reset;
    wire sequence_detected;
    wire tx_complete;
    wire tx_en;
    wire rst;

    initial reset = 0;
    initial Tx_Enable = 0;
    
    sequence_detector detector(clk, reset, Rx, sequence_detected);

    Tx_Controller t1(clk, sequence_detected, byte_in, tx_en, Tx, Tx_complete);


endmodule

