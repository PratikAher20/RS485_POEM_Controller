module Tx_Controller(input wire clk, input wire seq_detect, input wire rst, input[15:0] data_in, output wire Tx_Enable, output wire Tx, output reg Tx_complete);

    // reg[15:0] data = data_in;
    reg tx_reg = 1;
    reg[31:0] i_tx;
    // initial Tx = 1;
    // reg rst;
    // initial rst = 0;
    reg tx_enable;
    // initial Tx_Enable = 0;
    wire o_clock;

    //baud_clk b1(.i_clk(clk), .o_clk(o_clock));
       
    always @(posedge clk) begin

        if(!rst) begin
            tx_reg <= 1;
            tx_enable <= 0;
            i_tx = 32'd0;
        end

        else begin

            if(seq_detect == 1)begin
               // repeat(4)
                 //   @(posedge clk);

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
                        i_tx = 32'd0;
                        Tx_complete <= 1;
                        tx_enable <= 0;
                    end

                    default: begin
                        tx_reg <= 1;
                        tx_enable <= 0;
                    end
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

module baud_clk(input i_clk, input rst, output wire o_clk);
   
    reg o_clock;
    reg[4:0] count;
    
    always @(posedge i_clk) begin
        if(!rst)begin
            count <= 5'd0;
            o_clock <= 1'b0;
        end
        else begin
            count <= count + 5'd1;
            if(count >= 5'd25) begin     // Choose the value of count for changing the
                o_clock <= ~o_clock;   // baud clock given the master clock.  
                count <= 5'd0;

            end
        end
    end
 
    assign o_clk = o_clock;

endmodule


module sequence_detector(
    input clk,
    input reset,
    input Rx,
    output wire detected
);
   
    reg detect = 1'b0;

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

    //baud_clk b1(.i_clk(clk), .o_clk(o_clock));

   // always @(Rx) begin
    //     if(Rx == 0) begin
    //         if(sync_flag == 0)begin
    //            // state <= {state[9:0], Rx};
    //             sync_flag <= 1;
    //         end
    //     end
    //     else begin
    //         if(state == seq) begin
    //             //sync_flag <= 0;
    //         end
    //     end
    // end

    // always @(posedge clk) begin
    //     // if (sync_flag == 0 && Rx == 0) begin
    //     //     detected <= 0;
    //     //     sync_flag = 1;
    //     // end else begin
       
    //     if(sync_flag)begin
    //         state <= {state[9:0], Rx};  // Shift in the new input bit
    //         if (state == seq) begin  // Check if the sequence is detected
    //             detect <= 1'b1;
    //             //sync_flag <= 0;
    //         end else begin
    //             detect <= 1'b0;
    //         end
    //     end
    //     // end
    // end

    // assign detected = detect;
    
    
    parameter CLKS_PER_BIT = 50;
    parameter IDLE         = 3'b000;
    parameter RX_START_BIT = 3'b001;
    parameter RX_DATA_BITS = 3'b010;
    parameter RX_STOP_BIT  = 3'b011;
    parameter RX_WAIT  = 3'b100;

    reg [2:0] r_SM_Main;

    reg [7:0] r_RX_Byte;
    reg [7:0] r_Clock_Count;
    reg [2:0] r_Bit_Index;

    always @(posedge clk)
    begin
        if (reset == 1)
        begin
            
                case (r_SM_Main)
                    IDLE :
                    begin
                        r_Clock_Count <= 8'h00;
                        state <= 1'b0;
                        detect <= 1'b0;
                        r_RX_Byte <= 8'h00;
                        if (Rx == 1'b0)          // Start bit detected
                        begin
                            r_SM_Main <= RX_START_BIT;
                        end
                        else
                        begin
                            r_SM_Main <= IDLE;
                        end
                    end
                    
                    // Check middle of start bit to make sure it's still low
                    RX_START_BIT :
                    begin
                        state <= 1'b0;
                        if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
                        begin
                            if (Rx == 1'b0)
                            begin
                              r_Clock_Count <= 8'h00;  // reset counter, found the middle
                              r_SM_Main     <= RX_DATA_BITS;
                            end
                            else
                              r_SM_Main <= IDLE;
                        end
                        else
                        begin
                            r_Clock_Count <= r_Clock_Count + 1;
                            r_SM_Main     <= RX_START_BIT;
                        end
                    end // case: RX_START_BIT
                    
                    
                    // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
                    RX_DATA_BITS :
                    begin
                        state <= 1'b0;
                        if (r_Clock_Count < CLKS_PER_BIT-1)
                        begin
                            r_Clock_Count <= r_Clock_Count + 1;
                            r_SM_Main     <= RX_DATA_BITS;
                        end
                        else
                        begin
                            r_Clock_Count <= 8'h00;
                            r_RX_Byte[r_Bit_Index] <= Rx;
                            
                            // Check if we have received all bits
                            if (r_Bit_Index < 7)        //Can change number of bits here
                            begin
                              r_Bit_Index <= r_Bit_Index + 3'b001;
                              r_SM_Main   <= RX_DATA_BITS;
                            end
                            else
                            begin
                              r_Bit_Index <= 3'b000;
                              r_SM_Main   <= RX_STOP_BIT;
                            end
                        end
                    end // case: RX_DATA_BITS
                    
                    
                    // Receive Stop bit.  Stop bit = 1
                    RX_STOP_BIT :
                    begin
                        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                        if (r_Clock_Count < CLKS_PER_BIT-1)
                        begin
                            r_Clock_Count <= r_Clock_Count + 1;
                            r_SM_Main     <= RX_STOP_BIT;
                        end
                        else
                        begin
                            if(Rx == 1'b1)
                            begin
                                r_SM_Main     <= IDLE;
                                if(r_RX_Byte == Slave_Addr)begin
                                    detect <= 1;
                                    repeat(4)
                                        @(posedge clk);
                                end
                            end
                            else
                            begin
                                r_SM_Main     <= RX_WAIT;   
                            end
                            r_Clock_Count <= 8'h00;
                        end
                    end // case: RX_STOP_BIT
                    
                    RX_WAIT:
                    begin
                        if (r_Clock_Count < 6)
                        begin
                            state <= 1'b1;
                            r_Clock_Count <= r_Clock_Count + 1;
                            r_SM_Main     <= RX_WAIT;
                        end
                        else
                        begin 
                            r_SM_Main <= IDLE;
                            state <= 1'b0;
                            // o_write_pointer <= o_write_pointer + 13'b0000000000001;
                            r_Clock_Count <= 8'h00;
                        end
                    end

                    
                    default :
                    begin
                        r_SM_Main <= IDLE;
                       // detect <= 0;
                    end

                endcase
        end
        else
        begin
            // o_write_pointer <= 13'h0000;
            state <= 1'b0;
            r_RX_Byte <= 8'h00;
            detect <= 0;
            r_Clock_Count <= 8'h00;
            r_Bit_Index <= 3'b000;
            r_SM_Main <= IDLE;
        end
     
    end


    assign detected = detect;
   
endmodule


module transmitter_with_detector(
    input clk,
    input valid,
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
   
    //sequence_detector detector(.clk(clk), .reset(reset), .Rx(Rx), .detected(sequence_detected), .state(state));

    //Tx_Controller t1(.clk(clk), .valid(valid), .seq_detect(sequence_detected), .rst(rst_tx), .data_in(byte_in), .Tx_Enable(Tx_Enable), .Tx(Tx), .Tx_complete(Tx_complete));


endmodule