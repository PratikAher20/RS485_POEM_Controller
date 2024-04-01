module RS_485_Controller(
input PCLK,
input PSEL,
input PENABLE,
input PWRITE,
input[7:0] PADDR,
input [15:0] PWDATA,
input rst_tx,
input seq_detect,
input Tx_complete,
input REN,
output [15:0] data_out,



output wire [15:0] data_in,
output reg [9:0] ram_waddr,
output reg [9:0] ram_raddr,

output reg PREADY,
output [9:0] PRDATA,
output Tx,

output reg wr, enable,
output SRAM_EMPTY_Detected,
output SRAM_FULL_Detected,
output [7:0] slave_addr,
output [7:0] CMD_ID,
output [5:0] NUM_BYTES,
output [7:0] clks_per_bit,
output RCLK_CMD,
output [7:0] R_ADDR_CMD

);

reg[15:0] data_temp_in = 15'b0;
reg [15:0] byte_temp_in = 15'b0;
reg [9:0] op_rdata = 10'b0000000000;
reg[5:0] clk_counts_raddr;
reg tx_complete_flg;
reg[7:0] sl_addr;
reg[7:0] clkperbit;
reg[7:0] cmd_id;
reg[5:0] num_bytes;
reg rclk_cmd;
reg [7:0] r_addr_cmd;
wire wr_enable, rd_enable;
assign CMD_ID = cmd_id;
assign NUM_BYTES = num_bytes;
assign wr_enable = (PENABLE && PWRITE && PSEL);
assign rd_enable = (PENABLE && !PWRITE && PSEL);
assign SRAM_EMPTY_Detected = ((ram_waddr - ram_raddr - 10'd1 < 10'd1) || (10'd1023 - ram_raddr + ram_waddr - 10'd1 < 10'd1)) ? 1:0 ;
assign SRAM_FULL_Detected = (((ram_raddr - ram_waddr - 10'd1 < 10'd1) && (ram_raddr - ram_waddr >= 0)) || (10'd1023 - ram_waddr + ram_raddr - 10'd1 < 10'd1)) ? 1:0 ;

always @(posedge PCLK) begin
    if(!rst_tx) begin
        wr = 0;
        ram_waddr <= 10'd2;
        ram_raddr <= 10'd0;
        clk_counts_raddr <= 6'd0;
        tx_complete_flg <= 0;
        sl_addr <= 8'd0;
        clkperbit <= 8'd0;
        r_addr_cmd <= 8'd0;
        rclk_cmd <= 1'b0;
    end

    else begin
        if(wr_enable)begin
            PREADY = 1;
            
            if(PADDR == 8'h00)
                begin
                    // for (i = 0; i<16; i++ ) begin
                    //     data_in[i] <= PWDATA[i];
                    // end
                    data_temp_in <= PWDATA;
                    if(ram_waddr == 10'd1023) begin
                        ram_waddr <= 0;
                        ram_waddr <= ram_waddr + 1'b1;
                    end
                    else begin
                        ram_waddr <= ram_waddr + 1'b1;
                    end
                    // fill_data(PWDATA, data_in);
                    wr = 1;
                    repeat(1)
                        @(posedge PCLK);
                    wr = 0;
                    PREADY = 0;
                end
            
            else if(PADDR == 8'h14)
                begin
                    sl_addr <= PWDATA;
                    wr = 1;
                    repeat(1)
                        @(posedge PCLK);
                    wr = 0;
                    PREADY = 0;
                end
                
            else if(PADDR == 8'h18)
                begin
                    clkperbit <= PWDATA;
                    wr = 1;
                    repeat(1)
                        @(posedge PCLK);
                    wr = 0;
                    PREADY = 0;
                end
                
            else if(PADDR == 8'h1C)
                begin
                    cmd_id <= PWDATA;
                    wr = 1;
                    repeat(1)
                        @(posedge PCLK);
                    wr = 0;
                    PREADY = 0;
                end
                
            else if(PADDR == 8'h20)
                begin
                    num_bytes <= PWDATA;
                    wr = 1;
                    repeat(1)
                        @(posedge PCLK);
                    wr = 0;
                    PREADY = 0;
                end
        end
        else if(rd_enable) begin
            PREADY = 1;
            if(PADDR == 8'h08)
            
            begin
                op_rdata <= 16'hAB;
                repeat(1)
                    @(posedge PCLK)
                   // Return the number of empty bytes from the queue.
                PREADY = 0;
                
            end

            else if(PADDR == 8'h0C)

            begin
                op_rdata <= ram_raddr;
                repeat(1)
                    @(posedge PCLK)
                   // Return the number of empty bytes from the queue.
                PREADY = 0;
                
            end
            
            else if(PADDR == 8'h10)
            begin
                op_rdata <= ram_waddr; 
                repeat(1)
                    @(posedge PCLK)
                  // Return the number of empty bytes from the queue.
                PREADY = 0;
            
            end
            
           // else if(PADDR == 8'h24)
            //begin
              //  r_addr_cmd <= r_addr_cmd + 8'd1;
                //rclk_cmd <= 1;
                //op_rdata <= RD_CMD; 
                //repeat(1)
                //@(posedge PCLK)
                   //Return the number of empty bytes from the queue.
                //PREADY = 0;
                //rclk_cmd <= 0;
            
            //end
            
        end
        
        if(Tx_complete) begin
            if(tx_complete_flg == 0) begin
                if(REN == 1) begin
                    if(ram_raddr == 10'd1023)begin
                         ram_raddr <= 10'b0000000000;
                         ram_raddr <= ram_raddr + 1'b1;
                    end
                    else begin
                            ram_raddr <= ram_raddr + 1'b1;
                    end
                end
            end
            tx_complete_flg <= 1;
        end
        if(Tx_complete == 0) begin
            tx_complete_flg <= 0;
        end
        
    end
    
end

assign slave_addr = sl_addr;
assign clks_per_bit = clkperbit;
assign data_in = data_temp_in;
assign PRDATA = op_rdata;
assign R_ADDR_CMD = r_addr_cmd;

//always @(posedge Tx_complete) begin
  //   if(!rst_tx)begin
   // //   ram_raddr <= 10'b0000000000;
    //end
    //else begin
       // if(Tx_complete == 1'b1)begin
           // if(ram_raddr == 10'd1023)begin
             //   ram_raddr <= 0;
             //   ram_raddr <= ram_raddr + 1'b1;
           // end
           // else begin
             //   ram_raddr <= ram_raddr + 1'b1;
          //  end
      //  end
    //end
//end



endmodule