module RS_485_Controller(
input PCLK,
input PSEL,
input PENABLE,
input PWRITE,
input[7:0] PADDR,
input [15:0] PWDATA,
input rst_tx,
input wire full,
input wire empty,
input wire[3:0] count,
input seq_detect,
input Tx_complete,

output [15:0] data_out,



output wire [15:0] data_in,
output reg [7:0] ram_waddr,
output reg [7:0] ram_raddr,
output reg PREADY,
output reg[7:0] PRDATA,
output Tx,

output reg rd, wr, enable,
output wire[15:0] byte_in

);

// output reg rd, wr, enable;
// output wire byte_out;
// output wire full;
// output wire empty;

// reg rd, wr, enable;
// wire byte_out;
// wire full;
// wire empty;

reg[15:0] data_temp_in = 15'b0;
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


//transmitter_with_detector tx_detect(.clk(PCLK), .Rx(Rx), .rst_tx(rst_tx), .byte_in(byte_in), .Tx_complete(Tx_complete), .Tx_Enable(Tx_Enable) , .Tx(Tx), .sequence_detected(seq_detect));
//fifo f1(.clk(PCLK), .r_en(rd), .w_en(wr), .rst_n(rst_tx), .data_in(data_in), .data_out(data_out), .empty(empty), .full(full), .count(count));

// integer i;

always @(posedge PCLK) begin
    if(!rst_tx) begin
        wr = 0;
        ram_waddr <= 7'b0000000;
        
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
            ram_waddr <= ram_waddr + 1'b1;
            // fill_data(PWDATA, data_in);
            wr = 1;
            repeat(1)
                @(posedge PCLK);
            wr = 0;
            PREADY = 0;
        end
    end
    else if(rd_enable) begin
        
        if(PADDR == 8'h08)
        begin
            PREADY = 1;
            repeat(2)
                @(posedge PCLK)
            PRDATA = count;   // Return the number of empty bytes from the queue.
            PREADY = 0;
            
        end

        if(PADDR == 8'h0C)
        begin
            PREADY = 1;
            repeat(2)
                @(posedge PCLK)
            PRDATA = 8'hAB;   // Return the number of empty bytes from the queue.
            PREADY = 0;
            
        end

    end
    end
    
end

assign data_in = data_temp_in;

integer i;

//always @ (seq_detect) begin
                                // Send two packets to Transmitter_Detector Module when the Tx_Complete signal is received.
   // if(!rst_tx)begin
      //  rd = 1;
     //   ram_raddr <= 7'b0000000;
   // end
   // else begin
       // if(seq_detect == 1)begin
        //repeat(1)
          //  @(posedge PCLK);

        //ram_raddr <= ram_raddr + 1'b1;
       // repeat(1)
           // @(posedge PCLK);
        //byte_temp_in <= data_out;  //Data out from FIFO going into Tx&Detect.
        // rd = 0;  // Check for the delay;
        //repeat(1)
          //  @(posedge PCLK);
       // rd = 0;
     //   end
   // end
      
//end

//assign byte_in = byte_temp_in;

always @(posedge Tx_complete) begin
     if(!rst_tx)begin
        rd = 1;
        ram_raddr <= 7'b0000000;
    end
    else begin
        ram_raddr <= ram_raddr + 1'b1;
    end
end


//always @(negedge PWRITE) begin

    // @(posedge PCLK)
        //wr = 0;
   
//end


endmodule



module fifo (
  input clk, rst_n,
  input w_en, r_en,
  input [15:0] data_in,
  output wire [15:0] data_out,
  output full, empty,
  output wire [3:0] count
);
  
  reg [3:0] w_ptr, r_ptr;
  reg [15:0] fifo[0:15];
  reg [15:0] data_out_temp;
  
  // Set Default values on reset.
  always@(posedge clk) begin
    if(!rst_n) begin
      w_ptr <= 0; r_ptr <= 0;
      data_out_temp <= 0;
    end

    if(w_en & !full)begin
      fifo[w_ptr] <= data_in;
      w_ptr <= w_ptr + 1;
    end

    if(r_en & !empty) begin
      data_out_temp <= fifo[r_ptr];
      r_ptr <= r_ptr + 1;
    end

    if(w_ptr == 4'd15)
        w_ptr <= 0;

    if(r_ptr == 4'd15)
        r_ptr <= 0;

  end

  
  assign data_out = data_out_temp;
  assign count = (w_ptr > r_ptr) ? w_ptr - r_ptr: r_ptr - w_ptr;
  assign full = ((w_ptr+1'b1) == r_ptr);
  assign empty = (w_ptr == r_ptr);
endmodule