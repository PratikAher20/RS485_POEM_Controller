module APB_Read_TLM(
input PCLK,
input PSEL,
input PENABLE,
input PWRITE,
input[7:0] PADDR,
input [15:0] PWDATA,
input [7:0] RD_TLM,
input rst_tx,

output reg PREADY,
output [7:0] PRDATA,
output RCLK_TLM,
output [4:0] R_ADDR_TLM
);

reg rclk_tlm;
reg [4:0] r_addr_tlm;
reg [7:0] op_rdata;
assign RCLK_TLM = rclk_tlm;
assign R_ADDR_TLM = r_addr_tlm;
wire rd_enable;
assign rd_enable = (PENABLE && !PWRITE && PSEL);
assign PRDATA = op_rdata;

always @(posedge PCLK) begin
    if(!rst_tx) begin
        r_addr_tlm <= 5'd1;
        rclk_tlm <= 1'd0;

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
                rclk_tlm <= 1'd1;
                op_rdata <= RD_TLM;
                repeat(1)
                    @(posedge PCLK)
                   // Return the number of empty bytes from the queue.
                PREADY = 0;
                rclk_tlm <= 0;
                r_addr_tlm <= r_addr_tlm + 5'd1;
                
            end
            
            
        end

    end
end


endmodule