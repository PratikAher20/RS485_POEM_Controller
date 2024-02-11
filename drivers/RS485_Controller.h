/*
 * RS485_Controller.h
 *
 *  Created on: 11-Feb-2024
 *      Author: S-SPACE
 */

#ifndef RS485_CONTROLLER_H_
#define RS485_CONTROLLER_H_


#define RS_485_Controller_0 0x50000000u

#define READ_WADDR_REG_OFFSET 0x08u
#define READ_RADDR_REG_OFFSET 0x0Cu
#define WRITE_SRAM_REG_OFFSET	0x00u

#include "mss_gpio.h"
#include "hal.h"

uint16_t init_RS485_Controller();

uint16_t write_to_sram(uint16_t* data, uint16_t data_size);

uint16_t read_raddr();

#endif /* RS485_CONTROLLER_H_ */
