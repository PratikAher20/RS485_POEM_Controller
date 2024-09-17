`include "RS485_PSLV_Controller.v"

module RS_485_Controller(
input PCLK,
input PSEL,
input PENABLE,
input PWRITE,
input[7:0] PADDR,
input [15:0] PWDATA,
input Rx,
input rst_tx,

output [15:0] data_out,


output[7:0] sa,
output wire full,
output reg PREADY,
output [7:0] PRDATA,
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
reg [9:0] op_rdata = 10'b0000000000;
output reg [9:0] ram_waddr;
output reg [9:0] ram_raddr;
// output reg rd, wr;

// output wire Tx, Tx_Enable;

// input wire Rx;
// reg[15:0] byte_in;

// reg [15:0] data_in;
//  reg[3:0] count;

// inout wire full;


reg [7:0] slave_addr;
wire wr_enable, rd_enable;
assign wr_enable = (PENABLE && PWRITE && PSEL);
assign rd_enable = (PENABLE && !PWRITE && PSEL);


transmitter_with_detector tx_detect(.clk(PCLK), .Rx(Rx), .sa(sa), .rst_tx(rst_tx), .byte_in(data_out), .Tx_complete(Tx_complete), .Tx_Enable(Tx_Enable) , .Tx(Tx), .sequence_detected(seq_detect));
fifo f1(.clk(PCLK), .r_en(rd), .w_en(wr), .rst_n(rst_tx), .data_in(data_in), .data_out(data_out), .empty(empty), .full(full), .count(count));

// integer i;

always @(posedge PCLK) begin
    if(!rst_tx) begin
        wr = 0;
        ram_waddr <= 10'b0000000000;
        ram_raddr <= 10'b0000000000;
        
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
                if(ram_waddr == 10'd1023) begin
                    ram_waddr <= 0;
                    ram_waddr <= ram_waddr + 1'b1;
                end
                else begin
                    ram_waddr <= ram_waddr + 1'b1;
                end
                // fill_data(PWDATA, data_in);
                wr = 1;
                repeat(1)
                    @(posedge PCLK);
                wr = 0;
                PREADY = 0;
            end

            else if(8'h14)begin

                slave_addr <= PWDATA;
                wr = 1;
                repeat(1)
                    @(posedge PCLK);
                wr = 0;
                PREADY = 0;
            end
        end
        else if(rd_enable) begin
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
                op_rdata <= ram_raddr;
                repeat(1)
                    @(posedge PCLK)
                   // Return the number of empty bytes from the queue.
                PREADY = 0;
                
            end
            
            else if(PADDR == 8'h10)
            begin
                op_rdata <= ram_waddr; 
                repeat(1)
                    @(posedge PCLK)
                  // Return the number of empty bytes from the queue.
                PREADY = 0;
            
            end
        end
        else if(Tx_complete) begin
            if(ram_raddr == 10'd1023)begin
                ram_raddr <= 10'b0000000000;
                ram_raddr <= ram_raddr + 1'b1;
            end
            else begin
                ram_raddr <= ram_raddr + 1'b1;
            end
        end
    end
    
end

assign data_in = data_temp_in;
assign PRDATA = op_rdata;


always @ (seq_detect) begin
                                // Send two packets to Transmitter_Detector Module when the Tx_Complete signal is received.
    if(!rst_tx)begin
        rd = 0;
    end
    else begin
        if(seq_detect == 1)begin
        repeat(1)
            @(posedge PCLK);
        rd = 1;
        repeat(1)
            @(posedge PCLK);
        byte_temp_in <= data_out;  //Data out from FIFO going into Tx&Detect.
        // rd = 0;  // Check for the delay;
        repeat(1)
            @(posedge PCLK);
        rd = 0;
        end
    end
      
end

assign byte_in = byte_temp_in;
assign sa = slave_addr;
//always @(posedge Tx_complete) begin
 //       rd = 0;
//end


//always @(negedge PWRITE) begin

    // @(posedge PCLK)
        //wr = 0;
   
//end


endmodule


module fifo (
  input clk, rst_n,
  input w_en, r_en,
  input [15:0] data_in,
  output reg [15:0] data_out,
  output full, empty,
  output wire [3:0] count
);
  
  reg [3:0] w_ptr, r_ptr;
  reg [15:0] fifo[0:511];
  reg [15:0] data_out_temp;
  reg [3:0] count_temp;

  integer i;
  
  // Set Default values on reset.
  always@(posedge clk) begin
    if(!rst_n) begin
      w_ptr <= 0; r_ptr <= 0;
      data_out <= 0;
      count_temp <= 0;
        // for(i = 0; i<512; i = i + 1)begin        Bad Idea
        //     fifo[i] = 16'd0;
        // end
    end

    if(w_en & !full)begin
      fifo[w_ptr] <= data_in;
      w_ptr = w_ptr + 4'd1;
    end

    if(r_en & !empty) begin
      data_out <= fifo[r_ptr];
      r_ptr <= r_ptr + 4'd1;
    end

    if(w_ptr == 4'd15) begin
        w_ptr <= 0;
    end
    
    if(r_ptr == 4'd15)begin
         r_ptr <= 0;
    end

     count_temp <= (w_ptr > r_ptr) ? w_ptr - r_ptr: r_ptr - w_ptr;

  end
  
  // To write data to FIFO
//   always@(posedge clk) begin
//     if(w_en & !full)begin
//       fifo[w_ptr] <= data_in;
//       w_ptr <= w_ptr + 1;
//     end
//   end
  
//   // To read data from FIFO
//   always@(posedge clk) begin
//     if(r_en & !empty) begin
//       data_out_temp <= fifo[r_ptr];
//       r_ptr <= r_ptr + 1;
//     end
//   end
  
//   assign data_out = data_out_temp;
  assign count = count_temp;
  assign full = ((w_ptr+1'b1) == r_ptr);
  assign empty = (w_ptr == r_ptr);

    
endmodule

