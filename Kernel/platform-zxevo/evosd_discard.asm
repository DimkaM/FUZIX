;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 17:11:42 2016
;--------------------------------------------------------
	.module evosd_discard
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _blkdev_scan
	.globl _blkdev_alloc
	.globl _devsd_transfer_sector
	.globl _sd_spi_wait
	.globl _sd_send_command
	.globl _sd_spi_release
	.globl _sd_spi_receive_byte
	.globl _sd_spi_raise_cs
	.globl _sd_spi_clock
	.globl _timer_expired
	.globl _set_timer_duration
	.globl _kprintf
	.globl _devsd_init
	.globl _sd_init_drive
	.globl _sd_spi_init
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
	.area _DISCARD
;evosd_discard.c:29: void devsd_init(void)
;	---------------------------------
; Function devsd_init
; ---------------------------------
_devsd_init::
;evosd_discard.c:31: for(sd_drive=0; sd_drive<SD_DRIVE_COUNT; sd_drive++)
	ld	hl,#_sd_drive + 0
	ld	(hl), #0x00
00102$:
;evosd_discard.c:32: sd_init_drive();
	call	_sd_init_drive
;evosd_discard.c:31: for(sd_drive=0; sd_drive<SD_DRIVE_COUNT; sd_drive++)
	ld	hl, #_sd_drive+0
	inc	(hl)
	ld	a,(#_sd_drive + 0)
	sub	a, #0x01
	jr	C,00102$
	ret
;evosd_discard.c:35: void sd_init_drive(void)
;	---------------------------------
; Function sd_init_drive
; ---------------------------------
_sd_init_drive::
	call	___sdcc_enter_ix
	ld	hl,#-26
	add	hl,sp
	ld	sp,hl
;evosd_discard.c:41: kprintf("SD drive %d: ", sd_drive);
	ld	hl,#_sd_drive + 0
	ld	e, (hl)
	ld	d,#0x00
	ld	hl,#___str_0
	push	de
	push	hl
	call	_kprintf
	pop	af
	pop	af
;evosd_discard.c:42: card_type = sd_spi_init();
	call	_sd_spi_init
	ld	d,l
;evosd_discard.c:44: if(!(card_type & (~CT_BLOCK))){
	ld	h,d
	ld	l,#0x00
	ld	a,h
	and	a, #0x7F
	jr	NZ,00102$
	ld	a,l
	or	a, a
	jr	NZ,00102$
;evosd_discard.c:45: kprintf("no card found\n");
	ld	hl,#___str_1
	push	hl
	call	_kprintf
	pop	af
;evosd_discard.c:46: return;
	jp	00114$
00102$:
;evosd_discard.c:49: blk = blkdev_alloc();
	push	de
	call	_blkdev_alloc
	pop	de
	ld	-10 (ix),l
;evosd_discard.c:50: if(!blk)
	ld	-9 (ix), h
	ld	a, h
	or	a,-10 (ix)
;evosd_discard.c:51: return;
	jp	Z,00114$
;evosd_discard.c:53: blk->transfer = devsd_transfer_sector;
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	inc	hl
	ld	(hl),#<(_devsd_transfer_sector)
	inc	hl
	ld	(hl),#>(_devsd_transfer_sector)
;evosd_discard.c:54: blk->driver_data = (sd_drive & DRIVE_NR_MASK) | card_type;
	ld	a,(#_sd_drive + 0)
	and	a, #0x0F
	or	a, d
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	(hl),a
;evosd_discard.c:57: if(sd_send_command(CMD9, 0) == 0 && sd_spi_wait(false) == 0xFE){
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x49
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	ld	a,h
	or	a,l
	jp	NZ,00110$
	xor	a, a
	push	af
	inc	sp
	call	_sd_spi_wait
	inc	sp
	ld	a,l
	sub	a, #0xFE
	jp	NZ,00110$
;evosd_discard.c:58: for(n=0; n<16; n++)
	ld	hl,#0x0000
	add	hl,sp
	ex	de,hl
	ld	b,#0x00
00112$:
;evosd_discard.c:59: csd[n] = sd_spi_receive_byte();
	ld	l,b
	ld	h,#0x00
	add	hl,de
	push	hl
	push	bc
	push	de
	call	_sd_spi_receive_byte
	ld	a,l
	pop	de
	pop	bc
	pop	hl
	ld	(hl),a
;evosd_discard.c:58: for(n=0; n<16; n++)
	inc	b
	ld	a,b
	sub	a, #0x10
	jr	C,00112$
;evosd_discard.c:60: if ((csd[0] >> 6) == 1) {
	ld	a,(de)
	rlca
	rlca
	and	a,#0x03
	ld	b,a
;evosd_discard.c:62: blk->drive_lba_count = ((uint32_t)csd[9] 
	ld	a,-10 (ix)
	add	a, #0x05
	ld	-6 (ix),a
	ld	a,-9 (ix)
	adc	a, #0x00
	ld	-5 (ix),a
	ld	l, e
	ld	h, d
;evosd_discard.c:63: + (uint32_t)((unsigned int)csd[8] << 8) + 1) << 10;
	push	de
	pop	iy
;evosd_discard.c:62: blk->drive_lba_count = ((uint32_t)csd[9] 
	push	bc
	ld	bc, #0x0009
	add	hl, bc
	pop	bc
	ld	c,(hl)
;evosd_discard.c:63: + (uint32_t)((unsigned int)csd[8] << 8) + 1) << 10;
	ld	a,8 (iy)
	ld	-7 (ix),a
;evosd_discard.c:60: if ((csd[0] >> 6) == 1) {
	djnz	00107$
;evosd_discard.c:62: blk->drive_lba_count = ((uint32_t)csd[9] 
	ld	-4 (ix),c
	ld	-3 (ix),#0x00
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
;evosd_discard.c:63: + (uint32_t)((unsigned int)csd[8] << 8) + 1) << 10;
	ld	h,-7 (ix)
	ld	l,#0x00
	ld	de,#0x0000
	ld	a,-4 (ix)
	add	a, l
	ld	c,a
	ld	a,-3 (ix)
	adc	a, h
	ld	b,a
	ld	a,-2 (ix)
	adc	a, e
	ld	e,a
	ld	a,-1 (ix)
	adc	a, d
	ld	d,a
	inc	c
	jr	NZ,00151$
	inc	b
	jr	NZ,00151$
	inc	e
	jr	NZ,00151$
	inc	d
00151$:
	ld	a,#0x0A
00152$:
	sla	c
	rl	b
	rl	e
	rl	d
	dec	a
	jr	NZ,00152$
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
	jp	00110$
00107$:
;evosd_discard.c:66: n = (csd[5] & 15) + ((csd[10] & 128) >> 7) + ((csd[9] & 3) << 1) + 2;
	push	de
	pop	iy
	ld	a,5 (iy)
	and	a, #0x0F
	ld	b,a
	ld	l, e
	ld	h, d
	push	bc
	ld	bc, #0x000A
	add	hl, bc
	pop	bc
	ld	a,(hl)
	and	a, #0x80
	rlca
	and	a,#0x01
	add	a,b
	ld	l,a
	ld	a,c
	and	a, #0x03
	add	a, a
	add	a,l
	add	a, #0x02
	ld	-8 (ix),a
;evosd_discard.c:67: blk->drive_lba_count = (csd[8] >> 6) + ((unsigned int)csd[7] << 2) 
	ld	a,-7 (ix)
	rlca
	rlca
	and	a,#0x03
	ld	c,a
	ld	b,#0x00
	push	de
	pop	iy
	ld	l,7 (iy)
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl,bc
	ld	c,l
	ld	b,h
;evosd_discard.c:68: + ((unsigned int)(csd[6] & 3) << 10) + 1;
	push	de
	pop	iy
	ld	a,6 (iy)
	and	a, #0x03
	add	a, a
	add	a, a
	ld	h,a
	ld	l,#0x00
	add	hl,bc
	inc	hl
	ex	de,hl
	ld	bc,#0x0000
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
;evosd_discard.c:69: blk->drive_lba_count <<= (n-9);
	ld	a, -8 (ix)
	ld	h, #0x00
	add	a,#0xF7
	ld	l,a
	ld	a,h
	adc	a,#0xFF
	inc	l
	jr	00155$
00154$:
	sla	e
	rl	d
	rl	c
	rl	b
00155$:
	dec	l
	jr	NZ,00154$
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
00110$:
;evosd_discard.c:72: sd_spi_release();
	call	_sd_spi_release
;evosd_discard.c:74: blkdev_scan(blk, 0);
	xor	a, a
	push	af
	inc	sp
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	push	hl
	call	_blkdev_scan
	pop	af
	inc	sp
00114$:
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "SD drive %d: "
	.db 0x00
___str_1:
	.ascii "no card found"
	.db 0x0A
	.db 0x00
;evosd_discard.c:77: int sd_spi_init(void)
;	---------------------------------
; Function sd_spi_init
; ---------------------------------
_sd_spi_init::
	call	___sdcc_enter_ix
	push	af
	push	af
	push	af
	dec	sp
;evosd_discard.c:89: sd_spi_raise_cs();
	call	_sd_spi_raise_cs
;evosd_discard.c:91: sd_spi_clock(false);
	xor	a, a
	push	af
	inc	sp
	call	_sd_spi_clock
	inc	sp
;evosd_discard.c:92: for (n = 20; n; n--)
	ld	h,#0x14
00131$:
;evosd_discard.c:93: sd_spi_receive_byte(); /* send dummy clocks -- at least 80 required; we send 160 */
	push	hl
	call	_sd_spi_receive_byte
	pop	hl
;evosd_discard.c:92: for (n = 20; n; n--)
	dec h
	jr	NZ,00131$
;evosd_discard.c:95: card_type = CT_NONE;
	ld	-1 (ix),#0x00
;evosd_discard.c:98: if (sd_send_command(CMD0, 0) == 1) {
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x40
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	dec	l
	jp	NZ,00128$
	ld	a,h
	or	a, a
	jp	NZ,00128$
;evosd_discard.c:100: timer = set_timer_sec(2);
	ld	hl,#0x0014
	push	hl
	call	_set_timer_duration
	pop	af
	inc	sp
	inc	sp
	push	hl
;evosd_discard.c:101: if (sd_send_command(CMD8, (uint32_t)0x1AA) == 1) {    /* SDHC */
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x01AA
	push	hl
	ld	a,#0x48
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	dec	l
	jp	NZ,00125$
	ld	a,h
	or	a, a
	jp	NZ,00125$
;evosd_discard.c:103: for (n = 0; n < 4; n++) ocr[n] = sd_spi_receive_byte();
	ld	hl,#0x0002
	add	hl,sp
	ex	de,hl
	ld	b,#0x00
00133$:
	ld	l,b
	ld	h,#0x00
	add	hl,de
	push	hl
	push	bc
	push	de
	call	_sd_spi_receive_byte
	ld	a,l
	pop	de
	pop	bc
	pop	hl
	ld	(hl),a
	inc	b
	ld	a,b
	sub	a, #0x04
	jr	C,00133$
;evosd_discard.c:105: if (ocr[2] == 0x01 && ocr[3] == 0xAA) {
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	a
	jp	NZ,00128$
	push	de
	pop	iy
	ld	a,3 (iy)
	sub	a, #0xAA
	jp	NZ,00128$
;evosd_discard.c:107: while(!timer_expired(timer) && sd_send_command(ACMD41, (uint32_t)1 << 30));
00104$:
	push	de
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_timer_expired
	pop	af
	pop	de
	bit	0,l
	jr	NZ,00106$
	push	de
	ld	hl,#0x4000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0xE9
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	pop	de
	ld	a,h
	or	a,l
	jr	NZ,00104$
00106$:
;evosd_discard.c:109: if (!timer_expired(timer) && sd_send_command(CMD58, 0) == 0) {
	push	de
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_timer_expired
	pop	af
	pop	de
	bit	0,l
	jp	NZ,00128$
	push	de
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x7A
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	pop	de
	ld	a,h
;evosd_discard.c:110: for (n = 0; n < 4; n++) ocr[n] = sd_spi_receive_byte();
	or	a,l
	jp	NZ,00128$
	ld	b,a
00135$:
	ld	l,b
	ld	h,#0x00
	add	hl,de
	push	hl
	push	bc
	push	de
	call	_sd_spi_receive_byte
	ld	a,l
	pop	de
	pop	bc
	pop	hl
	ld	(hl),a
	inc	b
	ld	a,b
	sub	a, #0x04
	jr	C,00135$
;evosd_discard.c:111: card_type = (ocr[0] & 0x40) ? CT_SD2 | CT_BLOCK : CT_SD2;   /* SDv2 */
	ld	a,(de)
	bit	6, a
	jr	Z,00139$
	ld	a,#0xC0
	jr	00140$
00139$:
	ld	a,#0x40
00140$:
	ld	-1 (ix),a
	jp	00128$
00125$:
;evosd_discard.c:115: if (sd_send_command(ACMD41, 0) <= 1) {
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0xE9
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	ld	a,#0x01
	cp	a, l
	ld	a,#0x00
	sbc	a, h
	jp	PO, 00229$
	xor	a, #0x80
00229$:
	jp	M,00115$
;evosd_discard.c:117: card_type = CT_SD1;
	ld	-1 (ix),#0x20
;evosd_discard.c:118: cmd = ACMD41;
	ld	d,#0xE9
	jr	00118$
00115$:
;evosd_discard.c:121: card_type = CT_MMC;
	ld	-1 (ix),#0x10
;evosd_discard.c:122: cmd = CMD1;
	ld	d,#0x41
;evosd_discard.c:125: while(!timer_expired(timer) && sd_send_command(cmd, 0));
00118$:
	push	de
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_timer_expired
	pop	af
	pop	de
	bit	0,l
	jr	NZ,00120$
	push	de
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	push	de
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	pop	de
	ld	a,h
	or	a,l
	jr	NZ,00118$
00120$:
;evosd_discard.c:127: if(timer_expired(timer) || sd_send_command(CMD16, 512) != 0)
	pop	hl
	push	hl
	push	hl
	call	_timer_expired
	pop	af
	bit	0,l
	jr	NZ,00121$
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0200
	push	hl
	ld	a,#0x50
	push	af
	inc	sp
	call	_sd_send_command
	pop	af
	pop	af
	inc	sp
	ld	a,h
	or	a,l
	jr	Z,00128$
00121$:
;evosd_discard.c:128: card_type = CT_NONE;
	ld	-1 (ix),#0x00
00128$:
;evosd_discard.c:131: sd_spi_release();
	call	_sd_spi_release
;evosd_discard.c:133: if (card_type) {
	ld	a,-1 (ix)
	or	a, a
	jr	Z,00130$
;evosd_discard.c:134: sd_spi_clock(true); /* up to 20MHz should be OK */
	ld	a,#0x01
	push	af
	inc	sp
	call	_sd_spi_clock
	inc	sp
;evosd_discard.c:135: return card_type;
	ld	l,-1 (ix)
	ld	h,#0x00
	jr	00137$
00130$:
;evosd_discard.c:138: return CT_NONE; /* failed */
	ld	hl,#0x0000
00137$:
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
	.area _DISCARD
	.area _INITIALIZER
	.area _CABS (ABS)
