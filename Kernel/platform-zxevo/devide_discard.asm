;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Nov 16 23:07:45 2015
;--------------------------------------------------------
	.module devide_discard
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _devide_init_drive
	.globl _blkdev_scan
	.globl _blkdev_alloc
	.globl _devide_read_data
	.globl _devide_flush_cache
	.globl _devide_transfer_sector
	.globl _devide_wait
	.globl _kputs
	.globl _kprintf
	.globl _tmpbuf
	.globl _brelse
	.globl _devide_init
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_ide_reg_command	=	0x00f0
_ide_reg_data	=	0x0010
_ide_reg_devhead	=	0x00d0
_ide_reg_error	=	0x0030
_ide_reg_features	=	0x0030
_ide_reg_lba_0	=	0x0070
_ide_reg_lba_1	=	0x0090
_ide_reg_lba_2	=	0x00b0
_ide_reg_lba_3	=	0x00d0
_ide_reg_sec_count	=	0x0050
_ide_reg_status	=	0x00f0
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
;../dev/devide_discard.c:52: void devide_init_drive(uint8_t drive)
;	---------------------------------
; Function devide_init_drive
; ---------------------------------
_devide_init_drive::
	call	___sdcc_enter_ix
	push	af
	push	af
;../dev/devide_discard.c:57: switch(drive & 1){
	ld	a,4 (ix)
	and	a, #0x01
	ld	h,a
	or	a, a
	jr	Z,00101$
	dec	h
	jr	Z,00102$
	jp	00128$
;../dev/devide_discard.c:58: case 0: select = 0xE0; break;
00101$:
	ld	d,#0xE0
	jr	00104$
;../dev/devide_discard.c:59: case 1: select = 0xF0; break;
00102$:
;../dev/devide_discard.c:60: default: return;
;../dev/devide_discard.c:61: }
	ld	d, #0xF0
00104$:
;../dev/devide_discard.c:63: kprintf("IDE drive %d: ", drive);
	ld	c,4 (ix)
	ld	b,#0x00
	ld	hl,#___str_0
	push	de
	push	bc
	push	hl
	call	_kprintf
	pop	af
	ld	h,#0x40
	ex	(sp),hl
	inc	sp
	call	_devide_wait
	inc	sp
	pop	de
	bit	0,l
	jp	Z,00127$
;../dev/devide_discard.c:82: devide_writeb(ide_reg_devhead, select);
	ld	a,d
	out	(_ide_reg_devhead),a
;../dev/devide_discard.c:83: devide_writeb(ide_reg_command, IDE_CMD_IDENTIFY);
	ld	a,#0xEC
	out	(_ide_reg_command),a
;../dev/devide_discard.c:86: buffer = (uint8_t *)tmpbuf();
	call	_tmpbuf
;../dev/devide_discard.c:88: if (!devide_wait(IDE_STATUS_DATAREQUEST))
	push	hl
	ld	a,#0x08
	push	af
	inc	sp
	call	_devide_wait
	inc	sp
	pop	bc
;../dev/devide_discard.c:122: brelse((bufptr)buffer);
	ld	e, c
	ld	d, b
	inc	sp
	inc	sp
	push	de
;../dev/devide_discard.c:88: if (!devide_wait(IDE_STATUS_DATAREQUEST))
	bit	0,l
	jp	Z,00126$
;../dev/devide_discard.c:91: blk_op.is_user = false;
	ld	hl,#_blk_op + 2
	ld	(hl),#0x00
;../dev/devide_discard.c:92: blk_op.addr = buffer;
	ld	(_blk_op), bc
;../dev/devide_discard.c:93: blk_op.nblock = 1;
	ld	hl,#_blk_op + 10
	ld	(hl),#0x01
;../dev/devide_discard.c:94: devide_read_data();
	push	bc
	call	_devide_read_data
	pop	bc
;../dev/devide_discard.c:96: if(!(buffer[99] & 0x02)) {
	push	bc
	pop	iy
	bit	1,99 (iy)
	jr	NZ,00116$
;../dev/devide_discard.c:97: kputs("LBA unsupported.\n");
	ld	hl,#___str_1
	push	hl
	call	_kputs
	pop	af
;../dev/devide_discard.c:98: goto failout;
	jp	00126$
00116$:
;../dev/devide_discard.c:101: blk = blkdev_alloc();
	push	bc
	call	_blkdev_alloc
	pop	bc
	ex	de,hl
;../dev/devide_discard.c:102: if(!blk)
	ld	a,d
	or	a,e
	jp	Z,00126$
;../dev/devide_discard.c:105: blk->transfer = devide_transfer_sector;
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#<(_devide_transfer_sector)
	inc	hl
	ld	(hl),#>(_devide_transfer_sector)
;../dev/devide_discard.c:106: blk->flush = devide_flush_cache;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#<(_devide_flush_cache)
	inc	hl
	ld	(hl),#>(_devide_flush_cache)
;../dev/devide_discard.c:107: blk->driver_data = drive & DRIVE_NR_MASK;
	ld	a,4 (ix)
	and	a, #0x0F
	ld	(de),a
;../dev/devide_discard.c:109: if( !(((uint16_t*)buffer)[82] == 0x0000 && ((uint16_t*)buffer)[83] == 0x0000) ||
	push	bc
	pop	iy
	push	iy
	pop	hl
	push	bc
	ld	bc, #0x00A4
	add	hl, bc
	pop	bc
	ld	a,(hl)
	ld	-2 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-1 (ix), a
	or	a,-2 (ix)
	jr	NZ,00121$
	push	iy
	pop	hl
	push	bc
	ld	bc, #0x00A6
	add	hl, bc
	pop	bc
	ld	a, (hl)
	inc	hl
	ld	l,(hl)
	ld	h,a
	or	a,l
	jr	NZ,00121$
;../dev/devide_discard.c:110: (((uint16_t*)buffer)[82] == 0xFFFF && ((uint16_t*)buffer)[83] == 0xFFFF) ){
	ld	a,-2 (ix)
	inc	a
	jr	NZ,00122$
	ld	a,-1 (ix)
	inc	a
	jr	NZ,00122$
	inc	h
	jr	NZ,00122$
	inc	l
	jr	NZ,00122$
00121$:
;../dev/devide_discard.c:112: if(buffer[164] & 0x20){
	ld	l, c
	ld	h, b
	push	bc
	ld	bc, #0x00A4
	add	hl, bc
	pop	bc
	bit	5,(hl)
	jr	Z,00122$
;../dev/devide_discard.c:114: blk->driver_data |= FLAG_WRITE_CACHE;
	ld	a,(de)
	set	7, a
	ld	(de),a
00122$:
;../dev/devide_discard.c:119: blk->drive_lba_count = le32_to_cpu(*((uint32_t*)&buffer[120]));
	ld	iy,#0x0005
	add	iy, de
	ld	hl,#0x0078
	add	hl,bc
	ld	b,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	l,(hl)
	ld	h,a
	ld	0 (iy),b
	ld	1 (iy),c
	ld	2 (iy),l
	ld	3 (iy),h
;../dev/devide_discard.c:122: brelse((bufptr)buffer);
	push	de
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_brelse
	pop	af
	pop	de
;../dev/devide_discard.c:129: blkdev_scan(blk, SWAPSCAN);
	ld	a,#0x01
	push	af
	inc	sp
	push	de
	call	_blkdev_scan
	pop	af
	inc	sp
;../dev/devide_discard.c:131: return;
	jr	00128$
;../dev/devide_discard.c:132: failout:
00126$:
;../dev/devide_discard.c:133: brelse((bufptr)buffer);
	pop	hl
	push	hl
	push	hl
	call	_brelse
	pop	af
;../dev/devide_discard.c:134: out:
00127$:
;../dev/devide_discard.c:136: return;
00128$:
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "IDE drive %d: "
	.db 0x00
___str_1:
	.ascii "LBA unsupported."
	.db 0x0A
	.db 0x00
;../dev/devide_discard.c:139: void devide_init(void)
;	---------------------------------
; Function devide_init
; ---------------------------------
_devide_init::
;../dev/devide_discard.c:147: for(d=0; d < DRIVE_COUNT; d++)
	ld	h,#0x00
00102$:
;../dev/devide_discard.c:148: devide_init_drive(d);
	push	hl
	push	hl
	inc	sp
	call	_devide_init_drive
	inc	sp
	pop	hl
;../dev/devide_discard.c:147: for(d=0; d < DRIVE_COUNT; d++)
	inc	h
	ld	a,h
	sub	a, #0x01
	jr	C,00102$
	ret
	.area _CODE
	.area _DISCARD
	.area _INITIALIZER
	.area _CABS (ABS)
