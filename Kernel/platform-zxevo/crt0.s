	        ; Ordering of segments for the linker.
	        ; WRS: Note we list all our segments here, even though
	        ; we don't use them all, because their ordering is set
	        ; when they are first seen.	
	        .area _CODE
	        .area _CODE2
		.area _VIDEO
	        .area _CONST
	        .area _INITIALIZED
	        .area _DATA
	        .area _BSEG
	        .area _BSS
	        .area _HEAP
	        ; note that areas below here may be overwritten by the heap at runtime, so
	        ; put initialisation stuff in here
	        .area _INITIALIZER
	        .area _GSINIT
	        .area _GSFINAL
	        .area _COMMONMEM
		.area _DISCARD

        	; imported symbols
        	.globl _fuzix_main
	        .globl init_early
	        .globl init_hardware
	        .globl s__DATA
	        .globl l__DATA
	        .globl s__DISCARD
	        .globl l__DISCARD
	        .globl s__COMMONMEM
	        .globl l__COMMONMEM
		.globl s__INITIALIZER
	        .globl kstack_top
		.globl _ramsize
		.globl _procmem
		.globl _msxmaps

		; Just for the benefit of the map file
		.globl start
		.globl _slotram
		.globl _slotrom
		.globl _vdpport
		.globl _infobits
		.globl _machine_type

	        ; startup code @0x100
	        .area _CODE

		.include "zxevo.def"

;
; Execution begins with us correctly mapped and at 0x0x100
;
; We assume here that the kernel packs below 48K for now we've got a few
; KBytes free but revisit as needed
;
	.ds 256
start:
		di
		ld b,#0xff
		ld a,#0x40
		out (c),a
		ld b,#0xf7
		ld a,#0x03
		out (c),a
		xor a
		out (0x57),a
        ld sp, #kstack_top
		; move the common memory where it belongs
		ld hl, #s__DATA
		ld de, #s__COMMONMEM
		ld bc, #l__COMMONMEM
		ldir

		; move the discardable memory where it belongs
		ld de, #s__DISCARD
		ld bc, #l__DISCARD
		ldir

		; then zero the data area
		ld hl, #s__DATA
		ld de, #s__DATA + 1
		ld bc, #l__DATA - 1
		ld (hl), #0
		ldir
		ld hl,#4096
		ld (_ramsize), hl
		ld hl,#4096-128
		ld (_procmem), hl
		call init_early
		call init_hardware
		call _fuzix_main
		di
stop:		halt
		jr stop

