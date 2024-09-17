`include "CMD_Detector.v"
`include "GPS_Time_State_Vector.v"

module CMD_Detector_tb;

    reg clk;
    reg reset;
    reg Rx;
    reg[7:0] Cmd_id;
    wire CMD_Detected;
    wire[7:0] PARAM_Byte;
    wire[7:0] cmd_waddr;
    wire CMD_WCLK;
    wire[15:0] cmd_params;

CMD_Detector cd1(clk, reset, Rx, Cmd_id, CMD_Detected, CMD_WCLK, PARAM_Byte, cmd_waddr, cmd_params);
//     GPS_Time_State_Vector tv1(
//      clk,
//      reset,
//      Rx,
//      CMD_WCLK,
//      PARAM_Byte,
//      cmd_waddr
// );


    initial begin
        $dumpfile("CMD_Detector.vcd"); 
        $dumpvars(0, CMD_Detector_tb);
        #0 clk = 0;
            reset = 0;
            Rx = 1;
            Cmd_id = 8'hFC;
    end

    //First Command
    initial begin   //0xFC
        #30 reset = 1;
        #7 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        
    end

    initial begin   //TC No.
        #490 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 0;
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

    initial begin   //TC Length
        #970 Rx = 0;
        #40 Rx = 0;
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

    initial begin   //Pay_ID
        #1450 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 1;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 0;
        #40 Rx = 1;
        #40 Rx = 1;
    end

    genvar  i;
    for (i = 1; i<= 29 ; i = i + 1) begin
        initial begin
            #(1930+ (480*(i-1))) Rx = 0;
            #40 Rx = i[0];
            #40 Rx = i[1];
            #40 Rx = i[2];
            #40 Rx = i[3];
            #40 Rx = i[4];
            #40 Rx = i[5];
            #40 Rx = i[6];
            #40 Rx = i[7];
            #40 Rx = 0;
            #40 Rx = 1;
            #40 Rx = 1;
            // $display ("%d", i);
        end
    end

    // initial begin   //Command ID
    //     #1930 Rx = 0;
    //     #40 Rx = 1;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 1;
    //     #40 Rx = 1;
    // end

    // initial begin   //CMD Parameter
    //     #2410 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 1;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 1;
    //     #40 Rx = 1;
        
    // end

    // initial begin
    //     #2890 Rx = 0;
    //     #40 Rx = 1;
    //     #40 Rx = 1;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 0;
    //     #40 Rx = 1;
    //     #40 Rx = 1;

    // end

//Second Command
// initial begin   //0xFC
//         #3370 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #3863 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #4343 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #4823 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #5303 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #5783 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #6263 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

// // Third Command

//     initial begin   //0xFC
//         #6980 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #7470 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #7960 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #8450 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #8940 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #9430 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #9920 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     //Fourth Command

//     initial begin   //0xFC
//         #10410 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #10900 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #11390 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #11880 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #12370 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #12860 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #13350 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     //Fifth Command

//     initial begin   //0xFC
//         #13840 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #14330 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #14820 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #15310 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #15800 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #16290 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #16780 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     //Sixth Command

//     initial begin   //0xFC
//         #17270 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #17760 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #18250 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #18740 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #19230 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #19720 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #20210 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

// //Seventh Command

// initial begin   //0xFC
//         #20700 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #21190 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #21680 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #22170 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #22660 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #23150 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #23640 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

// //Eight Command
// initial begin   //0xFC
//         #24130 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #24620 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #25110 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #25600 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #26090 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #26580 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #27070 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

// // Ninth Command
// initial begin   //0xFC
//         #27560 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin   //TC No.
//         #28050 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end

//     initial begin   //TC Length
//         #28540 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Pay_ID
//         #29030 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //Command ID
//         #29520 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//     end

//     initial begin   //CMD Parameter
//         #30010 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
        
//     end

//     initial begin
//         #30500 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 0;
//         #40 Rx = 1;
//         #40 Rx = 1;

//     end




    always #5 begin
        clk = ~clk;
    end

    initial #17000 $finish;


endmodule