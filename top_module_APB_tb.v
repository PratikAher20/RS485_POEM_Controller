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
wire[7:0] sa;
reg rst;
reg valid;

wire PREADY;
wire [7:0] PRDATA;
wire Tx;
wire Tx_Enable;

RS_485_Controller rc1(.PCLK(PCLK), .PSEL(PSEL), .PENABLE(PENABLE), .PWRITE(PWRITE), .PADDR(PADDR), .PWDATA(PWDATA), .Rx(Rx), .rst_tx(rst), .sa(sa), .PREADY(PREADY), .PRDATA(PRDATA), .Tx(Tx), .Tx_Enable(Tx_Enable));


initial begin   
    $dumpfile("top_module_APB.vcd"); 
    $dumpvars(0, top_module_APB_tb);
    #0 PCLK = 0;
    #0 PWRITE = 0;
    #0 PSEL = 0;
    #0 PENABLE = 0;
    #0 rst = 0;
    #0 PADDR = 0;
    #0 PWDATA = 0;
   // #0 sa = 8'd1;

    #70 PWRITE = 1;
    #0 rst = 1;
    #0 PSEL = 1;
    #0 PADDR = 8'h14;
    #0 PWDATA = 8'h01;
    #10 PENABLE = 1;
    
end

initial begin
    #55 PSEL = 0;
    #0 PENABLE = 0;
end

initial begin
    #65 PADDR = 8'h08;
    #0 PSEL = 1;
    #0 PWRITE = 0;
    #10 PENABLE = 1;
    #10 PENABLE = 0;
end

initial begin
    #70 PWRITE = 1;
    #0 rst = 1;
    #0 PSEL = 1;
    #0 PADDR = 8'h00;
    #0 PWDATA = 16'h3fe0;
    #10 PENABLE = 1;
end

initial begin
    #125 PADDR = 8'h00;
    #0 PWRITE = 1;
    #0 PWDATA = 16'hffe0;
    #0 PSEL = 1;
    #10 PENABLE = 1;
    #20 PENABLE = 0;
    #0 PWRITE = 1;
    #0 PSEL = 0;

end

initial begin
    #225 PADDR = 8'h00;
    #0 PWRITE = 1;
    #0 PWDATA = 16'he0ff;
    #0 PSEL = 1;
    #10 PENABLE = 1;
    #20 PENABLE = 0;
    #0 PWRITE = 1;
    #0 PSEL = 0;

end

initial begin
    #305 PADDR = 8'h00;
    #0 PWRITE = 1;
    #0 PWDATA = 16'he03f;
    #0 PSEL = 1;
    #10 PENABLE = 1;
    #20 PENABLE = 0;
    #0 PWRITE = 1;
    #0 PSEL = 0;

end

initial begin
    #375 PADDR = 8'h00;
    #0 PWRITE = 1;
    #0 PWDATA = 16'hABAB;
    #0 PSEL = 1;
    #10 PENABLE = 1;
    #20 PENABLE = 0;
    #0 PWRITE = 1;
    #0 PSEL = 0;

end

//Rx Waveforms

initial begin
        // $dumpfile("RS485_PSLV_Controller.vcd"); 
        // $dumpvars(0, Rx_Controller_tb);
        // #0 clk = 0;
       
        #0 Rx = 1;
        #120 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 1;        
    end

initial begin
    //     // $dumpfile("RS485_PSLV_Controller.vcd"); 
    //     // $dumpvars(0, top_tb);
        #1600 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 1;
        
    end

// initial begin
//         // $dumpfile("RS485_PSLV_Controller.vcd"); 
//         // $dumpvars(0, top_tb);
//         #610 Rx = 0;
//         #10 Rx = 1;
//         #10 Rx = 0;
//         #10 Rx = 0;
//         #10 Rx = 0;
//         #10 Rx = 0;
//         #10 Rx = 0;
//         #10 Rx = 0;
//         #10 Rx = 0;
//         #10 Rx = 1;
//         #10 Rx = 1;
        
//     end

    initial begin
        #185 valid = 1;
        #240 valid = 0;
    end

    initial begin
        #645 valid = 1;
        #250 valid = 0;
    end


always #5 begin
    PCLK = ~PCLK;    
end

    initial #2900 $finish;

endmodule