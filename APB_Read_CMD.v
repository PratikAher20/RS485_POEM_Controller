module APB_Read_CMD(
input PCLK,
input PSEL,
input PENABLE,
input PWRITE,
input[7:0] PADDR,
input [15:0] PWDATA,
input [7:0] RD_CMD,
input rst_tx,

output reg PREADY,
output [7:0] PRDATA,
output RCLK_CMD,
output [7:0] R_ADDR_CMD
);

reg rclk_cmd;
reg [7:0] r_addr_cmd;
reg [7:0] op_rdata;
assign RCLK_CMD = rclk_cmd;
assign R_ADDR_CMD = r_addr_cmd;

assign rd_enable = (PENABLE && !PWRITE && PSEL);
assign PRDATA = op_rdata;

always @(posedge PCLK) begin
    if(!rst_tx) begin
        r_addr_cmd <= 8'd1;
        rclk_cmd <= 1'd0;

    end

    else begin

        if(rd_enable) begin
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
                rclk_cmd <= 1'd1;
                op_rdata <= RD_CMD;
                repeat(1)
                    @(posedge PCLK)
                   // Return the number of empty bytes from the queue.
                PREADY = 0;
                rclk_cmd <= 0;
                r_addr_cmd <= r_addr_cmd + 8'd1;
                
            end
            
            
        end

    end
end


endmodule