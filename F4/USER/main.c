#include <stm32f4xx.h>
 #include <stdio.h>
#include "MPU6050.h"
#include <math.h>
USART_InitTypeDef USART_InitStructure;
GPIO_InitTypeDef GPIO_InitStructure;
int16_t MPU6050data[7]; 
double accex=0, accey=0, accez=0, gocx=0, gocy=0, gocz=0,n=0;
double Offset[7];
void USART_Configuration(unsigned int BaudRate);
void SendUSART(USART_TypeDef* USARTx,uint16_t ch);
int GetUSART(USART_TypeDef* USARTx);
void send_data(USART_TypeDef* USARTx,unsigned char* ch);
void I2C_Configuration(void);
void Init(void);
void Delay(void);
 void Delay_Systic(uint32_t uMs);
 
 uint32_t uCount;
 
 #ifdef __GNUC__
  /* With GCC/RAISONANCE, small printf (option LD Linker->Libraries->Small printf
     set to 'Yes') calls __io_putchar() */
  #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
  #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
  #define GETCHAR_PROTOTYPE int fgetc(FILE *f) 
#endif /* __GNUC__ */
	
int main(void) {
	uint16_t i,j;
	
	double gocax=0,gocay=0, gocgx=0, gocgy=0, gocgz=0, alpha=0.92;
    Init();
	  USART_Configuration(500000);	

	


		while (1)
		{
			if(uCount>=5000)
			{
			uCount=0;
			MPU6050_GetRawAccelTempGyro(MPU6050data);
			gocax= (double)atan((double)MPU6050data[1]/(double)(sqrt((double)MPU6050data[0]*(double)MPU6050data[0]+(double)MPU6050data[2]*(double)MPU6050data[2])));
			gocay= (double)atan((double)MPU6050data[0]/(double)sqrt((double)MPU6050data[1]*(double)MPU6050data[1]+(double)MPU6050data[2]*(double)MPU6050data[2]));
			//gocax= atan(60/2.4);
			//printf("%d     %d\r", MPU6050data[5], MPU6050data[4]);
				//printf("%f     %f\r", gocgx,gocgy);
			printf("IMU#gx%f#gy%f#ax%f#ay%f\n\r",gocgx, gocgy,gocax,gocay);
			//printf("TTT: %6.f %6.f %6.f %6.f %6.f %6.f\r", Offset[1],Offset[2],Offset[3],Offset[4],Offset[5], Offset[6]);
			//printf("TTT: %f %f %f %f %f %f \r", MPU6050data[1]-accex, MPU6050data[2]-accey, MPU6050data[3]-accez, MPU6050data[4]-gocx, MPU6050data[5]-gocy, MPU6050data[6]-gocz);
			//printf("time: %d\r", uCount);
			gocgx= alpha*(gocgx+(double)MPU6050data[4]/6553) + (1-alpha)*gocax*180/3.14;
			gocgy= alpha*(gocgy+(double)MPU6050data[5]/6553) + (1-alpha)*gocay*180/3.14;
			//gocgx+= (double)MPU6050data[4]/6553;
			//gocgy+= (double)MPU6050data[5]/6553;
			gocgz+= (double)MPU6050data[6]/6553;
			
			}
			
		}
 
    while(1) {
        GPIO_SetBits(GPIOD, GPIO_Pin_12|GPIO_Pin_14);
				GPIO_ResetBits(GPIOD,GPIO_Pin_13|GPIO_Pin_15);
        Delay();
        GPIO_SetBits(GPIOD, GPIO_Pin_13|GPIO_Pin_15);
				GPIO_ResetBits(GPIOD, GPIO_Pin_12|GPIO_Pin_14);
        Delay();
    }
 
    return 0;
}
 
void Init(void) {
    GPIO_InitTypeDef gpioInit;
    //dau tien cho phep xung clock cap toi GPIOD
    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
    //khoi tao GPIOD
    gpioInit.GPIO_Pin=GPIO_Pin_12|GPIO_Pin_13|GPIO_Pin_14|GPIO_Pin_15;
    gpioInit.GPIO_Mode=GPIO_Mode_OUT;
    gpioInit.GPIO_Speed=GPIO_Speed_100MHz;
    gpioInit.GPIO_OType=GPIO_OType_PP;
    gpioInit.GPIO_PuPd=GPIO_PuPd_NOPULL;
    GPIO_Init(GPIOD, &gpioInit);
		I2C_Configuration();  
		MPU6050_Initialize(Offset, 1000);
		//cau hinh systick
	SysTick_Config(SystemCoreClock/1000000);
	//cau hinh 1ms ngat 1 lan
}
 
void I2C_Configuration(void)
{
#ifdef FAST_I2C_MODE
 #define I2C_SPEED 400000
 #define I2C_DUTYCYCLE I2C_DutyCycle_16_9  
#else /* STANDARD_I2C_MODE*/
 #define I2C_SPEED 100000
 #define I2C_DUTYCYCLE I2C_DutyCycle_2
#endif /* FAST_I2C_MODE*/
	
  GPIO_InitTypeDef  GPIO_InitStructure;
  I2C_InitTypeDef   I2C_InitStructure;

  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);
  RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);
	
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_OD;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;  
  GPIO_Init(GPIOB, &GPIO_InitStructure);
	
  GPIO_PinAFConfig(GPIOB,GPIO_PinSource8,GPIO_AF_I2C1);
  GPIO_PinAFConfig(GPIOB,GPIO_PinSource9,GPIO_AF_I2C1);	

  /* I2C De-initialize */
  I2C_DeInit(I2C1);
  I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
  I2C_InitStructure.I2C_DutyCycle = I2C_DUTYCYCLE;
  I2C_InitStructure.I2C_OwnAddress1 = 0;
  I2C_InitStructure.I2C_Ack = I2C_Ack_Enable;
  I2C_InitStructure.I2C_ClockSpeed = I2C_SPEED;
  I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
  I2C_Init(I2C1, &I2C_InitStructure);
 /* I2C ENABLE */
  I2C_Cmd(I2C1, ENABLE); 
  /* Enable Interrupt */

}

void USART_Configuration(unsigned int BaudRate)
{
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE); 
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);
  
  /* Configure USART Tx as alternate function  */
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_Init(GPIOB, &GPIO_InitStructure);

  /* Configure USART Rx as alternate function  */
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7;
  GPIO_Init(GPIOB, &GPIO_InitStructure);
  
  USART_InitStructure.USART_BaudRate = BaudRate;
  USART_InitStructure.USART_WordLength = USART_WordLength_8b;
  USART_InitStructure.USART_StopBits = USART_StopBits_1;
  USART_InitStructure.USART_Parity = USART_Parity_No;
  USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
  USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
  USART_Init(USART1, &USART_InitStructure);
  
  GPIO_PinAFConfig(GPIOB,GPIO_PinSource6,GPIO_AF_USART1); 
  GPIO_PinAFConfig(GPIOB,GPIO_PinSource7,GPIO_AF_USART1); 
  
  USART_Cmd(USART1, ENABLE);  
}

void SendUSART(USART_TypeDef* USARTx,uint16_t ch)
{
  USART_SendData(USARTx, (uint8_t) ch);
  /* Loop until the end of transmission */
  while (USART_GetFlagStatus(USARTx, USART_IT_TXE) == RESET)
  {}
}

PUTCHAR_PROTOTYPE
{
  /* Place your implementation of fputc here */
  /* e.g. write a character to the USART */
  USART_SendData(USART1, (uint8_t) ch);

  /* Loop until the end of transmission */
  while (USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET)
  {}

  return ch;
}

void Delay(void) {
    uint32_t i;
    for(i=0; i<0xffffff; ++i) {
 
    }
}
void Delay_Systic(uint32_t uMs) {
	uCount=uMs;
	while(uCount);
}
