/*
 * RS485_controller.c
 *
 *  Created on: 11-Feb-2024
 *      Author: Pratik A.
 */

#include "RS485_Controller.h"

uint16_t init_RS485_Controller(){
	MSS_GPIO_init();
	MSS_GPIO_config(MSS_GPIO_0, MSS_GPIO_OUTPUT_MODE);
	MSS_GPIO_set_output(MSS_GPIO_0, 1);
	uint16_t buf[1];
	uint16_t waddr, i;
	buf[0] = 0;
	i = 0;

	for(;i<1024;i++){

		HAL_set_16bit_reg(RS_485_Controller_0, WRITE_SRAM, (uint_fast16_t) buf[0]);
	}

	waddr = HAL_get_16bit_reg(RS_485_Controller_0, READ_WADDR);

	return waddr;
}

uint16_t write_to_sram(uint16_t* data, uint16_t data_size){

	uint16_t i = 0, waddr;

	for(;i<data_size;i++){

		HAL_set_16bit_reg(RS_485_Controller_0, WRITE_SRAM, (uint_fast16_t) data[i]);

	}

	waddr = HAL_get_16bit_reg(RS_485_Controller_0, READ_WADDR);

	return waddr;
}

uint16_t read_raddr(){

	uint16_t raddr;

	raddr = HAL_get_16bit_reg(RS_485_Controller_0, READ_RADDR);

	return raddr;
}


int main( void )
{

	uint16_t data[256];
	uint16_t i = 0;

	for(;i<256;i++){
		data[i] = i;
	}

	uint16_t waddr, raddr;

	waddr = init_RS485_Controller();


		while(1){

			waddr = write_to_sram(data, sizeof(data)/2);

			raddr = read_raddr();
		}

	return 0;
}
