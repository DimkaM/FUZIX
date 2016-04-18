	DEVICE ZXSPECTRUM48
	
	ORG 0xC000
START: 
	di
	ld a,1
	out (0xbf),a
	ld a,0x06
	ld bc,0xff77
	out (c),a
	ld a,0xfe
	LD bc,0xb7f7
	out (c),a
	ld hl,0x81c1
	ld de,0x81c2
	ld bc,0x263e
	ld (hl),0x07
	ldir
	
	ld sp,0
	ld hl,filename
	rst 8
	defb 0x51,0X05
	rst 8
	defb 0x51,0X08
	
	ld bc,0xb7f7
	ld a,15
	out (c),a
	ld a,1
	exa
	ld a,32
	ld hl,0x8000
	rst 8
	defb 0x51,0X09
mloop:
	exa
	out (c),a
	inc a
	exa
	ld a,32
	ld hl,0x8000
	rst 8
	defb 0x51,0X09
	jr nc,mloop
	
	ld b,0x3f
	ld a,0x40
	out (c),a
	xor a
	ld b,0x37
	out (c),a	
	
	ld a,15
	ld b,0x77
	out (c),a
	ld hl,0x4000
	ld de,0x0000
	ld b,h
	ld c,l
	ldir
	
	ld a,1
	ld bc,0x77f7
	out (c),a
	
	jp 0x0100
	
filename:
	defb "fuzix.bin",0
ENDPROG:
	SAVEHOB  "fuzix.$C","fuzix.C",START,ENDPROG-START
