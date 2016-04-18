;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 17:11:27 2016
;--------------------------------------------------------
	.module blkdev
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _mbr_parse
	.globl _kputchar
	.globl _kputs
	.globl _panic
	.globl _blk_op
	.globl _blkdev_open
	.globl _blkdev_read
	.globl _blkdev_write
	.globl _blkdev_ioctl
	.globl _blkdev_alloc
	.globl _blkdev_scan
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_blkdev_table:
	.ds 258
_blk_op::
	.ds 12
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
;../dev/blkdev.c:56: int blkdev_open(uint8_t minor, uint16_t flags)
;	---------------------------------
; Function blkdev_open
; ---------------------------------
_blkdev_open::
	call	___sdcc_enter_ix
	dec	sp
;../dev/blkdev.c:62: drive = minor >> 4;
	ld	a,4 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a,#0x0F
	ld	d,a
;../dev/blkdev.c:63: partition = minor & 0x0F;
	ld	a,4 (ix)
	and	a, #0x0F
	ld	-1 (ix),a
;../dev/blkdev.c:65: if(drive < MAX_BLKDEV){
	ld	a,d
	sub	a, #0x02
	jr	NC,00106$
;../dev/blkdev.c:66: if(blkdev_table[drive].drive_lba_count && (partition == 0 || blkdev_table[drive].lba_count[partition-1]))
	ld	bc,#_blkdev_table+0
	ld	e,d
	ld	d,#0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl,bc
	ex	de,hl
	push	de
	pop	iy
	ld	l,5 (iy)
	ld	h,6 (iy)
	ld	c,7 (iy)
	ld	a, 8 (iy)
	or	a, c
	or	a, h
	or	a,l
	jr	Z,00106$
	ld	a,-1 (ix)
	or	a, a
	jr	Z,00101$
	ld	hl,#0x0045
	add	hl,de
	ld	a,-1 (ix)
	add	a,#0xFF
	add	a, a
	add	a, a
	ld	e, a
	ld	d,#0x00
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	a, (hl)
	or	a, c
	or	a, d
	or	a,e
	jr	Z,00106$
00101$:
;../dev/blkdev.c:67: return 0; /* that is a valid minor number */
	ld	hl,#0x0000
	jr	00107$
00106$:
;../dev/blkdev.c:71: udata.u_error = ENODEV;
	ld	hl,#0x0013
	ld	((_udata + 0x000c)), hl
;../dev/blkdev.c:72: return -1;
	ld	hl,#0xFFFF
00107$:
	inc	sp
	pop	ix
	ret
;../dev/blkdev.c:75: static int blkdev_transfer(uint8_t minor, uint8_t rawflag)
;	---------------------------------
; Function blkdev_transfer
; ---------------------------------
_blkdev_transfer:
	call	___sdcc_enter_ix
	push	af
	push	af
	push	af
	dec	sp
;../dev/blkdev.c:77: uint8_t partition, n, count=0;
	ld	-7 (ix),#0x00
;../dev/blkdev.c:80: blk_op.blkdev = &blkdev_table[minor >> 4];
	ld	a,4 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a,#0x0F
	ld	c,a
	ld	b,#0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de,#_blkdev_table
	add	hl,de
	ld	e, l
	ld	d, h
	ld	((_blk_op + 0x0004)), de
;../dev/blkdev.c:81: partition = minor & 0x0F;
	ld	a,4 (ix)
	and	a, #0x0F
	ld	-6 (ix),a
;../dev/blkdev.c:83: blk_op.is_user = rawflag;
	ld	hl,#_blk_op + 2
	ld	a,5 (ix)
	ld	(hl),a
;../dev/blkdev.c:87: blk_op.nblock = 1;
;../dev/blkdev.c:88: blk_op.lba = udata.u_buf->bf_blk;
;../dev/blkdev.c:84: switch(rawflag){
	ld	a,5 (ix)
	or	a, a
	jr	Z,00101$
	ld	a,5 (ix)
	dec	a
	jr	Z,00102$
	jp	00119$
;../dev/blkdev.c:85: case 0:
00101$:
;../dev/blkdev.c:87: blk_op.nblock = 1;
	ld	hl,#(_blk_op + 0x000a)
	ld	(hl),#0x01
;../dev/blkdev.c:88: blk_op.lba = udata.u_buf->bf_blk;
	ld	hl, (#(_udata + 0x0068) + 0)
	ld	de, #0x0202
	add	hl, de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	bc,#0x0000
	ld	((_blk_op + 0x0006)), de
	ld	((_blk_op + 0x0006)+2), bc
;../dev/blkdev.c:89: blk_op.addr = udata.u_buf->bf_data;
	ld	de, (#(_udata + 0x0068) + 0)
	ld	(_blk_op), de
;../dev/blkdev.c:90: break;
	jr	00106$
;../dev/blkdev.c:91: case 1:
00102$:
;../dev/blkdev.c:93: blk_op.nblock = (udata.u_count >> BLKSHIFT);
	ld	hl, (#(_udata + 0x0062) + 0)
	ld	a,h
	srl	a
	ld	d,a
	ld	hl,#(_blk_op + 0x000a)
	ld	(hl),d
;../dev/blkdev.c:94: if((udata.u_count | (uint16_t)udata.u_offset) & BLKMASK)
	ld	de, (#(_udata + 0x0062) + 0)
	ld	bc, (#(_udata + 0x0064) + 0)
	ld	hl, (#(_udata + 0x0064) + 2)
	ld	a,e
	or	a, c
	ld	h,a
	ld	a,d
	or	a, b
	ld	l,a
	ld	a,h
	or	a, a
	jr	NZ,00160$
	bit	0, l
	jr	Z,00104$
00160$:
;../dev/blkdev.c:95: panic("blkdev: not integral");
	ld	hl,#___str_0
	push	hl
	call	_panic
	pop	af
00104$:
;../dev/blkdev.c:96: blk_op.lba = (udata.u_offset >> BLKSHIFT);
	ld	de, (#(_udata + 0x0064) + 0)
	ld	bc, (#(_udata + 0x0064) + 2)
	ld	a,#0x09
00161$:
	sra	b
	rr	c
	rr	d
	rr	e
	dec	a
	jr	NZ,00161$
	ld	((_blk_op + 0x0006)), de
	ld	((_blk_op + 0x0006)+2), bc
;../dev/blkdev.c:97: blk_op.addr = udata.u_base;
	ld	de, (#_udata + 96)
	ld	(_blk_op), de
;../dev/blkdev.c:109: }
00106$:
;../dev/blkdev.c:113: if(blk_op.lba >= blk_op.blkdev->drive_lba_count)
	ld	bc, (#(_blk_op + 0x0004) + 0)
	push	bc
	ld	de,#(_blk_op + 0x0006)
	ld	hl, #0x0004
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
;../dev/blkdev.c:111: if(partition == 0){
	ld	a,-6 (ix)
	or	a, a
	jr	NZ,00112$
;../dev/blkdev.c:113: if(blk_op.lba >= blk_op.blkdev->drive_lba_count)
	ld	l, c
	ld	h, b
	ld	de, #0x0005
	add	hl, de
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,-5 (ix)
	sub	a, d
	ld	a,-4 (ix)
	sbc	a, e
	ld	a,-3 (ix)
	sbc	a, b
	ld	a,-2 (ix)
	sbc	a, h
	jr	C,00116$
;../dev/blkdev.c:114: goto xferfail;
	jp	00119$
00112$:
;../dev/blkdev.c:117: if(blk_op.lba >= blk_op.blkdev->lba_count[partition-1])
	ld	hl,#0x0045
	add	hl,bc
	ld	a,-6 (ix)
	add	a,#0xFF
	add	a, a
	add	a, a
	ld	-1 (ix), a
	ld	e, a
	ld	d,#0x00
	add	hl,de
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	h,(hl)
	ld	l,a
	ld	a,-5 (ix)
	sub	a, d
	ld	a,-4 (ix)
	sbc	a, e
	ld	a,-3 (ix)
	sbc	a, h
	ld	a,-2 (ix)
	sbc	a, l
	jp	NC,00119$
;../dev/blkdev.c:120: blk_op.lba += blk_op.blkdev->lba_first[partition-1];
	ld	hl,#0x0009
	add	hl,bc
	ld	e,-1 (ix)
	ld	d,#0x00
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,-5 (ix)
	add	a, e
	ld	e,a
	ld	a,-4 (ix)
	adc	a, d
	ld	d,a
	ld	a,-3 (ix)
	adc	a, b
	ld	c,a
	ld	a,-2 (ix)
	adc	a, h
	ld	b,a
	ld	((_blk_op + 0x0006)), de
	ld	((_blk_op + 0x0006)+2), bc
;../dev/blkdev.c:123: while(blk_op.nblock){
00116$:
	ld	a, (#(_blk_op + 0x000a) + 0)
	or	a, a
	jr	Z,00118$
;../dev/blkdev.c:124: n = blk_op.blkdev->transfer();
	ld	hl, (#(_blk_op + 0x0004) + 0)
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	___sdcc_call_hl
	ld	d,l
;../dev/blkdev.c:125: if(n == 0)
	ld	a,d
	or	a, a
	jr	Z,00119$
;../dev/blkdev.c:127: blk_op.nblock -= n;
	ld	a,(#(_blk_op + 0x000a) + 0)
	sub	a, d
	ld	hl,#(_blk_op + 0x000a)
	ld	(hl),a
;../dev/blkdev.c:128: count += n;
	ld	a,-7 (ix)
	add	a, d
	ld	-7 (ix),a
;../dev/blkdev.c:129: blk_op.addr += n * BLKSIZE;
	ld	hl, (#_blk_op + 0)
	ld	a, d
	ld	e, #0x00
	add	a, a
	ld	b,a
	ld	c,#0x00
	add	hl,bc
	ld	c,l
	ld	b,h
	ld	(_blk_op), bc
;../dev/blkdev.c:130: blk_op.lba += n;
	push	de
	ld	de,#(_blk_op + 0x0006)
	ld	hl, #0x0004
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	de
	ld	hl,#0x0000
	ld	b,#0x00
	ld	a,-5 (ix)
	add	a, d
	ld	e,a
	ld	a,-4 (ix)
	adc	a, h
	ld	d,a
	ld	a,-3 (ix)
	adc	a, l
	ld	c,a
	ld	a,-2 (ix)
	adc	a, b
	ld	b,a
	ld	((_blk_op + 0x0006)), de
	ld	((_blk_op + 0x0006)+2), bc
	jr	00116$
00118$:
;../dev/blkdev.c:133: return count; /* 10/10, would transfer sectors again */
	ld	l,-7 (ix)
	ld	h,#0x00
	jr	00120$
;../dev/blkdev.c:134: xferfail:
00119$:
;../dev/blkdev.c:135: udata.u_error = EIO;
	ld	hl,#0x0005
	ld	((_udata + 0x000c)), hl
;../dev/blkdev.c:136: return -1;
	ld	hl,#0xFFFF
00120$:
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "blkdev: not integral"
	.db 0x00
;../dev/blkdev.c:139: int blkdev_read(uint8_t minor, uint8_t rawflag, uint8_t flag)
;	---------------------------------
; Function blkdev_read
; ---------------------------------
_blkdev_read::
;../dev/blkdev.c:142: blk_op.is_read = true;
	ld	hl,#_blk_op+11
	ld	(hl),#0x01
;../dev/blkdev.c:143: return blkdev_transfer(minor, rawflag);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_blkdev_transfer
	pop	af
	ret
;../dev/blkdev.c:146: int blkdev_write(uint8_t minor, uint8_t rawflag, uint8_t flag)
;	---------------------------------
; Function blkdev_write
; ---------------------------------
_blkdev_write::
;../dev/blkdev.c:149: blk_op.is_read = false;
	ld	hl,#_blk_op+11
	ld	(hl),#0x00
;../dev/blkdev.c:150: return blkdev_transfer(minor, rawflag);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_blkdev_transfer
	pop	af
	ret
;../dev/blkdev.c:153: int blkdev_ioctl(uint8_t minor, uint16_t request, char *data)
;	---------------------------------
; Function blkdev_ioctl
; ---------------------------------
_blkdev_ioctl::
	call	___sdcc_enter_ix
;../dev/blkdev.c:157: if (request != BLKFLSBUF)
	ld	a,5 (ix)
	sub	a, #0x03
	jr	NZ,00116$
	ld	a,6 (ix)
	sub	a, #0x41
	jr	Z,00102$
00116$:
;../dev/blkdev.c:158: return -1;
	ld	hl,#0xFFFF
	jr	00106$
00102$:
;../dev/blkdev.c:161: blk_op.blkdev = &blkdev_table[minor >> 4];
	ld	a,4 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a,#0x0F
	ld	c,a
	ld	b,#0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de,#_blkdev_table
	add	hl,de
	ld	c, l
	ld	b, h
	ld	((_blk_op + 0x0004)), bc
;../dev/blkdev.c:163: if (blk_op.blkdev->flush)
	ld	de, (#(_blk_op + 0x0004) + 0)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	a, (hl)
	or	a,b
	jr	Z,00104$
;../dev/blkdev.c:164: return blk_op.blkdev->flush();
	push	de
	pop	iy
	ld	l,3 (iy)
	ld	h,4 (iy)
	call	___sdcc_call_hl
	jr	00106$
00104$:
;../dev/blkdev.c:166: return 0;
	ld	hl,#0x0000
00106$:
	pop	ix
	ret
;../dev/blkdev.c:172: blkdev_t *blkdev_alloc(void)
;	---------------------------------
; Function blkdev_alloc
; ---------------------------------
_blkdev_alloc::
;../dev/blkdev.c:174: blkdev_t *blk = &blkdev_table[0];
	ld	de,#_blkdev_table
;../dev/blkdev.c:175: while (blk <= &blkdev_table[MAX_BLKDEV-1]) {
	ld	c, e
	ld	b, d
00103$:
	ld	hl,#(_blkdev_table + 0x0081)
	cp	a, a
	sbc	hl, bc
	jr	C,00105$
;../dev/blkdev.c:178: if (blk->transfer == NULL)
	ld	l, c
	ld	h, b
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	l,(hl)
	or	a,l
	jr	NZ,00102$
;../dev/blkdev.c:179: return blk;
	ex	de,hl
	ret
00102$:
;../dev/blkdev.c:180: blk++;
	ld	hl,#0x0081
	add	hl,bc
	ld	c,l
	ld	b,h
	ld	e, c
	ld	d, b
	jr	00103$
00105$:
;../dev/blkdev.c:182: kputs("blkdev: full\n");
	ld	hl,#___str_1
	push	hl
	call	_kputs
	pop	af
;../dev/blkdev.c:183: return NULL;
	ld	hl,#0x0000
	ret
___str_1:
	.ascii "blkdev: full"
	.db 0x0A
	.db 0x00
;../dev/blkdev.c:187: void blkdev_scan(blkdev_t *blk, uint8_t flags)
;	---------------------------------
; Function blkdev_scan
; ---------------------------------
_blkdev_scan::
;../dev/blkdev.c:189: uint8_t letter = 'a' + (blk - blkdev_table);
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	sub	a, #<(_blkdev_table)
	ld	e,a
	ld	a,1 (iy)
	sbc	a, #>(_blkdev_table)
	ld	d,a
	ld	hl,#0x0081
	push	hl
	push	de
	call	__divsint
	pop	af
	pop	af
	ld	a,l
	add	a, #0x61
	ld	d,a
;../dev/blkdev.c:193: blk_op.blkdev = blk;
	ld	hl,#_blk_op+4
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
;../dev/blkdev.c:194: mbr_parse(letter);
	push	de
	inc	sp
	call	_mbr_parse
	inc	sp
;../dev/blkdev.c:195: kputchar('\n');
	ld	a,#0x0A
	push	af
	inc	sp
	call	_kputchar
	inc	sp
	ret
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
