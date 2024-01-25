`include "RS485_PSLV_Controller.v"

module RS_485_Controller(
input PCLK,
input  PRESETN,
input PSEL,
input PENABLE,
input PWRITE,
input[7:0] PADDR,
input [15:0] PWDATA,
input Rx,

output [15:0] data_out,



output wire full,
output reg PREADY,
output reg[7:0] PRDATA,
output Tx,
output wire Tx_Enable,
output reg rd, wr, enable,
output wire byte_out,
output wire[15:0] byte_in,
output wire seq_detect
);

// output reg rd, wr, enable;
// output wire byte_out;
// output wire full;
// output wire empty;

// reg rd, wr, enable;
// wire byte_out;
// wire full;
// wire empty;
wire [3:0] count;

reg[15:0] data_temp_in = 15'b0;
wire[15:0] data_in;
// inout wire [3:0] count;
// output reg[15:0] byte_in;  //Byte taken from FIFO and given to Tx&detect
// reg [15:0] data_out; //Data output from FIFO to be given to byte_in

// wire [3:0] count;
// reg[15:0] byte_in;  //Byte taken from FIFO and given to Tx&detect
// reg [15:0] data_out;

initial rd = 0;
reg [15:0] byte_temp_in = 15'b0;
// output reg rd, wr;

// output wire Tx, Tx_Enable;

// input wire Rx;
// reg[15:0] byte_in;

// reg [15:0] data_in;
//  reg[3:0] count;

// inout wire full;



wire wr_enable, rd_enable;
assign wr_enable = (PENABLE && PWRITE && PSEL);
assign rd_enable = (PENABLE && !PWRITE && PSEL);


transmitter_with_detector tx_detect(.clk(PCLK), .Rx(Rx), .byte_in(byte_in), .Tx_complete(Tx_complete), .Tx_Enable(Tx_Enable) , .Tx(Tx), .sequence_detected(seq_detect));
fifo f1(.clk(PCLK), .enable(enable), .rd(rd), .wr(wr), .rst(PRESETN), .data_in(data_in), .data_out(data_out), .empty(empty), .full(full), .count(count));

// integer i;

always@ (wr_enable)
begin

    if(wr_enable == 1) begin
    PREADY = 1;

    if(PRESETN == 0)
    begin
        // data = 8'h00;

    end

    if(PADDR == 8'h00)
    begin
        // for (i = 0; i<16; i++ ) begin
        //     data_in[i] <= PWDATA[i];
        // end
       data_temp_in <= PWDATA;
        // fill_data(PWDATA, data_in);
        wr = 1;
       
        repeat(2)
            @(posedge PCLK);
        wr = 0;

        // Add a delay so that the write completes and then next write can be started.
    end

    if(PADDR == 8'h08)
        enable = PWDATA;   //TO enable the FIFO

    end

end

assign data_in = data_temp_in;

always @ (posedge rd_enable)
begin
   

    if(PADDR == 8'h04)
    begin
        PRDATA = count;   // Return the number of empty bytes from the queue.
    end

    // else if(PADDR == 8'h08) begin   //Tells if the FIFO is empty
    //     PRDATA = empty;
    // end

    else if(PADDR == 8'h0C) begin   // Tells if the FIFO is full
        PRDATA = full;
    end

end

integer i;

always @ (Tx_Enable) begin
                                // Send two packets to Transmitter_Detector Module when the Tx_Complete signal is received.
      if(Tx_Enable == 1)begin
        repeat(1)
            @(posedge PCLK);
        rd = 1;
        repeat(1)
            @(posedge PCLK);
        byte_temp_in <= data_out;  //Data out from FIFO going into Tx&Detect.
        // rd = 0;  // Check for the delay;
        repeat(2)
            @(posedge PCLK);
        rd = 0;
        end
end

assign byte_in = byte_temp_in;

//always @(posedge Tx_complete) begin
 //       rd = 0;
//end


//always @(negedge PWRITE) begin

    // @(posedge PCLK)
        //wr = 0;
   
//end


endmodule



module fifo(clk, enable, rd, wr, rst, data_in, data_out, empty, full, count);

input clk, enable, rst, rd, wr;
input [15:0] data_in;
output reg [15:0] data_out;
output wire empty;
output wire full;

output reg [3:0] count;
initial count = 0;
reg [15:0] FIFO [0:15];     //Can store 16 packets of 2 byte data = Total 32 bytes
reg [3:0] readCount = 0, writeCount = 0;

assign empty = (count == 0) ? 1'b1 : 1'b0;
assign Full = (count == 8) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    // if(enable == 0);
    // else begin
        // if(!rst) begin    // Using Active High Reset as done by APB Bus.
        //     readCount = 0;
        //     writeCount = 0;
        // end
        // else
    if (rd == 1 && count != 0) begin
        data_out <= FIFO[readCount];
        repeat(21)
            @(posedge clk);
        readCount <= readCount + 1;
    end
    else if (wr == 1 && count < 16) begin
        FIFO[writeCount] <= data_in;
        writeCount <= writeCount + 1;
    end
       
        // else;
    // end
   
    if(writeCount == 16)
        writeCount = 0;
    else if(readCount == 16)
        readCount = 0;
    else;

    if(readCount > writeCount) begin
        count = readCount - writeCount;

    end
    else if( writeCount > readCount)
        count = writeCount - readCount;
    else;
   
end

endmodule
