#include <kernel.h>
#include <kdata.h>
#include <devsd.h>
#include <printf.h>
#include <vt.h>
#include <tty.h>
#include "devtty.h"
void ps2_activator(void) __naked
{
  __asm
	ld bc,#0xdef7
	ld a,#0xf0
	out (c),a
	ld b,#0xbe
	ld a,#2
	out (c),a
	ld bc,#0xdef7
	ld a,#0xf0
	out (c),a
	ld b,#0xbe
actloop:
	in a,(c)
	or a
	ret z
	jr actloop
  __endasm;
}

__sfr __banked __at 0xF8EF UART_DAT;
__sfr __banked __at 0xF8EF UART_DLL;
__sfr __banked __at 0xF9EF UART_DLM;
__sfr __banked __at 0xFAEF UART_FCR;
__sfr __banked __at 0xFBEF UART_LCR;
__sfr __banked __at 0xFDEF UART_LSR;
__sfr __banked __at 0xDEF7 RTC_REG;
__sfr __banked __at 0xBEF7 RTC_DATA;
#define RTC_READ(_reg) (RTC_REG=(_reg),RTC_DATA)
#define RTC_WRITE(_reg,_dat) RTC_REG=(_reg);RTC_DATA=(_dat)
/*
const unsigned int dm[]={0,31,59,90,120,151,181,212,243,273,304,334};
void rtc_activator(void) 
{
	unsigned char y,m;
	unsigned int dd;
	RTC_WRITE(0x0b,0x06);
	y=RTC_READ(0x09)+30;
	dd=(y>>2)+y*365;
	m=RTC_READ(0x08)-1;
	dd+=dm[m];
	if(((y&3)==0)&&(m>1)) dd++;
	dd+=RTC_READ(0x07)-1;
	tod.low = (((unsigned long int)dd*24+RTC_READ(0x04))*60+RTC_READ(0x02))*60+RTC_READ(0x01);
	//tod.low = dd*86400+RTC_READ(0x04)*60*60+RTC_READ(0x02)*60+RTC_READ(0x01);
	tod.high=0;
}*/

void uart_activator(void)
{
	UART_LCR=0x80;
	UART_DLM=0;
	UART_DLL=1;
	UART_LCR=3;
	UART_FCR=7;
}
void device_init(void)
{
	ps2_activator();
	uart_activator();
	//rtc_activator();
    devsd_init();
	//devide_init();
}

void map_init(void)
{
}


