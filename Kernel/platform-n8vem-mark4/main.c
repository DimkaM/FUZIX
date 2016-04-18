#include <kernel.h>
#include <kdata.h>
#include <printf.h>
#include <devtty.h>
#include "config.h"
#include <z180.h>

uint16_t ramtop = PROGTOP;
extern unsigned char irqvector;

void z180_timer_interrupt(void)
{
    unsigned char a;

    /* we have to read both of these registers in order to reset the timer */
    a = TIME_TMDR0L;
    a = TIME_TCR;

#ifdef CONFIG_PROPIO2
    /* The PropIO2 does not have an interrupt on keypress. */
    tty_poll_propio2();
#endif

    timer_interrupt();
}

void platform_idle(void)
{
    /* Let's go to sleep while we wait for something to interrupt us;
     * Makes the Mark IV's run LED go red, which amuses me greatly. */
    __asm
        halt
    __endasm;
}

void platform_interrupt(void)
{
    switch(irqvector){
        case Z180_INT_TIMER0:
            z180_timer_interrupt(); 
            return;
        case Z180_INT_ASCI0:
            tty_pollirq_asci0();
            return;
        case Z180_INT_ASCI1:
            tty_pollirq_asci1();
            return;
        default:
            return;
    }
}
