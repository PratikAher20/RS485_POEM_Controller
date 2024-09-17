module Tx_Controller(
    input wire clk, 
    input wire seq_detect, 
    input wire rst, 
    input[15:0] data_in, 
    input [7:0] clk_per_bit,
    output wire Tx_Enable, 
    output wire Tx, 
    output reg Tx_complete
);

    // reg[15:0] data = data_in;
    reg tx_reg = 1;
    integer i_tx = 0;
    // initial Tx = 1;
    // reg rst;
    // initial rst = 0;
    initial Tx_complete = 0;
    reg tx_enable = 0;
    // initial Tx_Enable = 0;
    wire o_clock;
    reg[5:0] tx_clk_counts;
    //parameter clk_per_bit = 8'd25;

    //baud_clk b1(.i_clk(clk), .o_clk(o_clock));
       
    always @(posedge clk) begin

        if(!rst) begin
            tx_reg <= 1;
            tx_enable <= 0;
            tx_clk_counts <= 6'd0;
            i_tx <= 0;
        end

        else begin

            if(seq_detect == 1)begin         
                
                tx_enable <= 1;

            end

            if(tx_clk_counts >= (clk_per_bit - 1))begin
                tx_clk_counts <= 0;
            
                if(tx_enable == 1) begin

                    // repeat(1)
                    //     @(posedge clk);
                      
                    i_tx <= i_tx + 1;

                    case (i_tx)
                        // 0: begin
                        //     @(posedge Tx_Enable) begin
                        //         rst = 0;
                        //     end
                        // end
                        // 0 : i_tx = i_tx + 1;
                        1 : begin
                            // repeat(1)
                            //     @(posedge clk);
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
                        23 : tx_reg <= 1;
                        24 : begin
                            // rst <= 1;
                            i_tx <= 0;
                            Tx_complete <= 1;
                            tx_enable <= 0;
                        end

                        default: begin
                            tx_reg <= 1;
                            //tx_enable <= 0;
                        end
                    endcase
                end
            end
            
            else begin
                tx_clk_counts <= tx_clk_counts + 6'd1;
            end
        end
    end

    assign Tx = tx_reg;
    assign Tx_Enable = tx_enable;

endmodule

module baud_clk(input i_clk, output wire o_clk);
   
    reg[4:0] count;
    reg o_c;

    always @(posedge i_clk) begin
        //if(!reset)begin
          //  count <= 5'd0;
          //  o_c <= 1'b1;
       // end
        //else begin
            count <= count + 1;
            if(count >= 5'd25) begin     // Choose the value of count for changing the
                o_c <= ~o_c;   // baud clock given the master clock.  
                count <= 5'd0;
            end
        //end
    end
       
    assign o_clk = o_c;

endmodule


module sequence_detector(
    input clk,
    input reset,
    input Rx,
    input [7:0] sa,
    input [7:0] clk_per_bit,
    output wire detected
);
   
    reg detect;

    reg sync_flag =0;
    function [7:0]shifter(input reg [7:0] Slave_Addr);
   
        integer i;
        for (i = 0;i<8;i = i + 1) begin
            shifter[7-i] = Slave_Addr[i];
        end
       
    endfunction
    
    reg[7:0] slave_addr;
    reg[7:0] Slave_Addr;

    //parameter Slave_Addr = 8'h02;
    //parameter slave_addr = shifter(Slave_Addr);
    //parameter clk_per_bit = 8'd25;
    //reg[10:0] seq = {1'b0, slave_addr, 1'b1, 1'b1};
    reg[10:0] seq;
    reg [10:0] state = 0;  // State register to store the current sequence
    reg [7:0] bits_rx;
    wire o_clock;

    parameter IDLE = 3'b000;
    parameter RX_START_BIT = 3'b001;
    parameter RX_DETECTED_BIT = 3'b010;
    reg[2:0] uart_state;
    reg[5:0] clk_counts;

    //baud_clk b1(.i_clk(clk), .reset(reset), .o_clk(o_clock));

    // always @(Rx) begin
    //     if(Rx == 0) begin
    //         if(sync_flag == 0)begin
    //            // state <= {state[9:0], Rx};
    //             sync_flag <= 1;
    //         end
    //         // if (bits_rx == 8'd11)begin
    //         //     sync_flag <= 11'd0;
    //         // end
    //     end
    //     else begin
    //         if(bits_rx > 8'd8) begin
    //             sync_flag <= 0;
    //         end
    //     end
    // end
    
    //assign detected = (uart_state == RX_DETECTED_BIT) ? 1:0;

    always @(posedge clk) begin

        if(reset == 1)begin
            case (uart_state)
                IDLE: begin
                    Slave_Addr <= sa;
                    slave_addr <= shifter(Slave_Addr);
                    seq <= {1'b0, slave_addr, 1'b1, 1'b1};
                    detect <= 1'b0;
                    state <= 11'b0;
                    bits_rx <= 8'd0;
                    sync_flag <= 1'b0;
                    if(Rx == 1'b0) begin
                        if(clk_counts >= (clk_per_bit - 1) /2)begin
                            state <= {state[9:0], 1'b0};
                            sync_flag <= 1'b1;
                            clk_counts <= 0;
                            uart_state <= RX_START_BIT;
                        end
                        else begin
                            clk_counts <= clk_counts + 1'b1;
                            uart_state <= IDLE;
                        end
                        
                    end
                    else begin
                        uart_state <= IDLE;
                    end                    
                end
                
                RX_START_BIT: begin
                    if(clk_counts >= (clk_per_bit - 1)) begin
                            state <= {state[9:0], Rx}; 
                            clk_counts <= 0;
                        bits_rx <= bits_rx + 8'b1;
                        if(bits_rx > 8'd9) begin
                            // uart_state <= RX_DATA_BITS;
                            if(state == seq)begin
                                repeat(42)
                                    @(posedge clk);
                                detect <= 1'b1;
                                uart_state <= RX_DETECTED_BIT;
                                clk_counts <= 6'd0;
                            end
                            else begin
                                detect <= 1'b0;
                                uart_state <= IDLE;
                            end
                        end
                        else begin
                            uart_state <= RX_START_BIT;
                        end
                    end
                    else begin
                        clk_counts <= clk_counts + 1'b1;
                        uart_state <= RX_START_BIT;
                    end
                    
                end
                
               RX_DETECTED_BIT: begin
                    if(clk_counts >= (clk_per_bit - 1)) begin
                        uart_state <= IDLE;
                    end    
                    
                    else begin
                        clk_counts <= clk_counts + 1;
                        uart_state <= RX_DETECTED_BIT;
                        end
                    end
                 
                default: begin
                    detect <= 1'b0;
                    uart_state <= IDLE;
                end
            endcase
        end
        else begin
            uart_state <= IDLE;
            detect <= 0;
            bits_rx <= 0;
            clk_counts <= 0;
            state <= 11'd0;
            seq <= {1'b0, slave_addr, 1'b1, 1'b1};
        end
    
    end


        //Old version
    //     if(sync_flag)begin
    //         state <= {state[9:0], Rx};  // Shift in the new input bit
    //         bits_rx = bits_rx + 8'd1;
    //     end
    //     else begin
    //         if(state == seq)begin       // Check if the sequence is detected
    //             detect <= 1'b1;
    //             if (bits_rx > bit_per_address )begin
    //                 state <= 11'd0;
    //                 bits_rx <= 8'd0;
    //             end
    //         end
    //     end
        
    // end

    assign detected = detect;
   
endmodule



module transmitter_with_detector(
    input clk,
    input Rx,
    input rst_tx,
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
   
    //sequence_detector detector(.clk(clk), .reset(rst_tx), .Rx(Rx), .detected(sequence_detected));

   // Tx_Controller t1(.clk(clk), .seq_detect(sequence_detected), .rst(rst_tx), .data_in(byte_in), .Tx_Enable(Tx_Enable), .Tx(Tx), .Tx_complete(Tx_complete));


endmodule