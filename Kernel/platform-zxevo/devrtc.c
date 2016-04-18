
#include "cpu.h"

__sfr __banked __at 0xDEF7 RTC_REG;
__sfr __banked __at 0xBEF7 RTC_DATA;
#define RTC_READ(_reg) (RTC_REG=(_reg),RTC_DATA)
#define RTC_WRITE(_reg,_dat) RTC_REG=(_reg);RTC_DATA=(_dat)
uint8_t rtc_secs(void)
{
    return RTC_READ(0x00);
}
