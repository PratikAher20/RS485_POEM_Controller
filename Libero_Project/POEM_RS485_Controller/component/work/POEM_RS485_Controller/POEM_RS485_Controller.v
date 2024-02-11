//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sun Feb 11 12:12:15 2024
// Version: 2023.1 2023.1.0.6
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// POEM_RS485_Controller
module POEM_RS485_Controller(
    // Inputs
    DEVRST_N,
    MMUART_0_RXD,
    Rx,
    // Outputs
    MMUART_0_TXD,
    Tx,
    Tx_Enable
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  DEVRST_N;
input  MMUART_0_RXD;
input  Rx;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output MMUART_0_TXD;
output Tx;
output Tx_Enable;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   DEVRST_N;
wire   MMUART_0_RXD;
wire   MMUART_0_TXD_net_0;
wire   Rx;
wire   Tx_net_0;
wire   Tx_Enable_net_0;
wire   MMUART_0_TXD_net_1;
wire   Tx_Enable_net_1;
wire   Tx_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   VCC_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net = 1'b1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MMUART_0_TXD_net_1 = MMUART_0_TXD_net_0;
assign MMUART_0_TXD       = MMUART_0_TXD_net_1;
assign Tx_Enable_net_1    = Tx_Enable_net_0;
assign Tx_Enable          = Tx_Enable_net_1;
assign Tx_net_1           = Tx_net_0;
assign Tx                 = Tx_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------POEM_RS485_Controller_sb
POEM_RS485_Controller_sb POEM_RS485_Controller_sb_0(
        // Inputs
        .MMUART_0_RXD     ( MMUART_0_RXD ),
        .FAB_RESET_N      ( VCC_net ),
        .DEVRST_N         ( DEVRST_N ),
        .Rx               ( Rx ),
        // Outputs
        .MMUART_0_TXD     ( MMUART_0_TXD_net_0 ),
        .POWER_ON_RESET_N (  ),
        .INIT_DONE        (  ),
        .FAB_CCC_GL0      (  ),
        .FAB_CCC_LOCK     (  ),
        .MSS_READY        (  ),
        .Tx_Enable        ( Tx_Enable_net_0 ),
        .Tx               ( Tx_net_0 ) 
        );


endmodule
