module CMD_Detector (
    input clk,
    input reset,
    input Rx,
    input [7:0] PAYLOAD_ID,
    input [7:0] clk_per_bit,
    output wire CMD_Detected,
    output CMD_WCLK,
    output[7:0] PARAM_Byte,
    output[4:0] CMD_WADDR

);

    reg cmd_sync_flag =0;
    reg cmd_wclk;
    reg chk_tc_cntr_flg;
    reg chk_pay_id_flg;
    reg chk_tc_len_flg;
    reg[7:0] tc_cntr_curr;
    reg[7:0] tc_cntr_prev;
    reg[7:0] pay_id;

    function [7:0]shifter(input reg [7:0] CMD_BYTE);
   
        integer i;
        for (i = 0;i<8;i = i + 1) begin
            shifter[7-i] = CMD_BYTE[i];
        end
       
    endfunction

    // baud_clk(clk, o_clk);
    reg [7:0] CMD_BYTE;
    reg [7:0] cmd_byte;
    
    // parameter bit_per_address = 8'd8;
    //parameter clk_per_bit = 8'd50;
    reg[11:0] cmd_seq;
    reg [10:0] cmd_state = 0;  // State register to store the current sequence
    reg [7:0] cmd_bits_rx;

    parameter cmd_id = 8'hFC;
    //parameter PAYLOAD_ID = 8'h01;
    parameter Minor_ID = 8'hFE;
    // parameter Major_ID = 8'hFD;
    parameter CMD_IDLE = 3'b000;
    parameter CMD_START_BIT = 3'b001;
    parameter CMD_DETECTED_BIT = 3'b010;
    parameter CHK_TC_CNTR = 3'b011;
    parameter CHK_PAY_ID = 3'b100;
    parameter CHK_TC_LEN = 3'b101;
    parameter CMD_PARAM_RX = 3'b110;
    reg[2:0] cmd_uart_state;
    reg[5:0] cmd_clk_counts;
    reg cmd_detect_flg;
    reg[7:0] param_reg;
    //reg[15:0] cmd_params;
    reg[4:0] cmd_waddr;
    reg[7:0] num_params;
    reg[7:0] NUM_PARAM_TO_RX;
    reg[7:0] pay_id_seq;
    reg[7:0] xor_op;

    always @(posedge clk) begin

        if(reset == 1)begin
            case (cmd_uart_state)
                CMD_IDLE: begin
                    CMD_BYTE <= cmd_id;
                    cmd_byte <= shifter(CMD_BYTE);
                    cmd_seq <= {1'b0, cmd_byte, 1'b1, 1'b1};
                    pay_id_seq <= {1'b0, PAYLOAD_ID, 1'b0, 1'b1};
                    cmd_state <= 11'b0;
                    cmd_bits_rx <= 8'd0;
                    cmd_sync_flag <= 1'b0;
                    cmd_wclk <= 0;
                    cmd_state <= 11'd0;
                    // cmd_detect_flg <= 1'b0;

                    if(Rx == 1'b0) begin
                        if(cmd_clk_counts >= (clk_per_bit - 1) /2)begin
                            cmd_state <= {cmd_state[9:0], 1'b0};
                            cmd_sync_flag <= 1'b1;
                            cmd_clk_counts <= 0;
                            cmd_uart_state <= CMD_START_BIT;
                        end
                        else begin
                            cmd_clk_counts <= cmd_clk_counts + 1'b1;
                            cmd_uart_state <= CMD_IDLE;
                        end
                        
                    end                   
                end

                CMD_START_BIT: begin
                    if(cmd_clk_counts >= (clk_per_bit - 1)) begin
                            cmd_state <= {cmd_state[9:0], Rx}; 
                            cmd_clk_counts <= 6'd0;
                            cmd_bits_rx <= cmd_bits_rx + 8'b1;
                        if(cmd_bits_rx > 8'd9) begin
                            // uart_state <= RX_DATA_BITS;
                                if(cmd_detect_flg == 1)begin
                                    param_reg <= cmd_state[9:2];
                                    // repeat(3)
                                    //     @(posedge clk);
                                    cmd_wclk <= 1;
                                    cmd_state <= 11'd0;
                                    cmd_waddr <= cmd_waddr + 5'd1;
                                    num_params <= num_params + 8'd1;
                                    if(num_params == 29 - 1)begin
                                        cmd_clk_counts <= 6'd0;
                                        cmd_uart_state <= CMD_PARAM_RX;
                                        num_params <= 8'd0;
                                    end
                                    else begin
                                        cmd_uart_state <= CMD_IDLE;
                                    end
                                end

                                else if(chk_tc_cntr_flg == 1)begin
                                    tc_cntr_curr <= cmd_state[9:2];
                                    param_reg <= cmd_state[9:2];
                                    cmd_wclk <= 1;
                                    cmd_waddr <= cmd_waddr + 8'd1;
                                    //xor_op <= tc_cntr_curr ^ tc_cntr_prev;
                                    //if(xor_op != 8'h00) begin
                                      //  cmd_wclk <= 1;
                                        //cmd_waddr <= cmd_waddr + 8'd1;
                                    //end
                                    cmd_uart_state <= CHK_TC_CNTR;
                                    cmd_clk_counts <= 6'd0;
                                end

                                else if(chk_tc_len_flg == 1) begin
                                    NUM_PARAM_TO_RX <= shifter(cmd_state[9:2]);
                                    param_reg <= cmd_state[9:2];
                                    cmd_wclk <= 1;
                                    cmd_waddr <= cmd_waddr + 8'd1;
                                    cmd_uart_state <= CHK_TC_LEN;
                                    cmd_clk_counts <= 6'd0;
                                end

                                else if(chk_pay_id_flg == 1) begin
                                    pay_id <= shifter(cmd_state[9:2]);
                                    param_reg <= cmd_state[9:2];
                                    cmd_wclk <= 1;
                                    cmd_waddr <= cmd_waddr + 8'd1;
                                    cmd_uart_state <= CHK_PAY_ID;
                                    cmd_clk_counts <= 6'd0;
                                end

                                else begin
                                    if(cmd_state == cmd_seq)begin
                                        chk_tc_cntr_flg <= 1;
                                        cmd_waddr <= 8'd0;
                                        cmd_uart_state <= CMD_IDLE;
                                        cmd_clk_counts <= 6'd0;
                                    end
                                    else begin
                                        cmd_uart_state <= CMD_IDLE;
                                    end
                                end
                            end
                        else begin
                            cmd_uart_state <= CMD_START_BIT;
                        end
                    end

                    else begin
                        cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        cmd_uart_state <= CMD_START_BIT;
                    end
                end

                //CMD_DETECTED_BIT: begin
                  //  if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                    //    cmd_uart_state <= CMD_IDLE;
                    //end
                    //else begin
                      //  cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        //cmd_uart_state <= CMD_DETECTED_BIT;
                    //end
                //end

                CHK_TC_CNTR: begin
                    if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                        cmd_uart_state <= CMD_IDLE;
                    end
                    else begin
                    
                        xor_op <= tc_cntr_curr ^ tc_cntr_prev;
                        
                        if(xor_op != 8'h00) begin
                            chk_tc_len_flg <= 1;
                            tc_cntr_prev <= tc_cntr_curr;
                        end
                        chk_tc_cntr_flg <= 0;
                        cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        cmd_uart_state <= CHK_TC_CNTR;
                    end

                end

                CHK_TC_LEN: begin
                    if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                        cmd_uart_state <= CMD_IDLE;
                    end
                    else begin
                        chk_pay_id_flg <= 1;
                        chk_tc_len_flg <= 0;
                        cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        cmd_uart_state <= CHK_TC_LEN;
                    end
                end

                CHK_PAY_ID: begin
                    if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                        cmd_uart_state <= CMD_IDLE;
                    end
                    else begin
                        if(pay_id == PAYLOAD_ID) begin
                            cmd_detect_flg <= 1;    
                        end
                        chk_pay_id_flg <= 0;
                        cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        cmd_uart_state <= CHK_PAY_ID;
                    end
                end

                CMD_PARAM_RX: begin

                    if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                        cmd_uart_state <= CMD_IDLE;
                        cmd_clk_counts <= 1'b0;
                    end
                    else begin
                        cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        cmd_detect_flg <= 0;
                        cmd_wclk <= 0;
                        cmd_uart_state <= CMD_PARAM_RX;
                    end

                end

                default: begin
                    cmd_uart_state <= CMD_IDLE;
                end
            endcase
        end
        else begin
            cmd_state <= 12'd0;
            cmd_uart_state <= CMD_IDLE;
            cmd_detect_flg <= 0;
            cmd_bits_rx <= 0;
            cmd_clk_counts <= 0;
            cmd_waddr <= 5'd0;
            num_params <= 0;
            NUM_PARAM_TO_RX <= 0;
            param_reg <= 0;
            cmd_wclk <= 0;
            chk_tc_cntr_flg <= 0;
            chk_pay_id_flg <= 0;
            chk_tc_len_flg <= 0;
            tc_cntr_curr <= 0;
            tc_cntr_prev <= 0;
            pay_id <= 0;
            xor_op <= 0;
        end
    
    end

    assign CMD_WADDR = cmd_waddr;
    assign CMD_WCLK = cmd_wclk;
    assign PARAM_Byte = shifter(param_reg);
    assign CMD_Detected = cmd_detect_flg;
    

endmodule