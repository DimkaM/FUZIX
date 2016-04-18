        .module usermem

        .include "socz80.def"
        .include "../kernel.def"
        .include "kernel.def"

        ; imported symbols
        .globl _ub
        .globl page17out
        .globl page17in

        ; exported symbols
        .globl __uget
        .globl __ugetc
        .globl __ugets
        .globl __ugetw

        .globl __uput
        .globl __uputc
        .globl __uputw
        .globl __uzero

        .area _CODE

__uput:
        push ix
        ; stack has: ix, return address, source, dest, count. 
        ;                                ix+4    ix+6  ix+8
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with destination address (in userspace)
        ld e, 6(ix)
        ld d, 7(ix)
        call ugetputsetup
        ; load HL with the source address
        ld l, 4(ix) ; src address
        ld h, 5(ix)
        ; load DE with the byte count
        ld e, 8(ix) ; byte count
        ld d, 9(ix)
        call page17out
        jr ugetputret

__uputc:
        push ix
        ; stack has: ix, return address, char, dest
        ;                                ix+4  ix+6,7
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with destination address (in userspace)
        ld e, 6(ix)
        ld d, 7(ix)
        call ugetputsetup
        ld a, 4(ix)
        out (MMU_PAGE17), a
        jr ugetputret

__uputw:
        push ix
        ; stack has: ix, return address, word, dest
        ;                                ix+4  ix+6
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with destination address (in userspace)
        ld e, 6(ix)
        ld d, 7(ix)
        call ugetputsetup
        ld a, 4(ix)
        out (MMU_PAGE17), a
        ld a, 5(ix)
        out (MMU_PAGE17), a
        jr ugetputret

__ugetc:
        push ix
        ; stack has: ix, return address, source
        ;                                ix+4 
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with source address (in userspace)
        ld e, 4(ix)
        ld d, 5(ix)
        call ugetputsetup
        in a, (MMU_PAGE17)
        ld l, a
        ld h, #0
        jr ugetputret

__ugetw:
        push ix
        ; stack has: ix, return address, source
        ;                                ix+4 
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with source address (in userspace)
        ld e, 4(ix)
        ld d, 5(ix)
        call ugetputsetup
        in a, (MMU_PAGE17)
        ld l, a
        in a, (MMU_PAGE17)
        ld h, a
ugetputret: ; this is shared with the other routines, above and below
        pop af
        pop ix
        ret po
        ei
        ret

__uget:
        push ix
        ; stack has: ix, return address, source, dest, count. 
        ;                                ix+4    ix+6  ix+8
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with source address (in userspace)
        ld e, 4(ix)
        ld d, 5(ix)
        call ugetputsetup
        ; load HL with destination address
        ld l, 6(ix)
        ld h, 7(ix)
        ; load DE with the byte count
        ld e, 8(ix) ; byte count
        ld d, 9(ix)
        call page17in
        jr ugetputret

ugetputsetup:
        ; compute 32-bit dest address based on process MMU page and userspace address in DE
        ld hl, (U_DATA__U_PAGE) ; load 4K page address

        ; we shift HL 4 bits to the left (would need to handle overflow for future hardware with >16MB RAM)
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, hl

        ld a, d         ; high byte of userspace address
        add a, l        ; add with L
        jr nc, ugetputsetupnoadd
        inc h        ; handle overflow into H
ugetputsetupnoadd:
        ld l, a      ; update L

        ; now configure the MMU page17 pointer
        ld a, #MMU_SELECT_PAGE17
        out (MMU_SELECT), a
        xor a
        out (MMU_PTR_VAL0), a
        ld a, h
        out (MMU_PTR_VAL1), a
        ld a, l
        out (MMU_PTR_VAL2), a
        ld a, e        ; low byte of userspace address
        out (MMU_PTR_VAL3), a
        ret

__uzero:
        push ix
        ; stack has: ix, return address, dest, count. 
        ;                                ix+4  ix+6
        ld ix, #0
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with dest address (in userspace)
        ld e, 4(ix)
        ld d, 5(ix)
        call ugetputsetup
        ; load byte count
        ld e, 6(ix)
        ld d, 7(ix)
        ; write 0s to page17 for DE bytes
        ld bc, #MMU_PAGE17 ; also loads B=0
        jr checkzero ; just to be safe against DE=0
nextbyte:
        out (c), b ; write zero
        dec de
checkzero:
        ld a, d
        or e
        jr nz, nextbyte
        jr ugetputret

__ugets:
        push ix
        ld ix, #0   ; load ix with stack pointer
        add ix, sp
        ; store interrupt state, disable interrupts
        ld a, i
        di
        push af
        ; load DE with source address (in userspace)
        ld e, 4(ix)
        ld d, 5(ix)
        call ugetputsetup
        ; load HL with destination address
        ld l, 6(ix)
        ld h, 7(ix)
        ; load DE with the byte count
        ld e, 8(ix) ; byte count
        ld d, 9(ix)
        ; read from page17, write to HL for AT MOST DE bytes or until 0 byte found
        ld bc, #MMU_PAGE17 ; also loads B=0
        jr checkzeros
nextbytes:
        in a, (c) ; read from page17
        ld (hl), a ; write to string
        or a
        jr z, getsdone
        inc hl ; advance pointer
        dec de ; decrement remaining byte counter
checkzeros:
        ld a, d
        or e
        jr nz, nextbytes
        ; ah - we've run out of space
        dec hl ; back it up
        ld (hl), #0 ; terminate string
        ; leave HL as nonzero
        jp ugetputret ; too far for a jr
getsdone:
        ld hl, #0 ; indicate success
        jp ugetputret ; too far for a jr
