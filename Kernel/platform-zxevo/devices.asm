;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 13:07:20 2016
;--------------------------------------------------------
	.module devices
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _dev_tab
	.globl _validdev
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
_dev_tab::
	.ds 80
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
;devices.c:29: bool validdev(uint16_t dev)
;	---------------------------------
; Function validdev
; ---------------------------------
_validdev::
;devices.c:33: if(dev > ((sizeof(dev_tab)/sizeof(struct devsw)) << 8) + 255)
	ld	a,#0xFF
	ld	iy,#2
	add	iy,sp
	cp	a, 0 (iy)
	ld	a,#0x08
	sbc	a, 1 (iy)
	jr	NC,00102$
;devices.c:34: return false;
	ld	l,#0x00
	ret
00102$:
;devices.c:36: return true;
	ld	l,#0x01
	ret
	.area _CODE
	.area _CONST
	.area _INITIALIZER
__xinit__dev_tab:
	.dw _blkdev_open
	.dw _no_close
	.dw _blkdev_read
	.dw _blkdev_write
	.dw _blkdev_ioctl
	.dw _no_open
	.dw _no_close
	.dw _no_rdwr
	.dw _no_rdwr
	.dw _no_ioctl
	.dw _tty_open
	.dw _tty_close
	.dw _tty_read
	.dw _tty_write
	.dw _vt_ioctl
	.dw _no_open
	.dw _no_close
	.dw _no_rdwr
	.dw _no_rdwr
	.dw _no_ioctl
	.dw _no_open
	.dw _no_close
	.dw _sys_read
	.dw _sys_write
	.dw _sys_ioctl
	.dw _no_open
	.dw _no_close
	.dw _sys_read
	.dw _sys_write
	.dw _sys_ioctl
	.dw _no_open
	.dw _no_close
	.dw _sys_read
	.dw _sys_write
	.dw _sys_ioctl
	.dw _no_open
	.dw _no_close
	.dw _sys_read
	.dw _sys_write
	.dw _sys_ioctl
	.area _CABS (ABS)
