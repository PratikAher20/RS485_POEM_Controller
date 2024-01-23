`include "top_module_APB.v"

module top_module_APB_tb;

reg PCLK;
reg PRESETN;
reg PSEL;
reg PENABLE;
reg PWRITE;
reg[7:0] PADDR;
reg [15:0] PWDATA;
reg Rx;
reg rst;

wire PREADY;
wire [7:0] PRDATA;
wire Tx;
wire Tx_Enable;

RS_485_Controller rc1(.PCLK(PCLK), .PRESETN(PRESETN), .PSEL(PSEL), .PENABLE(PENABLE), .PWRITE(PWRITE), .PADDR(PADDR), .PWDATA(PWDATA), .Rx(Rx), .PREADY(PREADY), .PRDATA(PRDATA), .Tx(Tx), .Tx_Enable(Tx_Enable));


initial begin   
    $dumpfile("top_module_APB.vcd"); 
    $dumpvars(0, top_module_APB_tb);
    #0 PCLK = 0;
    #0 PWRITE = 0;
    #0 PSEL = 0;
    #0 PENABLE = 0;

    #10 PWRITE = 1;
    #0 PWDATA = 16'h3fe0;
    #0 PSEL = 1;
    #0 PADDR = 8'h00;
    #10 PENABLE = 1;
    
end

initial begin
    #30 PWRITE = 0;
    #0 PSEL = 0;
    #0 PENABLE = 0;
end

initial begin
    #30 PADDR = 8'h04;
    #5 PSEL = 1;
    #0 PWRITE = 0;
    #2 PENABLE = 1;
end

//Rx Waveforms

initial begin
        // $dumpfile("RS485_PSLV_Controller.vcd"); 
        // $dumpvars(0, Rx_Controller_tb);
        // #0 clk = 0;
        #0 rst = 1;
        #0 Rx = 1;
        #10 rst = 0;
        #18 Rx = 0;
        #10 Rx = 1;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 1;
        #10 Rx = 1;        
    end

initial begin
    //     // $dumpfile("RS485_PSLV_Controller.vcd"); 
    //     // $dumpvars(0, top_tb);
        #400 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 1;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 1;
        #10 Rx = 1;
        
    end

initial begin
        // $dumpfile("RS485_PSLV_Controller.vcd"); 
        // $dumpvars(0, top_tb);
        #730 Rx = 0;
        #10 Rx = 1;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 0;
        #10 Rx = 1;
        #10 Rx = 1;
        
    end


always #5 begin
    PCLK = ~PCLK;    
end

    initial #1200 $finish;

endmodule