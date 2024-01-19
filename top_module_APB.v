
`include "RS485_PSLV_Controller.v"


// module RS_485_Controller(PCLK, PRESERN, PSEL, PENABLE, PREADY, PSLVERR, PWRITE, PADDR, PWDATA, PRDATA);
// input PCLK;
// input PRESERN;
// input PENABLE, PSEL, PWRITE;
// input[7:0] PADDR;
// input wire [7:0] PWDATA;
// output wire[7:0] PRDATA;
// output reg PREADY

// output f_tx_full;

// wire wr_enable, rd_enable;
// assign wr_enable = (PENABLE && PWRITE && PSEL);
// assign rd_enable = (PENABLE && !PWRITE && PSEL);

// reg [15:0] data;


// always@ (posedge wr_enable)
// begin

//     PREADY = 1;

//     if(PRESETN == 0)
//     begin
//         data = 8'h00;
//         f_tx_full = 8'h00;
//     end

//     if(PADDR == 8'h00)
//     begin
//         data = PWDATA
//     end

// end

// // always @(posedge rd_enable) begin
// //     PREADY = 1;

// //     if(PADDR == 8'h04)
// //     begin
        
// //     end

    
// // end


// endmodule