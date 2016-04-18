;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 17:11:27 2016
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _do_beep
	.globl _kbd_interrupt
	.globl _pagemap_add
	.globl _timer_interrupt
	.globl _msxmaps
	.globl _platform_idle
	.globl _pagemap_init
	.globl _platform_interrupt
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_msxmaps::
	.ds 2
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
	.area _CODE2
;main.c:9: void platform_idle(void)
;	---------------------------------
; Function platform_idle
; ---------------------------------
_platform_idle::
;main.c:13: __endasm;
	halt
	ret
;main.c:16: void do_beep(void)
;	---------------------------------
; Function do_beep
; ---------------------------------
_do_beep::
;main.c:18: }
	ret
;main.c:25: void pagemap_init(void)
;	---------------------------------
; Function pagemap_init
; ---------------------------------
_pagemap_init::
;main.c:29: for (i = 4; i < MAX_MAPS ; i++)
	ld	h,#0x04
00102$:
;main.c:30: pagemap_add(i);
	push	hl
	push	hl
	inc	sp
	call	_pagemap_add
	inc	sp
	pop	hl
;main.c:29: for (i = 4; i < MAX_MAPS ; i++)
	inc	h
	ld	a,h
	sub	a, #0xF8
	jr	C,00102$
;main.c:36: pagemap_add(3);
	ld	a,#0x03
	push	af
	inc	sp
	call	_pagemap_add
	inc	sp
	ret
;main.c:39: void platform_interrupt(void)
;	---------------------------------
; Function platform_interrupt
; ---------------------------------
_platform_interrupt::
;main.c:41: kbd_interrupt();
	call	_kbd_interrupt
;main.c:42: timer_interrupt();
	jp  _timer_interrupt
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
