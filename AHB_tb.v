`include "AHB_Bus.v"

module AHB_tb;

reg HCLK, HRESETn, READ, HREADY;
reg [15:0] HRDATA;
reg [1:0] HRESP;

wire [15:0] DATAOUT;
wire [31:0] HADDR;
wire [1:0] HTRANS;
wire HWRITE, AHB_BUSY, VALID;
wire  [2:0]  HSIZE;
wire  [2:0]  HBURST;
wire  [3:0]  HPROT;
wire   [31:0] HWDATA;
wire [1:0]  RESP_err;



AHB_BUS bus1( 
HCLK,
HRESETn,
READ,
DATAOUT,
HADDR,
HTRANS,
HWRITE,
HSIZE,
HBURST,
HPROT,
HWDATA,
HRDATA,
HREADY,
HRESP,
RESP_err,
AHB_BUSY,
VALID
);


initial begin
        $dumpfile("AHB_Bus.vcd"); 
        $dumpvars(0, AHB_tb);

        #0 HCLK = 0;
        HRESETn = 0;
        READ = 0;
        HRDATA = 0;
        HREADY = 1;
        HRESP = 0;
        #3 HRESETn = 1;
end

initial begin
        
        #0 READ = 1;

        #15 HREADY = 0;
        #40 HREADY = 1;
end

initial begin
    #55 HRDATA = 16'hABCD;
end

always #5 begin
    HCLK = ~HCLK;    
end


initial #100 $finish;


endmodule