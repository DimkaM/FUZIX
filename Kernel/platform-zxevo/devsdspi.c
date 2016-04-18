/*
 *	SPI glue for the SocZ80. Based on Will Sowerbutts's UZI180 for SocZ80
 *	and his implementation for the N8VEM Mark 4
 */

#include <kernel.h>
#include <kdata.h>
#include <printf.h>
#include <timer.h>
#include <stdbool.h>
#include "config.h"
#include <blkdev.h>

#define CT_BLOCK 0x80 
#define CMD12   0x4C   /* STOP_TRANSMISSION */
#define CMD18   0x52   /* READ_MULTIPLE_BLOCK */
#define CMD25   0x59   /* WRITE_MULTIPLE_BLOCK */

void sd_spi_clock(bool go_fast)
{
	go_fast;
}

void sd_spi_raise_cs(void) __naked
{
  __asm
	ld a,#3
	ld bc,#0x8057
	out (c),a
	xor a
	dec b
	out (c),a
	ret
  __endasm;
}

void sd_spi_lower_cs(void) __naked
{
  __asm
	ld bc,#0x8057
	ld a,#1
	out (c),a
	ret
  __endasm;
}

void sd_spi_transmit_byte(unsigned char byte) __naked
{
	byte;
  __asm
	pop bc
	pop hl
	push hl
	push bc
	ld bc,#0x0057
	out(c),l
	ret
  __endasm;
}

uint8_t sd_spi_receive_byte(void) __naked
{
  __asm 
	ld bc,#0x0057
	in l,(c)
	ret
  __endasm;
}

void sdspi_IN_OOUT(void) __naked
{
  __asm 
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
  __endasm;
}
void sdspi_OUT_COM(void) __naked
{
  __asm 
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
    OUT (C),A    ;пишем пустой CRC7 и стоповый бит
    RET
  __endasm;
}

uint8_t devsd_transfer_sector(void) __naked
{
  __asm 
	call _sd_spi_lower_cs
	ld hl,#(_blk_op+11)
	ld a,(hl)
	or a
	push af
	ld a,#CMD18
	jr nz,issdread
	ld a,#CMD25
issdread:
	ld b,#0
	out (c),a
	ld hl,#(_blk_op+4)	;тип карты
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)
	and #CT_BLOCK
	push af
	ld hl,#(_blk_op+6)	;Читаем номер сектора
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
    EX DE,HL    ;при сброшенном бите соответственно
    ADD HL,HL    ;умножаем номер сектора на 512 (0x200)
    EX DE,HL
    ADC HL,HL
    LD H,L
    LD L,D
    LD D,E
    LD E,#0
SECN200:	
    OUT (C),H    ;пишем номер сектора от старшего
    NOP
    OUT (C),L
    NOP
    OUT (C),D
    NOP
    OUT (C),E    ;до младшего байта
    LD A,#0xFF
    OUT (C),A    ;пишем пустой CRC7 и стоповый бит
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
    JR NZ,issdreadloop    ;ждем маркер готовности 0xFE для наЧала Чтения
	call _sd_spi_receive_sector
    LD A,#CMD12    ;по оконЧании Чтения даем команду карте <СТОП>
    CALL _sdspi_OUT_COM    
sdendtransm:
    CALL _sdspi_IN_OOUT
    INC A
    JR NZ,sdendtransm
	ld l,#1
	jp _sd_spi_raise_cs
  __endasm;
}

COMMON_MEMORY

bool sd_spi_receive_sector(void) __naked
{
  __asm
    ld a, (_blk_op+BLKPARAM_IS_USER_OFFSET);
    ld hl, (_blk_op+BLKPARAM_ADDR_OFFSET);
    or a	; Set the Z flag up and save it, dont do it twice
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
  __endasm;
}

bool sd_spi_transmit_sector(void) __naked
{
  __asm
    ld a, (_blk_op+BLKPARAM_IS_USER_OFFSET)
    ld hl, (_blk_op+BLKPARAM_ADDR_OFFSET)
    or a	; Set the Z flag up and save it, dont do it twice
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
  __endasm;
}
