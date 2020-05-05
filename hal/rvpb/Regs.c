#include "stdint.h"
#include "Uart.h"
#include "Timer.h"
#include "Interrupt.h"

volatile PL011_t*   Uart    = (PL011_t*)UART_BASE_ADDRESS0;
volatile Timer_t*   Timer   = (Timer_t*)TIMER_CPU_BASE;
volatile GicCput_t* GicCpu  = (GicCput_t*)GIC_CPU_BASE;
volatile GicDist_t* GicDist = (GicDist_t*)GIC_DIST_BASE;