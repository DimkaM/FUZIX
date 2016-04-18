;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Sun Apr 17 23:22:42 2016
;--------------------------------------------------------
	.module discard
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _uart_activator
	.globl _ps2_activator
	.globl _devsd_init
	.globl _device_init
	.globl _map_init
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_UART_DAT	=	0xf8ef
_UART_DLL	=	0xf8ef
_UART_DLM	=	0xf9ef
_UART_FCR	=	0xfaef
_UART_LCR	=	0xfbef
_UART_LSR	=	0xfdef
_RTC_REG	=	0xdef7
_RTC_DATA	=	0xbef7
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _DISCARD
;discard.c:10: void ps2_activator(void) __naked
;	---------------------------------
; Function ps2_activator
; ---------------------------------
_ps2_activator::
;discard.c:28: __endasm;
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
;discard.c:59: void uart_activator(void)
;	---------------------------------
; Function uart_activator
; ---------------------------------
_uart_activator::
;discard.c:61: UART_LCR=0x80;
	ld	a,#0x80
	ld	bc,#_UART_LCR
	out	(c),a
;discard.c:62: UART_DLM=0;
	ld	a,#0x00
	ld	bc,#_UART_DLM
	out	(c),a
;discard.c:63: UART_DLL=1;
	ld	a,#0x01
	ld	bc,#_UART_DLL
	out	(c),a
;discard.c:64: UART_LCR=3;
	ld	a,#0x03
	ld	bc,#_UART_LCR
	out	(c),a
;discard.c:65: UART_FCR=7;
	ld	a,#0x07
	ld	bc,#_UART_FCR
	out	(c),a
	ret
;discard.c:67: void device_init(void)
;	---------------------------------
; Function device_init
; ---------------------------------
_device_init::
;discard.c:69: ps2_activator();
	call	_ps2_activator
;discard.c:70: uart_activator();
	call	_uart_activator
;discard.c:72: devsd_init();
	jp  _devsd_init
;discard.c:76: void map_init(void)
;	---------------------------------
; Function map_init
; ---------------------------------
_map_init::
;discard.c:78: }
	ret
	.area _CODE
	.area _DISCARD
	.area _INITIALIZER
	.area _CABS (ABS)
