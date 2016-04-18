;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.4 #9358 (Linux)
; This file was generated Sun Apr 17 23:22:42 2016
;--------------------------------------------------------
	.module devtty
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _decode
	.globl _get_scan
	.globl _vt_inproc
	.globl _vtoutput
	.globl _ttyinq
	.globl _cursorpos
	.globl _vtattr_cap
	.globl _tbuf2
	.globl _tbuf1
	.globl _stand_sh
	.globl _stand
	.globl _unmod
	.globl _scodes
	.globl _kputchar
	.globl _tty_writeready
	.globl _tty_putc
	.globl _tty_carrier
	.globl _tty_setup
	.globl _kbd_interrupt
	.globl _tty_sleeping
	.globl _vtattr_notify
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_UART_DAT	=	0xf8ef
_UART_DLL	=	0xf8ef
_UART_DLM	=	0xf9ef
_UART_FCR	=	0xfaef
_UART_LCR	=	0xfbef
_UART_LSR	=	0xfdef
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_tbuf1::
	.ds 132
_tbuf2::
	.ds 132
_vtattr_cap::
	.ds 1
_cursorpos::
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_ttyinq::
	.ds 36
_is_up:
	.ds 1
_shift:
	.ds 1
_mode:
	.ds 1
_alt:
	.ds 1
_cur_key:
	.ds 1
_inv:
	.ds 1
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
;devtty.c:34: void kputchar(char c)
;	---------------------------------
; Function kputchar
; ---------------------------------
_kputchar::
;devtty.c:37: if (c == '\n')
	ld	iy,#2
	add	iy,sp
	ld	h,0 (iy)
	ld	a,0 (iy)
	rla
	sbc	a, a
	ld	l,a
	ld	a,h
	sub	a,#0x0A
	jr	NZ,00102$
	or	a,l
	jr	NZ,00102$
;devtty.c:38: tty_putc(1, '\r');
	ld	hl,#0x0D01
	push	hl
	call	_tty_putc
	pop	af
00102$:
;devtty.c:39: tty_putc(1, c);
	ld	hl, #2+0
	add	hl, sp
	ld	d, (hl)
	ld	e,#0x01
	push	de
	call	_tty_putc
	pop	af
	ret
;devtty.c:43: ttyready_t tty_writeready(uint8_t minor)
;	---------------------------------
; Function tty_writeready
; ---------------------------------
_tty_writeready::
;devtty.c:46: return TTY_READY_NOW;
	ld	l,#0x01
	ret
;devtty.c:49: void tty_putc(uint8_t minor, unsigned char c)
;	---------------------------------
; Function tty_putc
; ---------------------------------
_tty_putc::
;devtty.c:52: if(minor==1) vtoutput(&c, 1);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	dec	a
	jr	NZ,00102$
	ld	hl,#0x0003
	add	hl,sp
	ld	bc,#0x0001
	push	bc
	push	hl
	call	_vtoutput
	pop	af
	pop	af
	ret
00102$:
;devtty.c:53: else UART_DAT = c;
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	ld	bc,#_UART_DAT
	out	(c),a
	ret
;devtty.c:56: int tty_carrier(uint8_t minor)
;	---------------------------------
; Function tty_carrier
; ---------------------------------
_tty_carrier::
;devtty.c:59: return 1;
	ld	hl,#0x0001
	ret
;devtty.c:62: void tty_setup(uint8_t minor)
;	---------------------------------
; Function tty_setup
; ---------------------------------
_tty_setup::
;devtty.c:67: ttydata[1].termios.c_cc[VERASE] = 127;
	ld	hl,#_ttydata + 38
	ld	(hl),#0x7F
;devtty.c:68: ttydata[1].termios.c_cc[VSTOP] = KEY_STOP;
	ld	hl,#_ttydata + 43
	ld	(hl),#0x03
;devtty.c:69: ttydata[1].termios.c_cc[VSTART] = KEY_STOP;
	ld	hl,#_ttydata + 42
	ld	(hl),#0x03
	ret
;devtty.c:107: unsigned char get_scan(void) __naked
;	---------------------------------
; Function get_scan
; ---------------------------------
_get_scan::
;devtty.c:126: __endasm;
	ld bc,#0xdef7
	ld a,#0xf0
	out (c),a
	ld b,#0xbe
	in a,(c)
	ld l,a
	inc a
	ret nz
	ld b,#0xde
	ld a,#0x0c
	out (c),a
	ld b,#0xbe
	ld a,#1
	out (c),a
	xor a
	ret
;devtty.c:128: unsigned char decode(unsigned char sc) {
;	---------------------------------
; Function decode
; ---------------------------------
_decode::
	call	___sdcc_enter_ix
	push	af
	dec	sp
;devtty.c:130: switch (sc) {
	ld	a,4 (ix)
	sub	a, #0x11
	jr	NZ,00218$
	ld	a,#0x01
	jr	00219$
00218$:
	xor	a,a
00219$:
	ld	-3 (ix),a
	ld	a,4 (ix)
	sub	a, #0x12
	jr	NZ,00220$
	ld	a,#0x01
	jr	00221$
00220$:
	xor	a,a
00221$:
	ld	d,a
	ld	a,4 (ix)
	sub	a, #0x14
	jr	NZ,00222$
	ld	a,#0x01
	jr	00223$
00222$:
	xor	a,a
00223$:
	ld	-1 (ix),a
	ld	a,4 (ix)
	sub	a, #0x59
	jr	NZ,00224$
	ld	a,#0x01
	jr	00225$
00224$:
	xor	a,a
00225$:
	ld	e,a
	ld	a,4 (ix)
	sub	a, #0xE0
	jr	NZ,00226$
	ld	a,#0x01
	jr	00227$
00226$:
	xor	a,a
00227$:
	ld	c,a
;devtty.c:129: if (!(mode&KEY_MODE_UP)){
	ld	hl,#_mode+0
	bit	4, (hl)
	jp	NZ,00134$
;devtty.c:130: switch (sc) {
	ld	a,-3 (ix)
	or	a,a
	jr	NZ,00104$
	or	a,d
	jr	NZ,00103$
	ld	a,-1 (ix)
	or	a,a
	jr	NZ,00105$
	or	a,e
	jr	NZ,00103$
	or	a,c
	jp	NZ,00135$
	ld	a,4 (ix)
	sub	a, #0xF0
	jr	NZ,00107$
;devtty.c:132: mode|=KEY_MODE_UP;
	ld	a,(#_mode + 0)
	set	4, a
	ld	(#_mode + 0),a
;devtty.c:133: break;
	jp	00135$
;devtty.c:135: case 0x59 :// Right SHIFT
00103$:
;devtty.c:136: mode|=KEY_MODE_SHIFT;
	ld	a,(#_mode + 0)
	set	1, a
;devtty.c:137: mode&=~KEY_MODE_E0;
	ld	(#_mode + 0),a
	and	a, #0xDF
	ld	(#_mode + 0),a
;devtty.c:138: break;
	jp	00135$
;devtty.c:139: case 0x11 :// Alt  
00104$:
;devtty.c:140: mode=(mode|KEY_MODE_ALT)&(~KEY_MODE_E0);
	ld	a,(#_mode + 0)
	set	2, a
	and	a, #0xDF
	ld	(#_mode + 0),a
;devtty.c:141: break;
	jp	00135$
;devtty.c:142: case 0x14 :// Ctrl  
00105$:
;devtty.c:143: mode=(mode|KEY_MODE_CTRL)&(~KEY_MODE_E0);
	ld	a,(#_mode + 0)
	set	3, a
	and	a, #0xDF
	ld	(#_mode + 0),a
;devtty.c:144: break;
	jp	00135$
;devtty.c:148: default:
00107$:
;devtty.c:153: sc=scodes[sc];
	ld	de,#_scodes+0
	ld	l,4 (ix)
	ld	h,#0x00
	add	hl,de
	ld	a,(hl)
;devtty.c:154: if(!sc) return 0;
	ld	4 (ix), a
	or	a,a
	jr	NZ,00114$
	ld	l,a
	jp	00136$
00114$:
;devtty.c:155: else if (sc>65) return sc;
	ld	a,#0x41
	sub	a, 4 (ix)
	jr	NC,00111$
	ld	l,4 (ix)
	jp	00136$
00111$:
;devtty.c:156: else if (sc>47) return unmod[sc-48];
	ld	a,#0x2F
	sub	a, 4 (ix)
	jr	NC,00115$
	ld	a,4 (ix)
	add	a,#0xD0
	ld	e,a
	ld	hl,#_unmod
	ld	d,#0x00
	add	hl, de
	ld	l,(hl)
	jp	00136$
00115$:
;devtty.c:158: switch(mode&(KEY_MODE_RUS|KEY_MODE_SHIFT)){
	ld	a,(#_mode + 0)
	and	a, #0x03
	ld	c,a
;devtty.c:160: if(sc<27)return (sc+'a'-1);
	ld	a,4 (ix)
	sub	a, #0x1B
	ld	a,#0x00
	rla
	ld	e,a
	ld	l,4 (ix)
;devtty.c:162: return stand[sc-27];
	ld	a,4 (ix)
	add	a,#0xE5
	ld	-2 (ix),a
;devtty.c:158: switch(mode&(KEY_MODE_RUS|KEY_MODE_SHIFT)){
	ld	a,c
	or	a, a
	jr	Z,00116$
	ld	a,c
	sub	a, #0x02
	jr	Z,00122$
	jp	00135$
;devtty.c:159: case KEY_MODE_NONE :
00116$:
;devtty.c:160: if(sc<27)return (sc+'a'-1);
	ld	a,e
	or	a, a
	jr	Z,00120$
	ld	c, #0x60
	add	hl, bc
	jp	00136$
00120$:
;devtty.c:161: else if (sc>37) return (sc+'0'-38);
	ld	a,#0x25
	sub	a, 4 (ix)
	jr	NC,00121$
	ld	c, #0x0A
	add	hl, bc
	jp	00136$
00121$:
;devtty.c:162: return stand[sc-27];
	ld	a,#<(_stand)
	add	a, -2 (ix)
	ld	l,a
	ld	a,#>(_stand)
	adc	a, #0x00
	ld	h,a
	ld	l,(hl)
	jr	00136$
;devtty.c:163: case KEY_MODE_SHIFT :
00122$:
;devtty.c:164: if(sc<27)return (sc+'A'-1);
	ld	a,e
	or	a, a
	jr	Z,00124$
	ld	c, #0x40
	add	hl, bc
	jr	00136$
00124$:
;devtty.c:165: return stand_sh[sc-27];
	ld	hl,#_stand_sh+0
	ld	e,-2 (ix)
	ld	d,#0x00
	add	hl,de
	ld	l,(hl)
	jr	00136$
;devtty.c:167: }
00134$:
;devtty.c:137: mode&=~KEY_MODE_E0;
	ld	hl,#_mode + 0
	ld	b, (hl)
;devtty.c:170: switch (sc) {
	ld	a,-3 (ix)
	or	a, a
	jr	NZ,00130$
;devtty.c:172: mode&=~KEY_MODE_SHIFT;
	ld	h,b
	res	1, h
;devtty.c:170: switch (sc) {
	ld	a,d
	or	a, a
	jr	NZ,00127$
	ld	a,-1 (ix)
	or	a,a
	jr	NZ,00131$
	or	a,e
	jr	NZ,00129$
	or	a,c
	jr	NZ,00128$
	jr	00132$
;devtty.c:171: case 0x12 :// Left SHIFT
00127$:
;devtty.c:172: mode&=~KEY_MODE_SHIFT;
	ld	iy,#_mode
	ld	0 (iy),h
;devtty.c:173: break;
	jr	00132$
;devtty.c:174: case 0xe0 :
00128$:
;devtty.c:175: return 0;
	ld	l,#0x00
	jr	00136$
;devtty.c:176: case 0x59 :// Right SHIFT
00129$:
;devtty.c:177: mode&=~KEY_MODE_SHIFT;
	ld	iy,#_mode
	ld	0 (iy),h
;devtty.c:178: break;
	jr	00132$
;devtty.c:179: case 0x11 :// Alt 
00130$:
;devtty.c:180: mode&=~KEY_MODE_ALT;
	ld	a,b
	and	a, #0xFB
	ld	(#_mode + 0),a
;devtty.c:181: break;
	jr	00132$
;devtty.c:182: case 0x14 :// Ctrl 
00131$:
;devtty.c:183: mode&=~KEY_MODE_CTRL;
	ld	a,b
	and	a, #0xF7
	ld	(#_mode + 0),a
;devtty.c:185: }
00132$:
;devtty.c:186: mode&=~(KEY_MODE_UP|KEY_MODE_E0);// Two 0xF0 in a row not allowed
	ld	a,(#_mode + 0)
	and	a, #0xCF
	ld	(#_mode + 0),a
00135$:
;devtty.c:188: return 0;
	ld	l,#0x00
00136$:
	ld	sp, ix
	pop	ix
	ret
_scodes:
	.db #0x00	; 0
	.db #0xB9	; 185
	.db #0x00	; 0
	.db #0xB5	; 181
	.db #0xB3	; 179
	.db #0xB1	; 177
	.db #0xB2	; 178
	.db #0x4F	; 79	'O'
	.db #0x00	; 0
	.db #0xB0	; 176
	.db #0xB8	; 184
	.db #0xB6	; 182
	.db #0xB4	; 180
	.db #0x43	; 67	'C'
	.db #0x21	; 33
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0x27	; 39
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1A	; 26
	.db #0x13	; 19
	.db #0x01	; 1
	.db #0x17	; 23
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x18	; 24
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x2A	; 42
	.db #0x29	; 41
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x16	; 22
	.db #0x06	; 6
	.db #0x14	; 20
	.db #0x12	; 18
	.db #0x2B	; 43
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0E	; 14
	.db #0x02	; 2
	.db #0x08	; 8
	.db #0x07	; 7
	.db #0x19	; 25
	.db #0x2C	; 44
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0D	; 13
	.db #0x0A	; 10
	.db #0x15	; 21
	.db #0x2D	; 45
	.db #0x2E	; 46
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1F	; 31
	.db #0x0B	; 11
	.db #0x09	; 9
	.db #0x0F	; 15
	.db #0x26	; 38
	.db #0x2F	; 47
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x23	; 35
	.db #0x0C	; 12
	.db #0x1D	; 29
	.db #0x10	; 16
	.db #0x24	; 36
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1E	; 30
	.db #0x00	; 0
	.db #0x1B	; 27
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x31	; 49	'1'
	.db #0x1C	; 28
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7F	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0xC4	; 196
	.db #0x39	; 57	'9'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x32	; 50	'2'
	.db #0x7F	; 127
	.db #0xC2	; 194
	.db #0x37	; 55	'7'
	.db #0xC3	; 195
	.db #0xC1	; 193
	.db #0x42	; 66	'B'
	.db #0x00	; 0
	.db #0x4E	; 78	'N'
	.db #0x40	; 64
	.db #0x35	; 53	'5'
	.db #0x3F	; 63
	.db #0x3E	; 62
	.db #0x3B	; 59
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xB7	; 183
_unmod:
	.ascii " "
	.db 0x0A
	.ascii "0123456789 /*-+."
	.db 0x00
_stand:
	.ascii "[];',.`"
	.db 0x5C
	.ascii "/-="
	.db 0x00
_stand_sh:
	.ascii "{}:"
	.db 0x22
	.ascii "<>~|?_+)!@#$%^&*("
	.db 0x00
;devtty.c:191: void kbd_interrupt(void)
;	---------------------------------
; Function kbd_interrupt
; ---------------------------------
_kbd_interrupt::
;devtty.c:193: if(cur_key=get_scan()) 
	call	_get_scan
	ld	a,l
	ld	(#_cur_key + 0),a
	or	a, a
	jr	Z,00104$
;devtty.c:194: if(cur_key=decode(cur_key)){		
	ld	a,(_cur_key)
	push	af
	inc	sp
	call	_decode
	inc	sp
	ld	a,l
	ld	(#_cur_key + 0),a
	or	a, a
	jr	Z,00104$
;devtty.c:195: vt_inproc(1,(mode&KEY_MODE_CTRL)?(cur_key&0x1f):cur_key);
	ld	hl,#_mode+0
	bit	3, (hl)
	jr	Z,00109$
	ld	a,(#_cur_key + 0)
	and	a, #0x1F
	jr	00110$
00109$:
	ld	a,(#_cur_key + 0)
00110$:
	ld	d,a
	ld	e,#0x01
	push	de
	call	_vt_inproc
	pop	af
00104$:
;devtty.c:197: if (UART_LSR&1) vt_inproc(2,UART_DAT);
	ld	a,#>(_UART_LSR)
	in	a,(#<(_UART_LSR))
	rrca
	ret	NC
	ld	a,#>(_UART_DAT)
	in	a,(#<(_UART_DAT))
	ld	d,a
	ld	e,#0x02
	push	de
	call	_vt_inproc
	pop	af
	ret
;devtty.c:201: void tty_sleeping(uint8_t minor)
;	---------------------------------
; Function tty_sleeping
; ---------------------------------
_tty_sleeping::
;devtty.c:203: minor;
	ret
;devtty.c:206: void vtattr_notify(void)
;	---------------------------------
; Function vtattr_notify
; ---------------------------------
_vtattr_notify::
;devtty.c:208: }
	ret
	.area _CODE
	.area _CONST
	.area _INITIALIZER
__xinit__ttyinq:
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw _tbuf1
	.dw _tbuf1
	.dw _tbuf1
	.dw #0x0084
	.dw #0x0000
	.dw #0x0042
	.dw _tbuf2
	.dw _tbuf2
	.dw _tbuf2
	.dw #0x0084
	.dw #0x0000
	.dw #0x0042
__xinit__is_up:
	.db #0x00	; 0
__xinit__shift:
	.db #0x00	; 0
__xinit__mode:
	.db #0x00	; 0
__xinit__alt:
	.db #0x00	; 0
__xinit__cur_key:
	.db #0x00	; 0
__xinit__inv:
	.db #0x00	; 0
	.area _CABS (ABS)
