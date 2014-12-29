#include <stm32f4xx.h>
 
extern uint32_t uCount;
 
void SysTick_Handler(void) {
	uCount++;
}