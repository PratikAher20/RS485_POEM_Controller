
// module RS_485_Controller(PCLK, PRESERN, PSEL, PENABLE, PREADY, PSLVERR, PWRITE, PADDR, PWDATA, PRDATA);
// input PCLK;
// input PRESERN;
// input PENABLE, PSEL, PWRITE;
// input[7:0] PADDR;
// input wire [7:0] PWDATA;
// output wire[7:0] PRDATA;
// output reg PREADY

// output f_tx_full;

// wire wr_enable, rd_enable;
// assign wr_enable = (PENABLE && PWRITE && PSEL);
// assign rd_enable = (PENABLE && !PWRITE && PSEL);

// reg [15:0] data;


// always@ (posedge wr_enable)
// begin

//     PREADY = 1;

//     if(PRESETN == 0)
//     begin
//         data = 8'h00;
//         f_tx_full = 8'h00;
//     end

//     if(PADDR == 8'h00)
//     begin
//         data = PWDATA
//     end

// end

// // always @(posedge rd_enable) begin
// //     PREADY = 1;

// //     if(PADDR == 8'h04)
// //     begin
        
// //     end

    
// // end


// endmodule



////////////////////

module Tx_Controller(input wire clk, input wire seq_detect, output reg Tx_Enable, output reg Tx, output reg Tx_complete); 

    reg[15:0] data = 16'h3f0a;
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
                    2 : tx_reg <= data[0];
                    3 : tx_reg <= data[1];
                    4 : tx_reg <= data[2];
                    5 : tx_reg <= data[3];
                    6 : tx_reg <= data[4];
                    7 : tx_reg <= data[5];
                    8 : tx_reg <= data[6];
                    9 : tx_reg <= data[7];
                    10 : tx_reg <= 0;
                    11 : tx_reg <= 1;
                    12 : tx_reg <= 0;
                    13 : tx_reg <= data[8];
                    14 : tx_reg <= data[9];
                    15 : tx_reg <= data[10];
                    16 : tx_reg <= data[11];
                    17 : tx_reg <= data[12];
                    18 : tx_reg <= data[13];
                    19 : tx_reg <= data[14];
                    20 : tx_reg <= data[15];
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

    reg [10:0] state = 0;  // State register to store the current sequence

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            detected <= 0;
        end else begin
            state <= {state[9:0], Rx};  // Shift in the new input bit
            if (state == 12'b01000000011) begin  // Check if the sequence is detected
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
    input [7:0] byte_in,
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

    Tx_Controller t1(clk, sequence_detected, tx_en, Tx, Tx_complete);


endmodule



// module Rx_controller(input wire clk, input wire Rx, output reg Tx_Enable);

// reg tx;
// initial tx = 0;
// reg[7:0] Slave_Addr = 8'h01;
// input wire TX;
// reg rst;
// initial rst = 1;
// // assign Tx_Enable = tx;

// parameter state0 = 4'b0000;
// parameter state1 = 4'b0001;
// parameter state2 = 4'b0011;
// parameter state3 = 4'b0010;
// parameter state4 = 4'b0110;
// parameter state5 = 4'b0111;
// parameter state6 = 4'b0101;
// parameter state7 = 4'b0100;
// parameter state8 = 4'b1100;
// parameter state9 = 4'b1101;
// parameter state10 = 4'b1111;
// parameter state11 = 4'b1110;

// reg[3:0] curr_state, nxt_state;
// // initial curr_state = 4'b0000;

// // always @(negedge Rx) begin
// //     if(rst == 1)
// //         rst = 0; 
// //     assign reset = rst;
// // end


// always @(posedge clk, posedge rst) begin
//     if (rst == 1) 
//         curr_state <= state0;
//     else
//         curr_state <= nxt_state;    
//     end

// always @(curr_state, Rx) begin

//     if(Rx == 0)begin
//         if(rst == 1)
//             rst = 0;
//     end

//     case (curr_state)

//         state0 : begin
//             if(Rx == Slave_Addr[0]) 
//                 nxt_state = state1;
//             else
//                 nxt_state = state0;
//         end

//         state1: begin
//             if(Rx == Slave_Addr[1])
//                 nxt_state = state2;
//             else
//                 nxt_state = state1;
//         end

//         state2: begin
//             if(Rx == Slave_Addr[2])
//                 nxt_state = state3;
//             else
//                 nxt_state = state2;
//         end

//         state3: begin
//             if(Rx == Slave_Addr[3])
//                 nxt_state = state4;
//             else
//                 nxt_state = state3;
//         end        

//         state4: begin
//             if(Rx == Slave_Addr[4])
//                 nxt_state = state5;
//             else
//                 nxt_state = state4;
//         end

//         state5: begin
//             if(Rx == Slave_Addr[5])
//                 nxt_state = state6;
//             else
//                 nxt_state = state5;
//         end

//         state6: begin
//             if(Rx == Slave_Addr[6])
//                 nxt_state = state7;
//             else
//                 nxt_state = state6;
//         end

//         state7: begin
//             if(Rx == Slave_Addr[7])
//                 nxt_state = state8;
//             else
//                 nxt_state = state7;
//         end

//         state8: begin
//             if(Rx == 1)
//                 nxt_state = state9;
//             else
//                 nxt_state = state8;
//         end

//         state9: begin
//             if(Rx == 1)         //Mod Bit
//                 nxt_state = state10;
//             else
//                 nxt_state = state9;
//         end

//         state10:  begin
//             if(Rx == 1)         //Stop Bit
//                 nxt_state = state11;
//             else
//                 nxt_state = state10;
//         end

//         state11: begin
//             nxt_state = state0;
//         end
            
            
//         default: nxt_state = state0;
//     endcase
// end

// always @(curr_state) begin
//     case (curr_state)
//         state0 : tx = Tx_Enable;
//         state1 : tx = 0;
//         state2 : tx = 0;
//         state3 : tx = 0;
//         state4 : tx = 0;
//         state5 : tx = 0;
//         state6 : tx = 0;
//         state7 : tx = 0;
//         state7 : tx = 0;
//         state8 : tx = 0;
//         state9 : tx = 0;
//         state10 : tx = 0;
//         state11: tx = 1;
//         default: tx = 0;
//     endcase
//     assign Tx_Enable = tx;
// end

// endmodule


// module top(input wire clk, input wire Rx, inout wire tx_en, output wire Tx);


//     Rx_controller r1(clk, Rx, tx_en);
    
//     Tx_Controller_1 c1(clk, tx_en, Tx);    
    
    

// endmodule