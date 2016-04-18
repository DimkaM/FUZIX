/* Simple IDE interface */
#define IDE_REG_DATA		0x10
#define IDE_REG_ERROR		0x30
#define IDE_REG_FEATURES	0x30
#define IDE_REG_SEC_COUNT	0x50
#define IDE_REG_LBA_0		0x70
#define IDE_REG_LBA_1		0x90
#define IDE_REG_LBA_2		0xB0
#define IDE_REG_LBA_3		0xD0
#define IDE_REG_DEVHEAD		0xD0
#define IDE_REG_STATUS		0xF0
#define IDE_REG_COMMAND		0xF0
#define DRIVE_COUNT			0x01
#define ide_select(x)
#define ide_deselect()
