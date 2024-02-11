//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sun Feb 11 12:04:26 2024
// Version: 2023.1 2023.1.0.6
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// Controller_Interface
module Controller_Interface(
    // Inputs
    BIF_1_PADDR,
    BIF_1_PENABLE,
    BIF_1_PSEL,
    BIF_1_PWDATA,
    BIF_1_PWRITE,
    ResetN,
    Rx,
    i_clk,
    // Outputs
    BIF_1_PRDATA,
    BIF_1_PREADY,
    Tx,
    Tx_Enable
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [7:0]  BIF_1_PADDR;
input         BIF_1_PENABLE;
input         BIF_1_PSEL;
input  [15:0] BIF_1_PWDATA;
input         BIF_1_PWRITE;
input         ResetN;
input         Rx;
input         i_clk;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [9:0]  BIF_1_PRDATA;
output        BIF_1_PREADY;
output        Tx;
output        Tx_Enable;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          baud_clk_0_o_clk;
wire   [7:0]  BIF_1_PADDR;
wire          BIF_1_PENABLE;
wire   [9:0]  BIF_1_PRDATA_net_0;
wire          BIF_1_PREADY_net_0;
wire          BIF_1_PSEL;
wire   [15:0] BIF_1_PWDATA;
wire          BIF_1_PWRITE;
wire          i_clk;
wire          ResetN;
wire   [15:0] RS_485_Controller_0_data_in;
wire   [9:0]  RS_485_Controller_0_ram_raddr;
wire   [9:0]  RS_485_Controller_0_ram_waddr;
wire          RS_485_Controller_0_wr;
wire          Rx;
wire          sequence_detector_0_detected;
wire   [15:0] TPSRAM_C0_0_RD;
wire          Tx_net_0;
wire          Tx_Controller_0_Tx_complete;
wire          Tx_Enable_net_0;
wire          Tx_Enable_net_1;
wire          Tx_net_1;
wire   [9:0]  BIF_1_PRDATA_net_1;
wire          BIF_1_PREADY_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          Rx_IN_POST_INV0_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net = 1'b1;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign Rx_IN_POST_INV0_0 = ~ Rx;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign Tx_Enable_net_1    = Tx_Enable_net_0;
assign Tx_Enable          = Tx_Enable_net_1;
assign Tx_net_1           = Tx_net_0;
assign Tx                 = Tx_net_1;
assign BIF_1_PRDATA_net_1 = BIF_1_PRDATA_net_0;
assign BIF_1_PRDATA[9:0]  = BIF_1_PRDATA_net_1;
assign BIF_1_PREADY_net_1 = BIF_1_PREADY_net_0;
assign BIF_1_PREADY       = BIF_1_PREADY_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------baud_clk
baud_clk baud_clk_0(
        // Inputs
        .i_clk ( i_clk ),
        // Outputs
        .o_clk ( baud_clk_0_o_clk ) 
        );

//--------RS_485_Controller
RS_485_Controller RS_485_Controller_0(
        // Inputs
        .PCLK        ( i_clk ),
        .PSEL        ( BIF_1_PSEL ),
        .PENABLE     ( BIF_1_PENABLE ),
        .PWRITE      ( BIF_1_PWRITE ),
        .PADDR       ( BIF_1_PADDR ),
        .PWDATA      ( BIF_1_PWDATA ),
        .rst_tx      ( ResetN ),
        .seq_detect  ( sequence_detector_0_detected ),
        .Tx_complete ( Tx_Controller_0_Tx_complete ),
        // Outputs
        .data_out    (  ),
        .data_in     ( RS_485_Controller_0_data_in ),
        .ram_waddr   ( RS_485_Controller_0_ram_waddr ),
        .ram_raddr   ( RS_485_Controller_0_ram_raddr ),
        .PREADY      ( BIF_1_PREADY_net_0 ),
        .PRDATA      ( BIF_1_PRDATA_net_0 ),
        .Tx          (  ),
        .wr          ( RS_485_Controller_0_wr ),
        .enable      (  ),
        .byte_in     (  ) 
        );

//--------sequence_detector
sequence_detector sequence_detector_0(
        // Inputs
        .clk      ( baud_clk_0_o_clk ),
        .reset    ( ResetN ),
        .Rx       ( Rx_IN_POST_INV0_0 ),
        // Outputs
        .detected ( sequence_detector_0_detected ),
        .state    (  ) 
        );

//--------TPSRAM_C0
TPSRAM_C0 TPSRAM_C0_0(
        // Inputs
        .WEN   ( RS_485_Controller_0_wr ),
        .REN   ( VCC_net ),
        .WCLK  ( i_clk ),
        .RCLK  ( sequence_detector_0_detected ),
        .WD    ( RS_485_Controller_0_data_in ),
        .WADDR ( RS_485_Controller_0_ram_waddr ),
        .RADDR ( RS_485_Controller_0_ram_raddr ),
        // Outputs
        .RD    ( TPSRAM_C0_0_RD ) 
        );

//--------Tx_Controller
Tx_Controller Tx_Controller_0(
        // Inputs
        .clk         ( baud_clk_0_o_clk ),
        .seq_detect  ( sequence_detector_0_detected ),
        .rst         ( ResetN ),
        .data_in     ( TPSRAM_C0_0_RD ),
        // Outputs
        .Tx_Enable   ( Tx_Enable_net_0 ),
        .Tx          ( Tx_net_0 ),
        .Tx_complete ( Tx_Controller_0_Tx_complete ) 
        );


endmodule
