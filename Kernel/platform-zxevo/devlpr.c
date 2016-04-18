#include <kernel.h>
#include <version.h>
#include <kdata.h>
#include <devlpr.h>


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

	minor;
	rawflag;
	flag;			
	return udata.u_count;
}
