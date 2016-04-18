;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Wed Nov 18 22:15:49 2015
;--------------------------------------------------------
	.module devide
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _timer_expired
	.globl _set_timer_duration
	.globl _kprintf
	.globl _devide_wait
	.globl _devide_transfer_sector
	.globl _devide_flush_cache
	.globl _devide_read_data
	.globl _devide_write_data
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
	.area _CODE2
;../dev/devide.c:20: bool devide_wait(uint8_t bits)
;	---------------------------------
; Function devide_wait
; ---------------------------------
_devide_wait::
	call	___sdcc_enter_ix
	push	af
	dec	sp
;../dev/devide.c:25: timeout = set_timer_ms(500);
	ld	hl,#0x0005
	push	hl
	call	_set_timer_duration
	pop	af
	ld	c, l
	ld	b, h
;../dev/devide.c:27: while(true){
	ld	a,4 (ix)
	or	a, #0x81
	ld	-3 (ix),a
00108$:
;../dev/devide.c:28: status = devide_readb(ide_reg_status);
	in	a,(_ide_reg_status)
;../dev/devide.c:30: if((status & (IDE_STATUS_BUSY | IDE_STATUS_ERROR | bits)) == bits)
	ld	d,a
	and	a, -3 (ix)
	ld	e,a
	ld	a,4 (ix)
	sub	a, e
	jr	NZ,00102$
;../dev/devide.c:31: return true;
	ld	l,#0x01
	jr	00110$
00102$:
;../dev/devide.c:33: if((status & (IDE_STATUS_BUSY | IDE_STATUS_ERROR)) == IDE_STATUS_ERROR){
	ld	a,d
	and	a, #0x81
	ld	h,a
;../dev/devide.c:34: kprintf("ide error, status=%x\n", status);
	ld	-2 (ix),d
	ld	-1 (ix),#0x00
;../dev/devide.c:33: if((status & (IDE_STATUS_BUSY | IDE_STATUS_ERROR)) == IDE_STATUS_ERROR){
	dec	h
	jr	NZ,00104$
;../dev/devide.c:34: kprintf("ide error, status=%x\n", status);
	ld	hl,#___str_0+0
	ld	c,-2 (ix)
	ld	b,-1 (ix)
	push	bc
	push	hl
	call	_kprintf
	pop	af
	pop	af
;../dev/devide.c:35: return false;
	ld	l,#0x00
	jr	00110$
00104$:
;../dev/devide.c:38: if(timer_expired(timeout)){
	push	bc
	push	bc
	call	_timer_expired
	pop	af
	pop	bc
	bit	0,l
	jr	Z,00108$
;../dev/devide.c:39: kprintf("ide timeout, status=%x\n", status);
	ld	hl,#___str_1
	ld	c,-2 (ix)
	ld	b,-1 (ix)
	push	bc
	push	hl
	call	_kprintf
	pop	af
	pop	af
;../dev/devide.c:40: return false;
	ld	l,#0x00
00110$:
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "ide error, status=%x"
	.db 0x0A
	.db 0x00
___str_1:
	.ascii "ide timeout, status=%x"
	.db 0x0A
	.db 0x00
;../dev/devide.c:45: uint8_t devide_transfer_sector(void)
;	---------------------------------
; Function devide_transfer_sector
; ---------------------------------
_devide_transfer_sector::
;../dev/devide.c:53: drive = blk_op.blkdev->driver_data & DRIVE_NR_MASK;
	ld	hl, (#(_blk_op + 0x0004) + 0)
	ld	a,(hl)
	and	a, #0x0F
	ld	c,a
;../dev/devide.c:59: p = ((uint8_t *)&blk_op.lba)+3;
	ld	de,#(_blk_op + 0x0006) + 3
;../dev/devide.c:60: devide_writeb(ide_reg_lba_3, (*(p--) & 0x0F) | ((drive == 0) ? 0xE0 : 0xF0)); // select drive, start loading LBA
	ld	a,(de)
	ld	h,a
	dec	de
	ld	a,h
	and	a, #0x0F
	ld	b,a
	ld	a,c
	or	a, a
	jr	NZ,00131$
	ld	a,#0xE0
	jr	00132$
00131$:
	ld	a,#0xF0
00132$:
	or	a, b
	out	(_ide_reg_lba_3),a
;../dev/devide.c:61: devide_writeb(ide_reg_lba_2, *(p--));
	ld	a,(de)
	out	(_ide_reg_lba_2),a
	dec	de
;../dev/devide.c:62: devide_writeb(ide_reg_lba_1, *(p--));
	ld	a,(de)
	out	(_ide_reg_lba_1),a
	dec	de
;../dev/devide.c:63: devide_writeb(ide_reg_lba_0, *p);
	ld	a,(de)
	out	(_ide_reg_lba_0),a
;../dev/devide.c:71: if (!devide_wait(IDE_STATUS_READY))
	ld	a,#0x40
	push	af
	inc	sp
	call	_devide_wait
	inc	sp
	ld	e,l
	bit	0,e
	jr	Z,00128$
;../dev/devide.c:74: devide_writeb(ide_reg_sec_count, 1);
	ld	a,#0x01
	out	(_ide_reg_sec_count),a
;../dev/devide.c:75: devide_writeb(ide_reg_command, blk_op.is_read ? IDE_CMD_READ_SECTOR : IDE_CMD_WRITE_SECTOR);
	ld	a, (#(_blk_op + 0x000b) + 0)
	bit	0,a
	jr	Z,00133$
	ld	a,#0x20
	jr	00134$
00133$:
	ld	a,#0x30
00134$:
	out	(_ide_reg_command),a
;../dev/devide.c:77: if(!devide_wait(IDE_STATUS_DATAREQUEST))
	ld	a,#0x08
	push	af
	inc	sp
	call	_devide_wait
	inc	sp
	bit	0,l
	jr	Z,00128$
;../dev/devide.c:80: if (blk_op.is_read)
	ld	a, (#(_blk_op + 0x000b) + 0)
	bit	0,a
	jr	Z,00126$
;../dev/devide.c:81: devide_read_data();
	call	_devide_read_data
	jr	00127$
00126$:
;../dev/devide.c:83: devide_write_data();
	call	_devide_write_data
;../dev/devide.c:84: if(!devide_wait(IDE_STATUS_READY))
	ld	a,#0x40
	push	af
	inc	sp
	call	_devide_wait
	inc	sp
	bit	0,l
	jr	Z,00128$
;../dev/devide.c:86: blk_op.blkdev->driver_data |= FLAG_CACHE_DIRTY;
	ld	hl, (#(_blk_op + 0x0004) + 0)
	set	6, (hl)
	ld	a, (hl)
00127$:
;../dev/devide.c:91: return 1;
	ld	l,#0x01
	ret
;../dev/devide.c:92: fail:
00128$:
;../dev/devide.c:94: return 0;
	ld	l,#0x00
	ret
;../dev/devide.c:97: int devide_flush_cache(void)
;	---------------------------------
; Function devide_flush_cache
; ---------------------------------
_devide_flush_cache::
	dec	sp
;../dev/devide.c:101: drive = blk_op.blkdev->driver_data & DRIVE_NR_MASK;
	ld	hl, (#(_blk_op + 0x0004) + 0)
	ld	l,(hl)
	ld	a,l
	and	a, #0x0F
	ld	h,a
;../dev/devide.c:106: if((blk_op.blkdev->driver_data & (FLAG_WRITE_CACHE | FLAG_CACHE_DIRTY))
	ld	a,l
	and	a, #0xC0
	sub	a, #0xC0
	jr	NZ,00112$
;../dev/devide.c:108: devide_writeb(ide_reg_lba_3, (((drive & 1) == 0) ? 0xE0 : 0xF0)); // select drive
	bit	0, h
	jr	NZ,00116$
	ld	a,#0xE0
	jr	00117$
00116$:
	ld	a,#0xF0
00117$:
	out	(_ide_reg_lba_3),a
;../dev/devide.c:110: if (!devide_wait(IDE_STATUS_READY))
	ld	a,#0x40
	push	af
	inc	sp
	call	_devide_wait
	inc	sp
	bit	0,l
	jr	Z,00113$
;../dev/devide.c:113: devide_writeb(ide_reg_command, IDE_CMD_FLUSH_CACHE);
	ld	a,#0xE7
	out	(_ide_reg_command),a
;../dev/devide.c:115: if (!devide_wait(IDE_STATUS_READY))
	ld	a,#0x40
	push	af
	inc	sp
	call	_devide_wait
	inc	sp
	bit	0,l
	jr	Z,00113$
;../dev/devide.c:119: blk_op.blkdev->driver_data &= ~FLAG_CACHE_DIRTY;
	ld	hl, (#(_blk_op + 0x0004) + 0)
	ld	a,(hl)
	and	a, #0xBF
	ld	(hl),a
00112$:
;../dev/devide.c:122: return 0;
	ld	hl,#0x0000
	jr	00114$
;../dev/devide.c:124: fail:
00113$:
;../dev/devide.c:125: udata.u_error = EIO;
	ld	hl,#0x0005
	ld	((_udata + 0x000c)), hl
;../dev/devide.c:127: return -1;
	ld	hl,#0xFFFF
00114$:
	inc	sp
	ret
;../dev/devide.c:140: COMMON_MEMORY
;	---------------------------------
; Function COMMONSEG
; ---------------------------------
_COMMONSEG:
	.area _COMMONMEM 
;../dev/devide.c:142: void devide_read_data(void) __naked
;	---------------------------------
; Function devide_read_data
; ---------------------------------
_devide_read_data::
;../dev/devide.c:165: __endasm;
	ld a, (_blk_op+2) ; blkparam.is_user
	ld hl, (_blk_op+0) ; blkparam.addr
	ld b, #0 ; setup count
	ld c, #0x10 ; setup port number
	or a ; test is_user
	call nz, map_process_always ; map user memory first if required
	swapin:
	inir ; transfer first 256 bytes
	inir ; transfer second 256 bytes
	or a ; test is_user
	ret z ; done if kernel memory transfer
	jp map_kernel ; else map kernel then return
;../dev/devide.c:168: void devide_write_data(void) __naked
;	---------------------------------
; Function devide_write_data
; ---------------------------------
_devide_write_data::
;../dev/devide.c:191: __endasm;
	ld a, (_blk_op+2) ; blkparam.is_user
	ld hl, (_blk_op+0) ; blkparam.addr
	ld b, #0 ; setup count
	ld c, #0x10 ; setup port number
	or a ; test is_user
	call nz, map_process_always ; else map user memory first if required
	swapout:
	otir ; transfer first 256 bytes
	otir ; transfer second 256 bytes
	or a ; test is_user
	ret z ; done if kernel memory transfer
	jp map_kernel ; else map kernel then return
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
