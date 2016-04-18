;
;	    zxevo hardware support
;

            .module zxevo

            ; exported symbols
            .globl init_early
            .globl init_hardware
            .globl interrupt_handler
	    .globl platform_interrupt_all
            .globl _program_vectors
	    .globl map_kernel
	    .globl map_process
	    .globl _map_kernel
	    .globl map_process_always
	    .globl map_save
	    .globl map_restore
	    .globl _need_resched

	    ; video driver
	    .globl _vtinit

            ; exported debugging tools
            .globl _trap_monitor
            .globl outchar

            .globl _tty_inproc
            .globl unix_syscall_entry
            .globl _trap_reboot
	    .globl nmi_handler
	    .globl null_handler

	     ; debug symbols
            .globl outcharhex
            .globl outhl, outde, outbc
            .globl outnewline
            .globl outstring
            .globl outstringhex


	    .globl _slotrom
	    .globl _slotram
	    .globl _vdpport
	    .globl _infobits
	    .globl _machine_type

	    ;
	    ; vdp - we must initialize this bit early for the vt
	    ;

            .include "kernel.def"
            .include "../kernel.def"

; -----------------------------------------------------------------------------
; COMMON MEMORY BANK (0xF000 upwards)
; -----------------------------------------------------------------------------
            .area _COMMONMEM

; Ideally return to any debugger/monitor
_trap_monitor:
	    di
	    halt


_trap_reboot:
;FIXME: TODO
	    di
	    halt

_need_resched:
	    .db 0

; -----------------------------------------------------------------------------
; KERNEL MEMORY BANK (below 0xF000, only accessible when the kernel is mapped)
; -----------------------------------------------------------------------------
            .area _CODE

init_early:
	    ret

init_hardware:
    ; set up interrupt vectors for the kernel mapped low page and
          ; data area
            ld hl, #0
            push hl
            call _program_vectors
            pop hl


            im 1 			; set CPU interrupt mode
	    call _vtinit		; init the console video

            ret


;------------------------------------------------------------------------------
; COMMON MEMORY PROCEDURES FOLLOW

            .area _COMMONMEM

platform_interrupt_all:
	    ret

_program_vectors:
            ; we are called, with interrupts disabled, by both newproc() and crt0
	    ; will exit with interrupts off
            di ; just to be sure
            pop de ; temporarily store return address
            pop hl ; function argument -- base page number
            push hl ; put stack back as it was
            push de

	    ; At this point the common block has already been copied
	    call map_process

            ; write zeroes across all vectors
	    ; on MSX this is probably the wrong thing to do!!! FIXME
            ld hl, #0
            ld de, #1
            ld bc, #0x007f ; program first 0x80 bytes only
            ld (hl), #0x00
            ldir

            ; now install the interrupt vector at 0x0038
            ld a, #0xC3 ; JP instruction
            ld (0x0038), a
            ld hl, #interrupt_handler
            ld (0x0039), hl

            ; set restart vector for Fuzix system calls
            ld (0x0030), a   ;  (rst 30h is unix function call vector)
            ld hl, #unix_syscall_entry
            ld (0x0031), hl

            ld (0x0000), a   
            ld hl, #null_handler   ;   to Our Trap Handler
            ld (0x0001), hl

            ld (0x0067), a  ; Set vector for NMI
            ld hl, #nmi_handler
            ld (0x0068), hl
	    jr map_kernel

;
;	All registers preserved
;
map_process_always:
	    push hl
	    ld hl, #U_DATA__U_PAGE
	    call map_process_2
	    pop hl
	    ret
;
;	HL is the page table to use, A is eaten, HL is eaten
;
map_process:
	    ld a, h
	    or l
	    jr nz, map_process_2
;
;	Map in the kernel below the current common, go via the helper
;	so our cached copy is correct.
;
_map_kernel:
map_kernel:
	    push hl
	    ld hl, #map_kernel_data
	    call map_process_2
	    pop hl
	    ret

map_process_2:
	push bc
	push de
	push af
	ld bc,#0x37f7
	ld de, #map_table	; Write only so cache in RAM
	ld a, (hl)
	ld (de), a
	out (c), a	; Low 16K
	inc hl
	inc de
	ld a, (hl)
	ld b,#0x77
	out (c), a	; Next 16K
	ld (de), a
	inc hl
	inc de
	ld a, (hl)		; Next 16K. Leave the common for the task
	ld b,#0xb7
	out (c), a	; switcher
	ld (de), a
	pop af
	pop de
	pop bc
    ret
;
;	Restore a saved mapping. We are guaranteed that we won't switch
;	common copy between save and restore. Preserve all registers
;
map_restore:
	    push hl
	    ld hl,#map_savearea
	    call map_process_2	; Put the mapper back right
	    pop hl
	    ret
;
;	Save the current mapping.
;
map_save:   push hl
	    ld hl, (map_table)
	    ld (map_savearea), hl
	    ld hl, (map_table + 2)
	    ld (map_savearea + 2), hl
	    pop hl
	    ret

;
;	Slot mapping functions.
;
;   necessary to access memory mapped io ports used by certain devices
;   (e.g ide, sd devices)
;
;   These need to go in bank0; cannot be in the common area because
;   they do switch bank3 to access the subslot register. And neither
;   can be in bank1 or 2 because those are the ones usually used to
;   map the io ports.
;

		.area _COMMONMEM


map_table:
	    .db 0,0,0,0	
map_savearea:
	    .db 0,0,0,0
map_kernel_data:
	    .db 0,1,2,3
_slotrom:
	    .db 0
_slotram:
	    .db 0
_vdpport:
	    .dw 0
_infobits:
	    .dw 0
_machine_type:
	    .db 0

; emulator debug port for now
outchar:
	    push af
	    out (0x2F), a
	    pop af
	    ret

        .globl _plot_char
        .globl _scroll_down
        .globl _scroll_up
        .globl _cursor_on
        .globl _cursor_off
        .globl _clear_lines
        .globl _clear_across
        ;.globl _do_beep
		.area _VIDEO
_scroll_up:
	call set_vram
	ld hl,#0x01c0+64
	ld de,#0x01c0
	ld bc,#24*64
	ldir
	ld hl,#0x21c0+64
	ld de,#0x21c0
	ld bc,#24*64
	ldir
	jp ret_vram
_scroll_down:
	call set_vram
	ld hl,#0x07ff
	ld de,#0x07ff-64
	ld bc,#24*64
	lddr
	ld hl,#0x27ff
	ld de,#0x27ff-64
	ld bc,#24*64
	lddr
	jp ret_vram
xy2txt:  	;input h=x l=y	output hl=address
	LD A,#0x0e
	SRL H
	RRA
	ADD A,L
	LD L,H
	LD H,A
	XOR A
	SRL H
	RRA
	SRL H
	RRA
	ADD A,L
	LD L,A
	RET
	
_clear_across:
	call set_vram
	pop af
	pop hl
	pop bc
	push bc
	push hl
	push af
	ld b,c
	ld c,#0
	inc b
cl_ac_l1:
	dec b
	jp z,ret_vram
	push hl
	call xy2txt
	ld (hl),c
	pop hl
	inc h
	jr cl_ac_l1
	
_clear_lines:
	call set_vram
	pop af
	pop hl
	push hl
	push af
	ld b,h
	ld h,#0x00
	ld c,h
	call xy2txt
	push hl
	srl b
	rr c
	srl b
	rr c
	push bc
	call scrmemset
	pop bc
	pop hl
	ld a,#0x20
	xor h
	ld h,a
	call scrmemset
	jp ret_vram
scrmemset:
	ld (hl),#' '
	ld d,h
	ld e,l
	inc de
	ldir
	ret
	
_plot_char:
	call set_vram
	pop af
	pop hl
	pop bc
	push bc
	push hl
	push af
	call xy2txt
	ld (hl),c
	jp ret_vram
	
_cursor_on:
	call set_vram
	pop af
	pop hl
	push hl
	push af
	call xy2txt
	ld (cpos),hl
	ld a,(hl)
	ld (csave),a
	ld (hl),#'_'
	jp ret_vram
	
_cursor_off:
	call set_vram
	ld hl,(cpos)
	ld a,h
	or l
	ret z
	ld a,(csave)
	ld (hl),a
	jp ret_vram
	
_do_beep:
	ret
	
set_vram:	;0x8b87
	ld a,i
	di
	ex af,af'
	ld a,#0x04
	in a,(#0xbe)
	ld (vpg_store),a
	ld bc,#0x37f7
	ld a,#5^0xff
	out (c),a
	ret
ret_vram:
	ld a,(vpg_store)
	ld bc,#0x37f7
	out (c),a
	ex af,af'
	ret po
	ei
	ret
	
	.area _DATA
vpg_store:
	.ds 1
cpos:
	.ds 2
csave:
	.ds 1
	
	