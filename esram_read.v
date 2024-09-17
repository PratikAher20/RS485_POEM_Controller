///////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------
//-- Title      : AHB Master Interface
//-------------------------------------------------------------------------------
//-- File       : eSRAM_eNVM_RW.v
//-- Author     : Corporate Applications Engineering
//-- Company    : Microsemi Corporation
//-- Device     : SmartFusion2
//-- Standard   : Verilog
//-------------------------------------------------------------------------------
//-- Description: This code implementes the eNVM,eSRAM write and read command sequences to AHB master logic. 
//-------------------------------------------------------------------------------
//-- Copyright (c) 2013   Microsemi Corporation
//--                      All rights reserved.
//-------------------------------------------------------------------------------
//-- Revisions  : V1.0
//-------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////// 


//`define ENVM0_BASE 		  32'h60080000
//`define ENVM0_WD 		      ENVM0_BASE+8'h80
//`define ENVM0_STATUS 	      ENVM0_BASE+12'h120
//`define ENVM0_CMD 		  ENVM0_BASE+12h'148
//`define PROG_ADS 		      32'h08000000
//`define VERIFY_ADS 		  32'h10000000
//`define ENVM_CR             32'h4003800C

module eSRAM_eNVM_RW(
// Generic Signals
input      wire         CLK,
input      wire         RESETn,

//Interface to user 
input      wire         start_envm,
input      wire         start_esram,

//Interface to AHB Master logic
input      wire         valid,
input      wire  [31:0] DATAIN,
input      wire         busy,
output     reg          READ,
output     reg          WRITE,
output     wire  [31:0] ADDR,
output     wire  [31:0] DATAOUT,

//Interface to Fabric SRAM
output     reg          ram_wen,
output     reg   [4:0]  ram_waddr,
output     reg  [31:0]  ram_wdata

);

reg [31:0] data,addr_temp;
reg [4:0] data_cnt;
reg start_envm_reg,start_esram_reg,start_envm_reg1,start_esram_reg1,start_envm_reg2,start_esram_reg2,envm_release_reg;
wire envm_select,esram_select;

// eNVM and eSRAM FSM States

reg [4:0] current_state;
parameter [4:0] Idle_ESRAM_ENVM = 5'b00000, ESRAM_0 = 5'b01010,ESRAM_1 =5'b01011,ESRAM_2 = 5'b01100,
Read_0 = 5'b01101,Read_1 = 5'b01110,Read_2 = 5'b01111,ENVM0_RELEASE = 5'b10000;

assign ADDR = addr_temp;
assign DATAOUT = data;

assign envm_select = start_envm_reg2 & ~start_envm_reg1;
assign esram_select = start_esram_reg2 & ~start_esram_reg1;

always@(posedge CLK, negedge RESETn)
begin
	if(RESETn  == 1'b0)
	    begin	     
	   		 start_envm_reg     <= 1'b0;
	   		 start_envm_reg1    <= 1'b0;
	   		 start_envm_reg2    <= 1'b0;

		     start_esram_reg    <= 1'b0;
		     start_esram_reg1   <= 1'b0;
		     start_esram_reg2   <= 1'b0;
		 end
	else
		begin
	   		 start_envm_reg     <= start_envm;
	   		 start_envm_reg1    <= start_envm_reg;
	   		 start_envm_reg2    <= start_envm_reg1;
		     start_esram_reg    <= start_esram;
		     start_esram_reg1   <= start_esram_reg;
		     start_esram_reg2   <= start_esram_reg1;
		end

end

always@(posedge CLK, negedge RESETn )
begin
    if(RESETn  == 1'b0)
        begin	     
	    WRITE               <=  1'b0;	     
	    READ                <=  1'b0;
		data			    <=  32'h00000000;
	    current_state       <=  Idle_ESRAM_ENVM;   
        ram_wen             <= 1'b0;
        ram_waddr           <= 5'b00000;
		envm_release_reg    <= 1'b0;
        data_cnt            <= 5'b00000;  
	    end
    else
        begin
        case (current_state)
            Idle_ESRAM_ENVM : 
                begin
	    		WRITE               <=  1'b0;	     
	     		READ                <=  1'b0;
		 		data			    <=  32'h00000000;    
		 		ram_wen             <= 1'b0;
         		ram_waddr           <= 5'b00000;
                data_cnt            <= 5'b00000;
                if ( esram_select == 1'b1)                                      // selecting eNVM or eSRAM
                    begin
					current_state   <=  ESRAM_0;  
                    end
                else
                    begin
                    current_state   <=  Read_0;   
                    end
                end	

///////////////Read states //////////////////////////////////////////////

			Read_0 :
				begin

						if ( busy  == 1'b0 && valid == 1'b1)
	                 	 	begin
							READ                      <=  1'b1;
							ram_wdata 				  <= DATAIN;
							ram_wen                   <= 1'b0;
							addr_temp				  <=  addr_temp+4;
				            current_state             <=  Read_1;
							end
						else
							begin
							ram_wen                    <= 1'b0;
				            current_state              <=  Read_0;
							end
				end

			Read_1 :
				begin
                if (ram_waddr == 5'b11110)
                    begin
                    READ                      <=  1'b0;
                    current_state             <=  Read_2;
                    end
                 else
                    begin
                    READ                      <=  1'b1;
                    current_state             <=  Read_1;
                    if ( busy  == 1'b0 && valid == 1'b1)
                        begin
                        ram_wdata 				  <= DATAIN;
                        ram_wen                   <= 1'b1;
                        addr_temp				  <=  addr_temp+4;
                        ram_waddr                 <= ram_waddr +1'b1;
                        end
                    end
               
				end
			Read_2 :
				begin
						if ( busy  == 1'b0 && valid == 1'b1)
	                 	 	begin
							ram_wen                   <= 1'b1;
							ram_waddr                 <= ram_waddr +1'b1;
							ram_wdata 				  <= DATAIN;
				            current_state             <=  ENVM0_RELEASE;
							end
						else
							begin
				            current_state              <=  Read_2;
							end
				end

        endcase
    end     
end
endmodule

