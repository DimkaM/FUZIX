#include <kernel.h>
#include <kdata.h>
#include <printf.h>
#include <stdbool.h>
#include <devtty.h>
#include <vt.h>
#include <tty.h>

#undef  DEBUG			/* UNdefine to delete debug code sequences */


char tbuf1[TTYSIZ];
char tbuf2[TTYSIZ];

__sfr __banked __at 0xF8EF UART_DAT;
__sfr __banked __at 0xF8EF UART_DLL;
__sfr __banked __at 0xF9EF UART_DLM;
__sfr __banked __at 0xFAEF UART_FCR;
__sfr __banked __at 0xFBEF UART_LCR;
__sfr __banked __at 0xFDEF UART_LSR;

uint8_t vtattr_cap;

struct s_queue ttyinq[NUM_DEV_TTY + 1] = {	/* ttyinq[0] is never used */
	{NULL, NULL, NULL, 0, 0, 0},
	{tbuf1, tbuf1, tbuf1, TTYSIZ, 0, TTYSIZ / 2},
	{tbuf2, tbuf2, tbuf2, TTYSIZ, 0, TTYSIZ / 2}
};

/* tty1 is the screen tty2 is the debug port */

/* Output for the system console (kprintf etc) */
void kputchar(char c)
{
	/* Debug port for bringup */
	if (c == '\n')
		tty_putc(1, '\r');
	tty_putc(1, c);
}

/* Both console and debug port are always ready */
ttyready_t tty_writeready(uint8_t minor)
{
	minor;
	return TTY_READY_NOW;
}

void tty_putc(uint8_t minor, unsigned char c)
{
	//minor;
	if(minor==1) vtoutput(&c, 1);
	else UART_DAT = c;
}

int tty_carrier(uint8_t minor)
{
	minor;
	return 1;
}

void tty_setup(uint8_t minor)
{
	minor;

	/* setup termios to use msx keys */
	ttydata[1].termios.c_cc[VERASE] = 127;
	ttydata[1].termios.c_cc[VSTOP] = KEY_STOP;
	ttydata[1].termios.c_cc[VSTART] = KEY_STOP;
}

//************************keyboard module*********************
const unsigned char scodes[] = {
//	0x0 0x1 0x2 0x3 0x4 0x5 0x6 0x7 0x8 0x9 0xa 0xb 0xc 0xd 0xe 0xf
//	  0, F9,  0, F5, F3, F1, F2,F12,  0,F10, F8, F6, F4,TAB,'`',  0,
	  0, KEY_F9,  0, KEY_F5, KEY_F3, KEY_F1, KEY_F2, 79,  0, KEY_F10, KEY_F8, KEY_F6, KEY_F4, 67, 33,  0, //0x00
//	  0,  0,  0,  0,  0,'q','1',  0,  0,  0,'z','s','a','w','2',  0, 
	  0,  0,  0,  0,  0, 17, 39,  0,  0,  0, 26, 19,  1, 23, 40,  0, //0x10
//	  0,'c','x','d','e','4','3',  0,  0,' ','v','f','t','r','5',  0, 
	  0,  3, 24,  4,  5, 42, 41,  0,  0, 48, 22,  6, 20, 18, 43,  0, //0x20
//	  0,'n','b','h','g','y','6',  0,  0,  0,'m','j','u','7','8',  0, 
	  0, 14,  2,  8,  7, 25, 44,  0,  0,  0, 13, 10, 21, 45, 46,  0, //0x30
//	  0,',','k','i','o','0','9',  0,  0,'.','/','l',';','p','-',  0, 
	  0, 31, 11,  9, 15, 38, 47,  0,  0, 32, 35, 12, 29, 16, 36,  0, //0x40
//	  0,  0,  ',  0,'[','=',  0,  0,  0,  0,ENT,']',  0,  \,  0,  0,
	  0,  0, 30,  0, 27, 37,  0,  0,  0,  0, 49, 28,  0, 34,  0,  0, //0x50
//	  0,  0,  0,  0,  0,  0, BS,  0,  0,'1',  0,'4','7',  0,  0,  0,
	  0,  0,  0,  0,  0,  0,127,  0,  0, 51,  0, KEY_LEFT, 57,  0,  0,  0, //0x60
//	'0','.','2','5','6','8',ESC,  0,F11,'+','3','-','*','9',  0,  0,
	 50, KEY_DEL, KEY_DOWN, 55, KEY_RIGHT, KEY_UP, 66,  0, 78, 64, 53, 63, 62, 59,  0,  0, //0x70
//	  0,  0,  0, F7		 								
	  0,  0,  0, KEY_F7};	                      
const unsigned char unmod[] = " \n0123456789 /*-+.";
const unsigned char stand[] = "[];\',.`\\/-="; 
const unsigned char stand_sh[] = "{}:\"<>~|?_+)!@#$%^&*(";
static unsigned char is_up=0, shift = 0, mode = 0, alt=0;
#define KEY_MODE_NONE   0x00
#define KEY_MODE_RUS   0x01
#define KEY_MODE_SHIFT   0x02
#define KEY_MODE_ALT   0x04
#define KEY_MODE_CTRL   0x08
#define KEY_MODE_UP      0x10
#define KEY_MODE_E0      0x20
static unsigned char cur_key=0;
static unsigned char inv=0;
//__sfr __banked __at 0x123 IoPort;
unsigned char get_scan(void) __naked
{
  __asm
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
  __endasm;
}
unsigned char decode(unsigned char sc) {
      if (!(mode&KEY_MODE_UP)){
         switch (sc) {
         case 0xF0 :// The up-key identifier
            mode|=KEY_MODE_UP;
            break;
         case 0x12 :// Left SHIFT 
         case 0x59 :// Right SHIFT
            mode|=KEY_MODE_SHIFT;
            mode&=~KEY_MODE_E0;
            break;
         case 0x11 :// Alt  
            mode=(mode|KEY_MODE_ALT)&(~KEY_MODE_E0);
            break;
         case 0x14 :// Ctrl  
            mode=(mode|KEY_MODE_CTRL)&(~KEY_MODE_E0);
            break;
         case 0xe0 :
            //mode|=KEY_MODE_E0;
            break;
         default:
            //if(mode&KEY_MODE_E0){
            //   mode&=~KEY_MODE_E0;
            //   return 0;//0x0100|sc;
            //}
            sc=scodes[sc];
            if(!sc) return 0;
            else if (sc>65) return sc;
            else if (sc>47) return unmod[sc-48];
            //sc--;
            switch(mode&(KEY_MODE_RUS|KEY_MODE_SHIFT)){
               case KEY_MODE_NONE :
                  if(sc<27)return (sc+'a'-1);
                  else if (sc>37) return (sc+'0'-38);
                  return stand[sc-27];
               case KEY_MODE_SHIFT :
                  if(sc<27)return (sc+'A'-1);
                  return stand_sh[sc-27];
            }
         }
   }
   else {
      switch (sc) {
         case 0x12 :// Left SHIFT
            mode&=~KEY_MODE_SHIFT;
            break;
         case 0xe0 :
            return 0;
         case 0x59 :// Right SHIFT
            mode&=~KEY_MODE_SHIFT;
            break;
         case 0x11 :// Alt 
            mode&=~KEY_MODE_ALT;
            break;
         case 0x14 :// Ctrl 
            mode&=~KEY_MODE_CTRL;
            break;
      }
      mode&=~(KEY_MODE_UP|KEY_MODE_E0);// Two 0xF0 in a row not allowed
   }
   return 0;
}                       

void kbd_interrupt(void)
{
    if(cur_key=get_scan()) 
		if(cur_key=decode(cur_key)){		
			vt_inproc(1,(mode&KEY_MODE_CTRL)?(cur_key&0x1f):cur_key);
		}
	if (UART_LSR&1) vt_inproc(2,UART_DAT);
	//if(ch) vt_inproc(1,ch);
}

void tty_sleeping(uint8_t minor)
{
    minor;
}

void vtattr_notify(void)
{
}
/* This is used by the vt asm code, but needs to live in the kernel */
uint16_t cursorpos;

