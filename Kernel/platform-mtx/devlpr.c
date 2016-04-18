#include <kernel.h>
#include <version.h>
#include <kdata.h>
#include <devlpr.h>

__sfr __at 0x00 lpstrobel;
__sfr __at 0x04 lpdata;		/* Data on write, status+strobe clr on read */

int lpr_open(uint8_t minor, uint16_t flag)
{
	minor;
	flag;			// shut up compiler
	return 0;
}

int lpr_close(uint8_t minor)
{
	minor;			// shut up compiler
	return 0;
}

int lpr_write(uint8_t minor, uint8_t rawflag, uint8_t flag)
{
	int c = udata.u_count;
	char *p = udata.u_base;
	uint16_t ct;
	uint8_t reg;

	minor;
	rawflag;
	flag;			// shut up compiler

	while (c-- > 0) {
		ct = 0;

		/* Try and balance polling and sleeping */
		while ((reg = lpdata) & 1) {
		        reg ^= 2;
		        if (reg & 6) {
		                if (c == udata.u_count) {
		                        if (reg & 4)
                		                udata.u_error = ENOSPC;
                                        else
                		                udata.u_error = EIO;
                                }
                                return udata.u_count - c;
                        }
			ct++;
			if (ct == 10000) {
				udata.u_ptab->p_timeout = 3;
				if (psleep_flags(NULL, flag)) {
					if (c != udata.u_count)
						udata.u_error = 0;
					return udata.u_count - c;
				}
				ct = 0;
			}
		}
		/* Data */
		lpdata = ugetc(p++);
		/* Strobe - FIXME: should be 1uS */
		for (reg = 0; reg < 128; reg++);
		reg = lpstrobel;
		for (reg = 0; reg < 128; reg++);
		/* Strobe back high */
		reg = lpdata;
	}
	return udata.u_count - c;
}
