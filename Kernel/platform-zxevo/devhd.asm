;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Sun Apr 17 23:22:36 2016
;--------------------------------------------------------
	.module devhd
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hd_open
	.globl _hd_read
	.globl _hd_write
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
;devhd.c:11: static int hd_transfer(bool is_read, uint8_t rawflag)
;	---------------------------------
; Function hd_transfer
; ---------------------------------
_hd_transfer:
	call	___sdcc_enter_ix
;devhd.c:23: if(rawflag) {
	ld	a,5 (ix)
	or	a, a
	jr	Z,00104$
;devhd.c:24: dlen = udata.u_count;
	ld	de, (#_udata + 98)
;devhd.c:25: dptr = (uint16_t)udata.u_base;
	ld	hl, (#_udata + 96)
;devhd.c:26: if (((uint16_t)dptr | dlen) & BLKMASK) {
	ld	b,e
	ld	c,d
	ld	a,l
	or	a, b
	ld	l,a
	ld	a,h
	or	a, c
	ld	h,a
	ld	a,l
	or	a, a
	jr	NZ,00128$
	bit	0, h
	jr	Z,00102$
00128$:
;devhd.c:27: udata.u_error = EIO;
	ld	hl,#0x0005
	ld	((_udata + 0x000c)), hl
;devhd.c:28: return -1;
	ld	hl,#0xFFFF
	jr	00109$
00102$:
;devhd.c:31: block_xfer = dlen >> 9;
	ld	a,d
	sra	a
	ld	e,a
	rlc	a
	sbc	a, a
	ld	d,a
;devhd.c:32: map = 1;
	jr	00114$
00104$:
;devhd.c:37: block_xfer = 1;
	ld	de,#0x0001
;devhd.c:41: while (ct < block_xfer) {
00114$:
	ld	hl,#0x0000
00106$:
	ld	a,l
	sub	a, e
	ld	a,h
	sbc	a, d
	jp	PO, 00129$
	xor	a, #0x80
00129$:
	jp	P,00108$
;devhd.c:44: ct++;
	inc	hl
	jr	00106$
00108$:
;devhd.c:46: return ct;
00109$:
	pop	ix
	ret
;devhd.c:49: int hd_open(uint8_t minor, uint16_t flag)
;	---------------------------------
; Function hd_open
; ---------------------------------
_hd_open::
;devhd.c:52: if(minor != 0) {
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z,00102$
;devhd.c:53: udata.u_error = ENODEV;
	ld	hl,#0x0013
	ld	((_udata + 0x000c)), hl
;devhd.c:54: return -1;
	ld	hl,#0xFFFF
	ret
00102$:
;devhd.c:56: return 0;
	ld	hl,#0x0000
	ret
;devhd.c:59: int hd_read(uint8_t minor, uint8_t rawflag, uint8_t flag)
;	---------------------------------
; Function hd_read
; ---------------------------------
_hd_read::
;devhd.c:62: return hd_transfer(true, rawflag);
	ld	hl, #3+0
	add	hl, sp
	ld	d, (hl)
	ld	e,#0x01
	push	de
	call	_hd_transfer
	pop	af
	ret
;devhd.c:65: int hd_write(uint8_t minor, uint8_t rawflag, uint8_t flag)
;	---------------------------------
; Function hd_write
; ---------------------------------
_hd_write::
;devhd.c:68: return hd_transfer(false, rawflag);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_hd_transfer
	pop	af
	ret
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
