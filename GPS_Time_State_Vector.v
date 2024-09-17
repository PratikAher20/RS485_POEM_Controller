module GPS_Time_State_Vector (
    input clk,
    input reset,
    input Rx,
    input [7:0] clk_per_bit,
    output TLM_WCLK,
    output[7:0] PARAM_Byte,
    output[4:0] TLM_WADDR
);


    reg cmd_detect;
    reg cmd_sync_flag =0;
    reg cmd_wclk;

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
    reg[10:0] cmd_seq;
    reg [10:0] cmd_state = 0;  // State register to store the current sequence
    reg [7:0] cmd_bits_rx;

    parameter cmd_id = 8'hFE;
    parameter CMD_IDLE = 3'b000;
    parameter CMD_START_BIT = 3'b001;
    parameter CMD_DETECTED_BIT = 3'b010;
    parameter CMD_PARAM_RX = 3'b011;
    parameter NUM_PARAM_TO_RX = 6'd32;
    reg[2:0] cmd_uart_state;
    reg[5:0] cmd_clk_counts;
    reg cmd_detect_flg;
    reg[7:0] param_reg;
    reg[4:0] cmd_waddr;
    reg[5:0] num_params;

    always @(posedge clk) begin

        if(reset == 1)begin
            case (cmd_uart_state)
                CMD_IDLE: begin
                    CMD_BYTE <= cmd_id;
                    cmd_byte <= shifter(CMD_BYTE);
                    cmd_seq <= {1'b0, cmd_byte, 1'b1, 1'b1};
                    cmd_detect <= 1'b0;
                    cmd_state <= 12'b0;
                    cmd_bits_rx <= 8'd0;
                    cmd_sync_flag <= 1'b0;
                    cmd_wclk <= 0;
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
                                    //repeat(5)
                                    //   @(posedge clk);
                                    cmd_wclk <= 1;
                                    //repeat(5)
                                    //   @(posedge clk);
                                    cmd_state <= 11'd0;
                                    cmd_clk_counts <= 6'd0;
                                    cmd_waddr <= cmd_waddr + 5'd1;
                                    num_params <= num_params + 6'd1;
                                    if(num_params == NUM_PARAM_TO_RX - 1)begin
                                        cmd_clk_counts <= 6'd0;
                                        num_params <= 6'd0;
                                        cmd_uart_state <= CMD_PARAM_RX;
                                    end
                                    else begin  
                                        cmd_uart_state <= CMD_IDLE;
                                    end
                                end
                                else begin
                                    if(cmd_state == cmd_seq)begin
                                        cmd_detect <= 1'b1;
                                        cmd_detect_flg <= 1'b1;
                                        cmd_waddr <= 5'd0;
                                        cmd_uart_state <= CMD_DETECTED_BIT;
                                        cmd_clk_counts <= 6'd0;
                                    end
                                    else begin
                                        cmd_detect <= 1'b0;
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

                CMD_DETECTED_BIT: begin
                    if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                        cmd_uart_state <= CMD_IDLE;
                    end
                    else begin
                        cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        cmd_uart_state <= CMD_DETECTED_BIT;
                    end
                end

                CMD_PARAM_RX: begin

                    //if(cmd_clk_counts >= (clk_per_bit - 1) )begin
                    cmd_detect_flg <= 0;
                    cmd_wclk <= 0;
                    cmd_clk_counts <= 1'b0;
                    
                        repeat(5)
                            @(posedge clk);
                        
                        cmd_uart_state <= CMD_IDLE;
                        
                    //end
                    //else begin
                        //cmd_clk_counts <= cmd_clk_counts + 1'b1;
                        
                        //cmd_uart_state <= CMD_PARAM_RX;
                    //end

                end

                default: begin
                    cmd_detect <= 1'b0;
                    cmd_uart_state <= CMD_IDLE;
                end
            endcase
        end
        else begin
            cmd_uart_state <= CMD_IDLE;
            cmd_detect <= 0;
            cmd_detect_flg <= 0;
            cmd_bits_rx <= 0;
            cmd_clk_counts <= 0;
            cmd_waddr <= 5'd0;
            num_params <= 0;
            param_reg <= 0;
            cmd_wclk <= 0;
        end
    
    end

    assign TLM_WADDR = cmd_waddr;
    assign TLM_WCLK = cmd_wclk;
    assign PARAM_Byte = shifter(param_reg);
    // assign CMD_Detected = cmd_detect;
    

endmodule