set_device -family {SmartFusion2} -die {M2S050} -speed {STD}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\hdl\top_module_APB.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\TPSRAM_C0\TPSRAM_C0_0\TPSRAM_C0_TPSRAM_C0_0_TPSRAM.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\TPSRAM_C0\TPSRAM_C0.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\hdl\RS485_PSLV_Controller.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\Controller_Interface\Controller_Interface.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_muxptob3.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3_iaddr_reg.v}
read_verilog -mode system_verilog -lib COREAPB3_LIB {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vlog\core\coreapb3.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\CoreAPB3_C0\CoreAPB3_C0.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\POEM_RS485_Controller_sb\CCC_0\POEM_RS485_Controller_sb_CCC_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\POEM_RS485_Controller_sb\FABOSC_0\POEM_RS485_Controller_sb_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\POEM_RS485_Controller_sb_MSS\POEM_RS485_Controller_sb_MSS.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\POEM_RS485_Controller_sb\POEM_RS485_Controller_sb.v}
read_verilog -mode system_verilog {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\component\work\POEM_RS485_Controller\POEM_RS485_Controller.v}
set_top_level {POEM_RS485_Controller}
map_netlist
check_constraints {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\designer\POEM_RS485_Controller\synthesis.fdc}
