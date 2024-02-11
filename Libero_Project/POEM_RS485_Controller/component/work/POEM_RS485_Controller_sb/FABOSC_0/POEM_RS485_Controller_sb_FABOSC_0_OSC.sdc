set_component POEM_RS485_Controller_sb_FABOSC_0_OSC
# Microsemi Corp.
# Date: 2024-Feb-11 12:12:02
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]
