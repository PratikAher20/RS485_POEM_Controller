new_project \
         -name {POEM_RS485_Controller} \
         -location {C:\Users\S-SPACE\Desktop\Pratik\Libero\POEM_RS485_Controller\designer\POEM_RS485_Controller\POEM_RS485_Controller_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S050} \
         -name {M2S050}
enable_device \
         -name {M2S050} \
         -enable {TRUE}
save_project
close_project
