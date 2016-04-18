;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Thu Oct 15 13:02:16 2015
;--------------------------------------------------------
	.module devmegasd
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _sd_spi_unmap_interface
	.globl _sd_spi_map_interface
	.globl _megasd_probe
	.globl _kprintf
	.globl _slotmfr
	.globl _sd_spi_clock
	.globl _sd_spi_raise_cs
	.globl _sd_spi_lower_cs
	.globl _sd_spi_transmit_byte
	.globl _sd_spi_receive_byte
	.globl _sd_spi_receive_sector
	.globl _sd_spi_transmit_sector
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_RAM_PAGE0	=	0x00fc
_RAM_PAGE1	=	0x00fd
_RAM_PAGE2	=	0x00fe
_RAM_PAGE3	=	0x00ff
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_slotmfr::
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
	.area _COMMONMEM
;devmegasd.c:45: int megasd_probe()
;	---------------------------------
; Function megasd_probe
; ---------------------------------
_megasd_probe::
;devmegasd.c:50: for (slot = 1; slot < 3; slot++) {
	ld	e,#0x01
	ld	b,#0x01
00108$:
;devmegasd.c:52: slotmfr = 0x80 | MSD_SUBSLOT << 2 | slot;
	ld	a,b
	or	a, #0x8C
	ld	(#_slotmfr + 0),a
;devmegasd.c:54: writeb(MSD_MAGIC_PAGE, MFR_BANKSEL0);
	ld	hl,#0x6000
	ld	(hl),#0x0E
;devmegasd.c:55: if (sigp[0] == 'M' && sigp[1] == 'e' && sigp[2] == 'g' && sigp[3] == 'a')
	ld	hl,#0x4110
	ld	h,(hl)
	ld	l,#0x00
	ld	a,h
	sub	a,#0x4D
	jr	NZ,00109$
	or	a,l
	jr	NZ,00109$
	ld	hl,#0x4111
	ld	h,(hl)
	ld	l,#0x00
	ld	a,h
	sub	a,#0x65
	jr	NZ,00109$
	or	a,l
	jr	NZ,00109$
	ld	hl,#0x4112
	ld	h,(hl)
	ld	l,#0x00
	ld	a,h
	sub	a,#0x67
	jr	NZ,00109$
	or	a,l
	jr	NZ,00109$
	ld	hl,#0x4113
	ld	h,(hl)
	ld	l,#0x00
	ld	a,h
	sub	a,#0x61
	jr	NZ,00138$
	or	a,l
	jr	Z,00107$
00138$:
;devmegasd.c:56: goto found;
00109$:
;devmegasd.c:50: for (slot = 1; slot < 3; slot++) {
	inc	b
	ld	a,b
	ld	e,a
	sub	a, #0x03
	jr	C,00108$
;devmegasd.c:59: return 0;
	ld	hl,#0x0000
	ret
;devmegasd.c:61: found:
00107$:
;devmegasd.c:63: kprintf("MegaSD found in slot %d-3\n", slot);
	ld	d,#0x00
	ld	hl,#___str_0+0
	push	de
	push	hl
	call	_kprintf
	pop	af
	pop	af
;devmegasd.c:64: return 1;
	ld	hl,#0x0001
	ret
___str_0:
	.ascii "MegaSD found in slot %d-3"
	.db 0x0A
	.db 0x00
;devmegasd.c:67: void sd_spi_map_interface()
;	---------------------------------
; Function sd_spi_map_interface
; ---------------------------------
_sd_spi_map_interface::
;devmegasd.c:70: writeb(MSD_PAGE, MFR_BANKSEL0);
	ld	hl,#0x6000
	ld	(hl),#0x40
	ret
;devmegasd.c:73: void sd_spi_unmap_interface()
;	---------------------------------
; Function sd_spi_unmap_interface
; ---------------------------------
_sd_spi_unmap_interface::
;devmegasd.c:76: }
	ret
;devmegasd.c:78: void sd_spi_clock(bool go_fast)
;	---------------------------------
; Function sd_spi_clock
; ---------------------------------
_sd_spi_clock::
;devmegasd.c:80: go_fast;
	ret
;devmegasd.c:83: void sd_spi_raise_cs(void)
;	---------------------------------
; Function sd_spi_raise_cs
; ---------------------------------
_sd_spi_raise_cs::
;devmegasd.c:85: sd_spi_map_interface();
	call	_sd_spi_map_interface
;devmegasd.c:86: writeb(sd_drive, MSD_DEVSEL);
	ld	hl,#0x5800
	ld	a,(#_sd_drive + 0)
	ld	(hl),a
;devmegasd.c:90: readb(MSD_CS);
	ld	h, #0x50
	ld	a,(hl)
;devmegasd.c:92: sd_spi_unmap_interface();
	jp  _sd_spi_unmap_interface
;devmegasd.c:95: void sd_spi_lower_cs(void)
;	---------------------------------
; Function sd_spi_lower_cs
; ---------------------------------
_sd_spi_lower_cs::
;devmegasd.c:98: }
	ret
;devmegasd.c:100: void sd_spi_transmit_byte(unsigned char byte)
;	---------------------------------
; Function sd_spi_transmit_byte
; ---------------------------------
_sd_spi_transmit_byte::
;devmegasd.c:102: sd_spi_map_interface();
	call	_sd_spi_map_interface
;devmegasd.c:104: writeb(byte, MSD_RDWR);
	ld	hl,#0x4000
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	ld	(hl),a
;devmegasd.c:106: sd_spi_unmap_interface();
	jp  _sd_spi_unmap_interface
;devmegasd.c:109: uint8_t sd_spi_receive_byte(void)
;	---------------------------------
; Function sd_spi_receive_byte
; ---------------------------------
_sd_spi_receive_byte::
;devmegasd.c:113: sd_spi_map_interface();
	call	_sd_spi_map_interface
;devmegasd.c:115: c = readb(MSD_RDWR);
	ld	hl,#0x4000
	ld	l,(hl)
;devmegasd.c:117: sd_spi_unmap_interface();
	push	hl
	call	_sd_spi_unmap_interface
	pop	hl
;devmegasd.c:119: return c;
	ret
;devmegasd.c:127: bool sd_spi_receive_sector(void) __naked
;	---------------------------------
; Function sd_spi_receive_sector
; ---------------------------------
_sd_spi_receive_sector::
;devmegasd.c:166: __endasm;
; map sd interface
;
	ld a,(_slotmfr)
	ld a, #0x40
	ld (0x6000),a
	ld a, (_blk_op+2)
	ld de, (_blk_op+0)
	push af
	or a
	jr z, starttx
; map process target page in slot_page2 if needed
;
	ld a,d
	and #0xC0
	rlca
	rlca ; a contains the page to map
	ld b,#0
	ld c,a
	ld hl,#0xF002
	add hl,bc
	ld a,(hl)
	out(_RAM_PAGE2),a
	starttx:
; calculate offset address in target page
	ld a,d
	and #0x3F
	or #0x80
	ld d,a
	ld hl,#0x4000
	ld bc,#512
	jp looptxrx
;devmegasd.c:169: bool sd_spi_transmit_sector(void) __naked
;	---------------------------------
; Function sd_spi_transmit_sector
; ---------------------------------
_sd_spi_transmit_sector::
;devmegasd.c:237: __endasm;
; map sd interface
;
	ld a,(_slotmfr)
	ld a, #0x40
	ld (0x6000),a
; map process target page in slot_page2
;
	ld a, (_blk_op+2)
	ld de, (_blk_op+0);
	push af
	or a
	jr z, startrx
; map process target page in slot_page2 if needed
;
	ld a,d
	and #0xC0
	rlca
	rlca ; a contains the page to map
	ld b,#0
	ld c,a
	ld hl,#0xF002
	add hl,bc
	ld a,(hl)
	out(_RAM_PAGE2),a
	startrx:
; calculate offset address in target page
	ld a,d
	and #0x3F
	or #0x80
	ld d,a
	ld hl,#0x4000
	ex de,hl
	ld bc,#512
	looptxrx:
	ldi ; 16x ldi: 19% faster
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	jp pe, looptxrx
; unmap interface
;
	ld a,(_slotram)
	pop af
	or a
	ret z
	jp _map_kernel
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
