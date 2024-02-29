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

output [15:0] data_out,



output wire [15:0] data_in,
output reg [9:0] ram_waddr,
output reg [9:0] ram_raddr,
output reg PREADY,
output [9:0] PRDATA,
output Tx,

output reg wr, enable,
output wire[15:0] byte_in

);


reg[15:0] data_temp_in = 15'b0;
reg [15:0] byte_temp_in = 15'b0;
reg [9:0] op_rdata = 10'b0000000000;


wire wr_enable, rd_enable;
assign wr_enable = (PENABLE && PWRITE && PSEL);
assign rd_enable = (PENABLE && !PWRITE && PSEL);


always @(posedge PCLK) begin
    if(!rst_tx) begin
        wr = 0;
        ram_waddr <= 10'b0000000000;
        ram_raddr <= 10'b0000000000;
        
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
        end
        else if(rd_enable) begin
            PREADY = 1;
            if(PADDR == 8'h08)
            
            begin
                repeat(1)
                    @(posedge PCLK)
                op_rdata <= 16'hAB;   // Return the number of empty bytes from the queue.
                PREADY = 0;
                
            end

            else if(PADDR == 8'h0C)

            begin
                repeat(1)
                    @(posedge PCLK)
                op_rdata <= ram_raddr;   // Return the number of empty bytes from the queue.
                PREADY = 0;
                
            end
            
            else if(PADDR == 8'h10)
            begin
                repeat(1)
                    @(posedge PCLK)
                op_rdata <= ram_waddr;   // Return the number of empty bytes from the queue.
                PREADY = 0;
            
            end
        end
        else if(Tx_complete) begin
            if(ram_raddr == 10'd1023)begin
                ram_raddr <= 10'b0000000000;
                ram_raddr <= ram_raddr + 1'b1;
            end
            else begin
                ram_raddr <= ram_raddr + 1'b1;
            end
        end
    end
    
end

assign data_in = data_temp_in;
assign PRDATA = op_rdata;

//always @(posedge Tx_complete) begin
  //   if(!rst_tx)begin
    //    ram_raddr <= 10'b0000000000;
    //end
    //else begin
        
     //   if(ram_raddr == 10'd1023)begin
       //     ram_raddr <= 0;
         //   ram_raddr <= ram_raddr + 1'b1;
        //end
        //else begin
          //  ram_raddr <= ram_raddr + 1'b1;
        //end
    //end
//end



endmodule