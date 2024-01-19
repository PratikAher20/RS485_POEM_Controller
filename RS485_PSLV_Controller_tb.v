`include "RS485_PSLV_Controller.v"

// module  top_tb;
//     reg clk;
//     reg Rx;
//     wire Tx;
//     wire tx_en_top;
 
//     top t1(clk, Rx, tx_en_top, Tx);

//     initial begin
//         $dumpfile("RS485_PSLV_Controller.vcd"); 
//         $dumpvars(0, top_tb);
//         #0 clk = 0;
//         #0 Rx = 1;
//         #18 Rx = 0;
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

//     initial begin
//         // $dumpfile("RS485_PSLV_Controller.vcd"); 
//         // $dumpvars(0, top_tb);
//         #450 Rx = 0;
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

//     always #5 begin
//          clk = ~clk;
//     end

//     initial #1200 $finish;

// endmodule

// module transmitter_with_detector_tb;

//     reg clk;
//     reg  Rx;
//     reg [7:0] byte_in;
//     wire Tx_Enable;
//     wire data_out;

//     transmitter_with_detector dut(clk, Rx, byte_in, Tx_Enable, data_out);

//     initial begin
//         clk = 0;
//         Rx = 1;

//     end

//     always #5 clk = ~clk;

//     // initial begin
//     //     $dumpfile("transmitter_test.vcd");
//     //     $dumpvars(0, transmitter_with_detector_tb);

//     //     // Apply test sequence to trigger sequence detection and transmission
//     //     #30 byte_in = 8'h55;  // First byte to initiate sequence detection
//     //     #60 byte_in = 8'h01;  // Second byte to complete the sequence
//     //     #70 byte_in = 8'hAA;  // Additional byte to be transmitted
//     //     #120 $finish;
//     // end

//     initial begin
//         $dumpfile("transmitter_test.vcd");
//         $dumpvars(0, transmitter_with_detector_tb);

//         #18 Rx = 0;
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

//     initial begin
//     //     // $dumpfile("RS485_PSLV_Controller.vcd"); 
//     //     // $dumpvars(0, top_tb);
//         #400 Rx = 0;
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


//     initial #1200 $finish;

// endmodule


module Rx_Controller_tb;

    reg clk;
    reg rst;
    reg Rx;
    wire Tx_Enable;
    // reg [7:0] byte_in;
    wire data_out;
    reg[15:0] data = 16'h3fe0;
    // RS485_PSLV_Controller c1(clk, Tx);
// sequence_detector s1(clk, rst, Rx, Tx_Enable);
    transmitter_with_detector dut(clk, Rx, data, Tx_Enable, data_out);

    initial begin
        $dumpfile("RS485_PSLV_Controller.vcd"); 
        $dumpvars(0, Rx_Controller_tb);
        #0 clk = 0;
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
         clk = ~clk;
    end

    initial #1500 $finish;

endmodule


// module Tx_Controller_tb;

//     reg clk;
//     reg Tx_Enable;
//     wire Tx;
//     wire Tx_complete;

//     initial begin
//         $dumpfile("RS485_PSLV_Controller.vcd"); 
//         $dumpvars(0, Tx_Controller_tb);
//         clk = 0; 
//         Tx_Enable = 0;
//         #10 Tx_Enable = 1;
//         #250 Tx_Enable = 0;
//         #10 Tx_Enable = 1;    
//     end

//     Tx_Controller c1(clk, Tx_Enable, Tx, Tx_complete);

//     // initial begin
//         // $dumpfile("RS485_PSLV_Controller.vcd"); 
//         // $dumpvars(0, Tx_Controller_tb);

//     //     #300 tx_en = 1;

//     // end

//     // initial begin
//     //     // $dumpfile("RS485_PSLV_Controller.vcd"); 
//     //     // $dumpvars(0, Tx_Controller_tb);

//     //     #470 tx_en = 1;

//     // end

//     // assign tx_en_wire = tx_en;



//     always #5 begin
//          clk = ~clk;
//     end

//     initial #550 $finish;

// endmodule