;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Mon Apr 18 17:11:27 2016
;--------------------------------------------------------
	.module devsdspi
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _sd_spi_transmit_sector
	.globl _sd_spi_receive_sector
	.globl _devsd_transfer_sector
	.globl _sdspi_OUT_COM
	.globl _sdspi_IN_OOUT
	.globl _sd_spi_receive_byte
	.globl _sd_spi_transmit_byte
	.globl _sd_spi_lower_cs
	.globl _sd_spi_raise_cs
	.globl _sd_spi_clock
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
;devsdspi.c:19: void sd_spi_clock(bool go_fast)
;	---------------------------------
; Function sd_spi_clock
; ---------------------------------
_sd_spi_clock::
;devsdspi.c:21: go_fast;
	ret
;devsdspi.c:24: void sd_spi_raise_cs(void) __naked
;	---------------------------------
; Function sd_spi_raise_cs
; ---------------------------------
_sd_spi_raise_cs::
;devsdspi.c:34: __endasm;
	ld a,#3
	ld bc,#0x8057
	out (c),a
	xor a
	dec b
	out (c),a
	ret
;devsdspi.c:37: void sd_spi_lower_cs(void) __naked
;	---------------------------------
; Function sd_spi_lower_cs
; ---------------------------------
_sd_spi_lower_cs::
;devsdspi.c:44: __endasm;
	ld bc,#0x8057
	ld a,#1
	out (c),a
	ret
;devsdspi.c:47: void sd_spi_transmit_byte(unsigned char byte) __naked
;	---------------------------------
; Function sd_spi_transmit_byte
; ---------------------------------
_sd_spi_transmit_byte::
;devsdspi.c:58: __endasm;
	pop bc
	pop hl
	push hl
	push bc
	ld bc,#0x0057
	out(c),l
	ret
;devsdspi.c:61: uint8_t sd_spi_receive_byte(void) __naked
;	---------------------------------
; Function sd_spi_receive_byte
; ---------------------------------
_sd_spi_receive_byte::
;devsdspi.c:67: __endasm;
	ld bc,#0x0057
	in l,(c)
	ret
;devsdspi.c:70: void sdspi_IN_OOUT(void) __naked
;	---------------------------------
; Function sdspi_IN_OOUT
; ---------------------------------
_sdspi_IN_OOUT::
;devsdspi.c:86: __endasm;
	push de
	LD DE,#0x20FF
	ld bc,#0x0057
	sdspi_IN_WAIT:
	IN A,(c)
	CP E
	JR NZ,sdspi_IN_EXIT
	sdspi_IN_NEXT:
	DEC D
	JR NZ,sdspi_IN_WAIT
	sdspi_IN_EXIT:
	POP DE
	RET
;devsdspi.c:88: void sdspi_OUT_COM(void) __naked
;	---------------------------------
; Function sdspi_OUT_COM
; ---------------------------------
_sdspi_OUT_COM::
;devsdspi.c:107: __endasm;
	push af
	call _sd_spi_lower_cs
	pop af
	ld bc,#0x0057
	OUT (C),A
	XOR A
	OUT (C),A
	NOP
	OUT (C),A
	NOP
	OUT (C),A
	NOP
	OUT (C),A
	DEC A
	OUT (C),A ;пишем пустой CRC7 и стоповый бит
	RET
;devsdspi.c:110: uint8_t devsd_transfer_sector(void) __naked
;	---------------------------------
; Function devsd_transfer_sector
; ---------------------------------
_devsd_transfer_sector::
;devsdspi.c:190: __endasm;
	call _sd_spi_lower_cs
	ld hl,#(_blk_op+11)
	ld a,(hl)
	or a
	push af
	ld a,#0x52
	jr nz,issdread
	ld a,#0x59
	issdread:
	ld b,#0
	out (c),a
	ld hl,#(_blk_op+4) ;тип карты
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)
	and #0x80
	push af
	ld hl,#(_blk_op+6) ;Читаем номер сектора
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	pop af
	jr nz,SECN200
	EX DE,HL ;при сброшенном бите соответственно
	ADD HL,HL ;умножаем номер сектора на 512 (0x200)
	EX DE,HL
	ADC HL,HL
	LD H,L
	LD L,D
	LD D,E
	LD E,#0
	SECN200:
	OUT (C),H ;пишем номер сектора от старшего
	NOP
	OUT (C),L
	NOP
	OUT (C),D
	NOP
	OUT (C),E ;до младшего байта
	LD A,#0xFF
	OUT (C),A ;пишем пустой CRC7 и стоповый бит
	pop af
	jr nz,issdreadloop
	issdwriteloop:
	CALL _sdspi_IN_OOUT
	INC A
	JR NZ,issdwriteloop
	LD A,#0xFC ;пишем стартовый маркер, сам блок и пустое CRC16
	OUT (C),A
	call _sd_spi_transmit_sector
	issdwriteloop2:
	CALL _sdspi_IN_OOUT
	INC A
	JR NZ,issdwriteloop2
	LD A,#0xFD
	OUT (C),A ;даем команду остановки записи
	jr sdendtransm
	issdreadloop:
	call _sdspi_IN_OOUT
	CP #0xFE
	JR NZ,issdreadloop ;ждем маркер готовности 0xFE для наЧала Чтения
	call _sd_spi_receive_sector
	LD A,#0x4C ;по оконЧании Чтения даем команду карте <СТОП>
	CALL _sdspi_OUT_COM
	sdendtransm:
	CALL _sdspi_IN_OOUT
	INC A
	JR NZ,sdendtransm
	ld l,#1
	jp _sd_spi_raise_cs
;devsdspi.c:193: COMMON_MEMORY
;	---------------------------------
; Function COMMONSEG
; ---------------------------------
_COMMONSEG:
	.area _COMMONMEM 
;devsdspi.c:195: bool sd_spi_receive_sector(void) __naked
;	---------------------------------
; Function sd_spi_receive_sector
; ---------------------------------
_sd_spi_receive_sector::
;devsdspi.c:219: __endasm;
	ld a, (_blk_op+2);
	ld hl, (_blk_op+0);
	or a ; Set the Z flag up and save it, dont do it twice
	push af
	call nz,map_process_always
	LD BC,#0x0057+0x8000
	INIR
	LD B,#0x80
	INIR
	LD B,#0x80
	INIR
	LD B,#0x80
	INIR
	NOP
	IN A,(C)
	NOP
	IN A,(C)
	xferout:
	pop af
	call nz,map_kernel
	ret
;devsdspi.c:222: bool sd_spi_transmit_sector(void) __naked
;	---------------------------------
; Function sd_spi_transmit_sector
; ---------------------------------
_sd_spi_transmit_sector::
;devsdspi.c:243: __endasm;
	ld a, (_blk_op+2)
	ld hl, (_blk_op+0)
	or a ; Set the Z flag up and save it, dont do it twice
	push af
	call nz,map_process_always
	LD BC,#0x0057+0x8000
	OTIR
	LD B,#0x80
	OTIR
	LD B,#0x80
	OTIR
	LD B,#0x80
	OTIR
	LD A,#0xFF
	OUT (C),A
	NOP
	OUT (C),A
	jr xferout
	.area _CODE
	.area _CONST
	.area _INITIALIZER
	.area _CABS (ABS)
