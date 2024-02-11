# Written by Synplify Pro version map202209actsp2, Build 067R. Synopsys Run ID: sid1707633772 
# Top Level Design Parameters 

# Clocks 
create_clock -period 10.000 -waveform {0.000 5.000} -name {POEM_RS485_Controller_sb_CCC_0_FCCC|GL0_net_inferred_clock} [get_pins {POEM_RS485_Controller_sb_0/CCC_0/CCC_INST/GL0}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {baud_clk|o_clock_inferred_clock} [get_pins {POEM_RS485_Controller_sb_0/Controller_Interface_0/baud_clk_0/o_clock/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {sequence_detector|detect_inferred_clock} [get_pins {POEM_RS485_Controller_sb_0/Controller_Interface_0/sequence_detector_0/detect/Q}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {Tx_Controller|Tx_complete_inferred_clock} [get_pins {POEM_RS485_Controller_sb_0/Controller_Interface_0/Tx_Controller_0/Tx_complete/Q}] 

# Virtual Clocks 

# Generated Clocks 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 

# Output Load Constraints 

# Driving Cell Constraints 

# Input Delay Constraints 

# Output Delay Constraints 

# Wire Loads 

# Other Constraints 

# syn_hier Attributes 

# set_case Attributes 

# Clock Delay Constraints 
set Inferred_clkgroup_0 [list POEM_RS485_Controller_sb_CCC_0_FCCC|GL0_net_inferred_clock]
set Inferred_clkgroup_2 [list baud_clk|o_clock_inferred_clock]
set Inferred_clkgroup_3 [list sequence_detector|detect_inferred_clock]
set Inferred_clkgroup_4 [list Tx_Controller|Tx_complete_inferred_clock]
set_clock_groups -asynchronous -group $Inferred_clkgroup_0
set_clock_groups -asynchronous -group $Inferred_clkgroup_2
set_clock_groups -asynchronous -group $Inferred_clkgroup_3
set_clock_groups -asynchronous -group $Inferred_clkgroup_4

set_clock_groups -asynchronous -group [get_clocks {POEM_RS485_Controller_sb_CCC_0_FCCC|GL0_net_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {POEM_RS485_Controller_sb_FABOSC_0_OSC|RCOSC_25_50MHZ_CCC_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {baud_clk|o_clock_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {sequence_detector|detect_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {Tx_Controller|Tx_complete_inferred_clock}]

# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 

