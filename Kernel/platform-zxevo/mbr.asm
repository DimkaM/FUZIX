;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 17:11:17 2016
;--------------------------------------------------------
	.module mbr
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _mbr_parse
	.globl _kputs
	.globl _kprintf
	.globl _tmpbuf
	.globl _brelse
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
;../dev/mbr.c:25: void mbr_parse(char letter)
;	---------------------------------
; Function mbr_parse
; ---------------------------------
_mbr_parse::
	call	___sdcc_enter_ix
	ld	hl,#-29
	add	hl,sp
	ld	sp,hl
;../dev/mbr.c:29: uint32_t ep_offset = 0, br_offset = 0;
	xor	a, a
	ld	-24 (ix),a
	ld	-23 (ix),a
	ld	-22 (ix),a
	ld	-21 (ix),a
;../dev/mbr.c:30: uint8_t next = 0;
	ld	-29 (ix),#0x00
;../dev/mbr.c:32: kprintf("hd%c: ", letter);
	ld	a,4 (ix)
	ld	-9 (ix),a
	ld	a,4 (ix)
	rla
	sbc	a, a
	ld	-8 (ix),a
	ld	hl,#___str_0
	ld	c,-9 (ix)
	ld	b,-8 (ix)
	push	bc
	push	hl
	call	_kprintf
	pop	af
	pop	af
;../dev/mbr.c:35: br = (boot_record_t *)tmpbuf();
	call	_tmpbuf
	ld	-18 (ix),l
	ld	-17 (ix),h
;../dev/mbr.c:37: blk_op.is_read = true;
	ld	hl,#_blk_op + 11
	ld	(hl),#0x01
;../dev/mbr.c:38: blk_op.is_user = false;
	ld	hl,#_blk_op + 2
	ld	(hl),#0x00
;../dev/mbr.c:39: blk_op.addr = (uint8_t *)br;
	ld	e,-18 (ix)
	ld	d,-17 (ix)
	ld	(_blk_op), de
;../dev/mbr.c:40: blk_op.lba = 0;
	ld	hl,#0x0000
	ld	((_blk_op + 0x0006)),hl
	ld	((_blk_op + 0x0006)+2), hl
;../dev/mbr.c:42: do{
	ld	a,-18 (ix)
	ld	-4 (ix),a
	ld	a,-17 (ix)
	ld	-3 (ix),a
	ld	a,-18 (ix)
	add	a, #0xBE
	ld	-6 (ix),a
	ld	a,-17 (ix)
	adc	a, #0x01
	ld	-5 (ix),a
	ld	-20 (ix),#0x00
00117$:
;../dev/mbr.c:43: blk_op.nblock = 1;
	ld	hl,#_blk_op + 10
	ld	(hl),#0x01
;../dev/mbr.c:44: if(!blk_op.blkdev->transfer() || le16_to_cpu(br->signature) != MBR_SIGNATURE)
	ld	hl, (#(_blk_op + 0x0004) + 0)
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	___sdcc_call_hl
	ld	c,l
	ld	a,c
	or	a, a
	jp	Z,00119$
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	de, #0x01FE
	add	hl, de
	ld	d,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,d
	sub	a, #0x55
	jp	NZ,00119$
	ld	a,h
	sub	a, #0xAA
	jp	NZ,00119$
;../dev/mbr.c:48: if(seen >= 50)
	ld	a,-20 (ix)
	sub	a, #0x32
	jp	NC,00119$
;../dev/mbr.c:51: if(seen == 1){ 
	ld	a,-20 (ix)
	dec	a
	jr	NZ,00107$
;../dev/mbr.c:53: ep_offset = blk_op.lba;
	ld	de,#(_blk_op + 0x0006)
	ld	hl, #0x0005
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
;../dev/mbr.c:54: next = 4;
	ld	-29 (ix),#0x04
;../dev/mbr.c:55: kputs("< ");
	ld	hl,#___str_1
	push	hl
	call	_kputs
	pop	af
00107$:
;../dev/mbr.c:58: br_offset = blk_op.lba;
	ld	de,#(_blk_op + 0x0006)
	ld	hl, #0x0001
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
;../dev/mbr.c:59: blk_op.lba = 0;
	ld	hl,#0x0000
	ld	((_blk_op + 0x0006)),hl
	ld	((_blk_op + 0x0006)+2), hl
;../dev/mbr.c:61: for(i=0; i<MBR_ENTRY_COUNT && next < MAX_PARTITIONS; i++){
	ld	a,-29 (ix)
	ld	-14 (ix),a
	ld	-19 (ix),#0x00
00125$:
	ld	a,-19 (ix)
	sub	a, #0x04
	jp	NC,00143$
	ld	a,-14 (ix)
	sub	a, #0x0F
	jp	NC,00143$
;../dev/mbr.c:62: switch(br->partition[i].type){
	ld	a,-19 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	ld	-7 (ix),a
	ld	a,-6 (ix)
	add	a, -7 (ix)
	ld	-16 (ix),a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	-15 (ix),a
	ld	a,-16 (ix)
	ld	-2 (ix),a
	ld	a,-15 (ix)
	ld	-1 (ix),a
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0004
	add	hl, de
	ld	l,(hl)
	ld	a,l
	or	a, a
	jp	Z,00126$
;../dev/mbr.c:71: blk_op.lba = ep_offset + le32_to_cpu(br->partition[i].lba_first);
	ld	a,-16 (ix)
	add	a, #0x08
	ld	-2 (ix),a
	ld	a,-15 (ix)
	adc	a, #0x00
	ld	-1 (ix),a
;../dev/mbr.c:76: br->partition[i].lba_count = cpu_to_le32(2L);
	ld	a,-16 (ix)
	add	a, #0x0C
	ld	-16 (ix),a
	ld	a,-15 (ix)
	adc	a, #0x00
	ld	-15 (ix),a
;../dev/mbr.c:62: switch(br->partition[i].type){
	ld	a,l
	cp	a,#0x05
	jr	Z,00111$
	cp	a,#0x0F
	jr	Z,00111$
	sub	a, #0x85
	jr	NZ,00114$
;../dev/mbr.c:67: case 0x85:
00111$:
;../dev/mbr.c:71: blk_op.lba = ep_offset + le32_to_cpu(br->partition[i].lba_first);
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	d,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,-24 (ix)
	add	a, d
	ld	c,a
	ld	a,-23 (ix)
	adc	a, b
	ld	b,a
	ld	a,-22 (ix)
	adc	a, e
	ld	e,a
	ld	a,-21 (ix)
	adc	a, h
	ld	d,a
	ld	((_blk_op + 0x0006)), bc
	ld	((_blk_op + 0x0006)+2), de
;../dev/mbr.c:72: if(next >= 4)
	ld	a,-14 (ix)
	sub	a, #0x04
	jp	NC,00126$
;../dev/mbr.c:76: br->partition[i].lba_count = cpu_to_le32(2L);
	ld	l,-16 (ix)
	ld	h,-15 (ix)
	ld	(hl),#0x02
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
	inc	hl
	ld	(hl),#0x00
;../dev/mbr.c:78: default:
00114$:
;../dev/mbr.c:81: blk_op.blkdev->lba_first[next] = br_offset + le32_to_cpu(br->partition[i].lba_first);
	ld	de, (#(_blk_op + 0x0004) + 0)
	ld	iy,#0x0009
	add	iy, de
	ld	a,-14 (ix)
	add	a, a
	add	a, a
	ld	e,a
	push	de
	ld	d,#0x00
	add	iy, de
	pop	de
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	l,(hl)
	ld	h,a
	ld	a,-28 (ix)
	add	a, c
	ld	c,a
	ld	a,-27 (ix)
	adc	a, b
	ld	b,a
	ld	a,-26 (ix)
	adc	a, l
	ld	l,a
	ld	a,-25 (ix)
	adc	a, h
	ld	h,a
	ld	0 (iy),c
	ld	1 (iy),b
	ld	2 (iy),l
	ld	3 (iy),h
;../dev/mbr.c:82: blk_op.blkdev->lba_count[next] = le32_to_cpu(br->partition[i].lba_count);
	ld	hl, (#(_blk_op + 0x0004) + 0)
	ld	bc,#0x0045
	add	hl,bc
	ld	a,e
	add	a, l
	ld	e,a
	ld	a,#0x00
	adc	a, h
	ld	d,a
	push	de
	ld	e,-16 (ix)
	ld	d,-15 (ix)
	ld	hl, #0x0012
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	de
	ld	hl, #0x0010
	add	hl, sp
	ld	bc, #0x0004
	ldir
;../dev/mbr.c:83: next++;
	inc	-14 (ix)
;../dev/mbr.c:84: kprintf("hd%c%d ", letter, next);
	ld	l,-14 (ix)
	ld	h,#0x00
	ld	de,#___str_2
	push	hl
	ld	l,-9 (ix)
	ld	h,-8 (ix)
	push	hl
	push	de
	call	_kprintf
	pop	af
	pop	af
	pop	af
;../dev/mbr.c:85: }
00126$:
;../dev/mbr.c:61: for(i=0; i<MBR_ENTRY_COUNT && next < MAX_PARTITIONS; i++){
	inc	-19 (ix)
	jp	00125$
00143$:
	ld	a,-14 (ix)
	ld	-29 (ix),a
;../dev/mbr.c:87: seen++;
	inc	-20 (ix)
;../dev/mbr.c:88: }while(blk_op.lba);
	ld	hl, (#(_blk_op + 0x0006) + 0)
	ld	de, (#(_blk_op + 0x0006) + 2)
	ld	a,d
	or	a, e
	or	a, h
	or	a,l
	jp	NZ,00117$
00119$:
;../dev/mbr.c:90: if(ep_offset && next >= 4)
	ld	a,-21 (ix)
	or	a, -22 (ix)
	or	a, -23 (ix)
	or	a,-24 (ix)
	jr	Z,00121$
	ld	a,-29 (ix)
	sub	a, #0x04
	jr	C,00121$
;../dev/mbr.c:91: kputs("> ");
	ld	hl,#___str_3+0
	push	hl
	call	_kputs
	pop	af
00121$:
;../dev/mbr.c:94: brelse((bufptr)br);
	ld	l,-18 (ix)
	ld	h,-17 (ix)
	push	hl
	call	_brelse
	ld	sp,ix
	pop	ix
	ret
___str_0:
	.ascii "hd%c: "
	.db 0x00
___str_1:
	.ascii "< "
	.db 0x00
___str_2:
	.ascii "hd%c%d "
	.db 0x00
___str_3:
	.ascii "> "
	.db 0x00
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
