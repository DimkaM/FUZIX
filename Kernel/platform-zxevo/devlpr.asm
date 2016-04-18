;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Sun Apr 17 23:22:36 2016
;--------------------------------------------------------
	.module devlpr
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _lpr_open
	.globl _lpr_close
	.globl _lpr_write
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
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
	.area _CODE2
;devlpr.c:7: int lpr_open(uint8_t minor, uint16_t flag)
;	---------------------------------
; Function lpr_open
; ---------------------------------
_lpr_open::
;devlpr.c:11: return 0;
	ld	hl,#0x0000
	ret
;devlpr.c:14: int lpr_close(uint8_t minor)
;	---------------------------------
; Function lpr_close
; ---------------------------------
_lpr_close::
;devlpr.c:17: return 0;
	ld	hl,#0x0000
	ret
;devlpr.c:20: int lpr_write(uint8_t minor, uint8_t rawflag, uint8_t flag)
;	---------------------------------
; Function lpr_write
; ---------------------------------
_lpr_write::
;devlpr.c:26: return udata.u_count;
	ld	hl, (#(_udata + 0x0062) + 0)
	ret
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
