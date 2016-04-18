#include <kernel.h>
#include <timer.h>
#include <kdata.h>
#include <printf.h>
#include <devtty.h>

uint16_t msxmaps;

void platform_idle(void)
{
    __asm
    halt
    __endasm;
}

void do_beep(void)
{
}

/*
 * Map handling: We have flexible paging. Each map table consists of a set
 * of pages with the last page repeated to fill any holes.
 */

void pagemap_init(void)
{
    unsigned char i;
    /* 0/1/2 kernel, 3 initial common, 4+ to use */
    for (i = 4; i < MAX_MAPS ; i++)
        pagemap_add(i);
    /*
     * The kernel boots with 3 as the common, list it last here so it also
     * gets given to init as the kernel kicks off the init stub. init will then
     * exec preserving this common and all forks will be copies from it.
     */
    pagemap_add(3);
}

void platform_interrupt(void)
{
    kbd_interrupt();
    timer_interrupt();
}
