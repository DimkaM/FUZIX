#ifndef _DEVTTY_H
#define _DEVTTY_H

extern void tty_interrupt(void);
extern void kbd_interrupt(void);
extern int trstty_close(uint8_t minor);

#endif
