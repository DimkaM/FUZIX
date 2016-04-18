;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 13:07:00 2016
;--------------------------------------------------------
	.module evosd
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _devsd_transfer_sector1
	.globl _sd_spi_transmit_sector
	.globl _sd_spi_receive_sector
	.globl _sd_spi_receive_byte
	.globl _sd_spi_transmit_byte
	.globl _sd_spi_lower_cs
	.globl _sd_spi_raise_cs
	.globl _timer_expired
	.globl _set_timer_duration
	.globl _kputs
	.globl _sd_drive
	.globl _sd_spi_release
	.globl _sd_spi_wait
	.globl _sd_send_command
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_sd_drive::
	.ds 1
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
;evosd.c:27: uint8_t devsd_transfer_sector1(void)
;	---------------------------------
; Function devsd_transfer_sector1
; ---------------------------------
_devsd_transfer_sector1::
	call	___sdcc_enter_ix
	push	af
	push	af
	dec	sp
;evosd.c:32: sd_drive = blk_op.blkdev->driver_data & DRIVE_NR_MASK;
	ld	hl, (#(_blk_op + 0x0004) + 0)
	ld	a,(hl)
	and	a, #0x0F
	ld	iy,#_sd_drive
	ld	0 (iy),a
;evosd.c:34: for(attempt=0; attempt<8; attempt++){
	ld	-5 (ix),#0x00
00114$:
;evosd.c:37: (blk_op.blkdev->driver_data & CT_BLOCK) ? blk_op.lba : (blk_op.lba << 9)
	ld	hl, (#(_blk_op + 0x0004) + 0)
	ld	a,(hl)
	ld	de,#(_blk_op + 0x0006)
	ld	hl, #0x0001
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	rlca
	jr	NC,00118$
	ld	c,-4 (ix)
	ld	b,-3 (ix)
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	jr	00119$
00118$:
	push	af
	ld	c,-4 (ix)
	ld	b,-3 (ix)
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	pop	af
	ld	a,#0x09
00159$:
	sla	c
	rl	b
	rl	e
	rl	d
	dec	a
	jr	NZ,00159$
00119$:
;evosd.c:35: if(sd_send_command(blk_op.is_read ? CMD17 : CMD24, 
	ld	a, (#(_blk_op + 0x000b) + 0)
	bit	0,a
	jr	Z,00120$
	ld	-4 (ix),#0x51
	jr	00121$
00120$:
	ld	-4 (ix),#0x58
00121$:
	push	de
	push	bc
	ld	a,-4 (ix)
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	ld	d,h
	ld	a,d
	or	a,l
	jr	NZ,00109$
;evosd.c:39: if(blk_op.is_read){
	ld	a, (#(_blk_op + 0x000b) + 0)
	bit	0,a
	jr	Z,00106$
;evosd.c:40: success = (sd_spi_wait(false) == 0xFE);
	xor	a, a
	push	af
	inc	sp
	call	_sd_spi_wait
	inc	sp
	ld	a,l
	sub	a, #0xFE
	jr	NZ,00161$
	ld	a,#0x01
	jr	00162$
00161$:
	xor	a,a
00162$:
	ld	e,a
;evosd.c:41: if(success){
	bit	0,a
	jr	Z,00110$
;evosd.c:42: sd_spi_receive_sector();
	push	de
	call	_sd_spi_receive_sector
	pop	de
	jr	00110$
00106$:
;evosd.c:46: success = false;
	ld	e,#0x00
;evosd.c:47: if(sd_spi_wait(true) == 0xFF){
	push	de
	ld	a,#0x01
	push	af
	inc	sp
	call	_sd_spi_wait
	inc	sp
	pop	de
	inc	l
	jr	NZ,00110$
;evosd.c:48: sd_spi_transmit_byte(0xFE);
	ld	a,#0xFE
	push	af
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
;evosd.c:49: sd_spi_transmit_sector();
	call	_sd_spi_transmit_sector
;evosd.c:50: sd_spi_transmit_byte(0xFF); /* dummy CRC */
	ld	a,#0xFF
	push	af
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
;evosd.c:51: sd_spi_transmit_byte(0xFF);
	ld	a,#0xFF
	push	af
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
;evosd.c:52: success = ((sd_spi_wait(false) & 0x1F) == 0x05);
	xor	a, a
	push	af
	inc	sp
	call	_sd_spi_wait
	inc	sp
	ld	a,l
	and	a, #0x1F
	sub	a, #0x05
	jr	NZ,00165$
	ld	a,#0x01
	jr	00166$
00165$:
	xor	a,a
00166$:
	ld	e,a
	jr	00110$
00109$:
;evosd.c:56: success = false;
	ld	e,#0x00
00110$:
;evosd.c:58: sd_spi_release();
	push	de
	call	_sd_spi_release
	pop	de
;evosd.c:60: if(success)
	bit	0,e
	jr	Z,00112$
;evosd.c:61: return 1;
	ld	l,#0x01
	jr	00116$
00112$:
;evosd.c:63: kputs("sd: failed, retrying.\n");
	ld	hl,#___str_0
	push	hl
	call	_kputs
	pop	af
;evosd.c:34: for(attempt=0; attempt<8; attempt++){
	inc	-5 (ix)
	ld	a,-5 (ix)
	sub	a, #0x08
	jp	C,00114$
;evosd.c:66: udata.u_error = EIO;
	ld	hl,#0x0005
	ld	((_udata + 0x000c)), hl
;evosd.c:67: return 0;
	ld	l,#0x00
00116$:
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "sd: failed, retrying."
	.db 0x0A
	.db 0x00
;evosd.c:70: void sd_spi_release(void)
;	---------------------------------
; Function sd_spi_release
; ---------------------------------
_sd_spi_release::
;evosd.c:72: sd_spi_raise_cs();
	call	_sd_spi_raise_cs
;evosd.c:73: sd_spi_receive_byte();
	jp  _sd_spi_receive_byte
;evosd.c:76: uint8_t sd_spi_wait(bool want_ff)
;	---------------------------------
; Function sd_spi_wait
; ---------------------------------
_sd_spi_wait::
;evosd.c:81: timer = set_timer_ms(500);
	ld	hl,#0x0005
	push	hl
	call	_set_timer_duration
	pop	af
;evosd.c:83: while(true){
00111$:
;evosd.c:84: b = sd_spi_receive_byte();
	push	hl
	call	_sd_spi_receive_byte
	ld	e,l
	pop	hl
;evosd.c:86: if(b == 0xFF)
	ld	a,e
	inc	a
	jr	NZ,00131$
	ld	a,#0x01
	jr	00132$
00131$:
	xor	a,a
00132$:
	ld	d,a
;evosd.c:85: if(want_ff){
	ld	iy,#2
	add	iy,sp
	bit	0,0 (iy)
	jr	Z,00106$
;evosd.c:86: if(b == 0xFF)
	ld	a,d
	or	a, a
	jr	Z,00107$
;evosd.c:87: break;
	jr	00112$
00106$:
;evosd.c:89: if(b != 0xFF)
	ld	a,d
	or	a, a
	jr	Z,00112$
;evosd.c:90: break;
00107$:
;evosd.c:92: if(timer_expired(timer)){
	push	hl
	push	de
	push	hl
	call	_timer_expired
	pop	af
	ld	a,l
	pop	de
	pop	hl
	bit	0,a
	jr	Z,00111$
;evosd.c:93: kputs("sd: timeout\n");
	ld	hl,#___str_1
	push	de
	push	hl
	call	_kputs
	pop	af
	pop	de
;evosd.c:94: break;
00112$:
;evosd.c:98: return b;
	ld	l,e
	ret
___str_1:
	.ascii "sd: timeout"
	.db 0x0A
	.db 0x00
;evosd.c:101: int sd_send_command(unsigned char cmd, uint32_t arg)
;	---------------------------------
; Function sd_send_command
; ---------------------------------
_sd_send_command::
	call	___sdcc_enter_ix
;evosd.c:105: if (cmd & 0x80) {   /* ACMD<n> is the command sequense of CMD55-CMD<n> */
	bit	7, 4 (ix)
	jr	Z,00104$
;evosd.c:106: cmd &= 0x7F;
	res	7, 4 (ix)
;evosd.c:107: res = sd_send_command(CMD55, 0);
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x77
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
;evosd.c:108: if (res > 1) 
	ld	a,#0x01
	sub	a, l
	jr	NC,00104$
;evosd.c:109: return res;
	ld	h,#0x00
	jp	00117$
00104$:
;evosd.c:113: sd_spi_release(); /* raise CS, then sends 8 clocks (some cards require this) */
	call	_sd_spi_release
;evosd.c:114: sd_spi_lower_cs();
	call	_sd_spi_lower_cs
;evosd.c:115: if(sd_spi_wait(true) != 0xFF)
	ld	a,#0x01
	push	af
	inc	sp
	call	_sd_spi_wait
	inc	sp
	inc	l
	jr	Z,00106$
;evosd.c:116: return 0xFF;
	ld	hl,#0x00FF
	jr	00117$
00106$:
;evosd.c:119: sd_spi_transmit_byte(cmd);                        /* Start + Command index */
	ld	a,4 (ix)
	push	af
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
;evosd.c:127: p = ((unsigned char *)&arg)+3;
	ld	hl,#0x0005
	add	hl,sp
	ld	e, l
	ld	d, h
	inc	de
	inc	de
	inc	de
;evosd.c:128: sd_spi_transmit_byte(*(p--));                     /* Argument[31..24] */
	ld	a,(de)
	ld	h,a
	dec	de
	push	de
	push	hl
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
	pop	de
;evosd.c:129: sd_spi_transmit_byte(*(p--));                     /* Argument[23..16] */
	ld	a,(de)
	ld	h,a
	dec	de
	push	de
	push	hl
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
	pop	de
;evosd.c:130: sd_spi_transmit_byte(*(p--));                     /* Argument[15..8] */
	ld	a,(de)
	ld	h,a
	dec	de
	push	de
	push	hl
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
	pop	de
;evosd.c:131: sd_spi_transmit_byte(*p);                         /* Argument[7..0] */
	ld	a,(de)
	push	af
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
;evosd.c:134: n = 0x01;                                                /* Dummy CRC + Stop */
	ld	h,#0x01
;evosd.c:135: if (cmd == CMD0) n = 0x95;                               /* Valid CRC for CMD0(0) */
	ld	a,4 (ix)
	sub	a, #0x40
	jr	NZ,00108$
	ld	h,#0x95
00108$:
;evosd.c:136: if (cmd == CMD8) n = 0x87;                               /* Valid CRC for CMD8(0x1AA) */
	ld	a,4 (ix)
	sub	a, #0x48
	jr	NZ,00110$
	ld	h,#0x87
00110$:
;evosd.c:137: sd_spi_transmit_byte(n);
	push	hl
	inc	sp
	call	_sd_spi_transmit_byte
	inc	sp
;evosd.c:140: if (cmd == CMD12) 
	ld	a,4 (ix)
	sub	a, #0x4C
	jr	NZ,00126$
;evosd.c:141: sd_spi_receive_byte();     /* Skip a stuff byte when stop reading */
	call	_sd_spi_receive_byte
;evosd.c:143: do{
00126$:
	ld	d,#0x14
00114$:
;evosd.c:144: res = sd_spi_receive_byte();
	push	de
	call	_sd_spi_receive_byte
	pop	de
;evosd.c:145: }while ((res & 0x80) && --n);
	bit	7, l
	jr	Z,00116$
	dec d
	jr	NZ,00114$
00116$:
;evosd.c:147: return res;         /* Return with the response value */
	ld	h,#0x00
00117$:
	pop	ix
	ret
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
