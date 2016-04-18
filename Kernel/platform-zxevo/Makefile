
CSRCS = evosd.c ../dev/mbr.c ../dev/blkdev.c
CSRCS += devsdspi.c 
CSRCS += devices.c main.c devtty.c devrtc.c 
DISCARD_CSRCS = discard.c evosd_discard.c
#DISCARD_DSRCS = evosd_discard.c
ASRCS = zxevo.s crt0.s
ASRCS += tricks.s commonmem.s

CROSS_CCOPTS += -I../dev/

COBJS = $(CSRCS:.c=.rel)
AOBJS = $(ASRCS:.s=.rel)
DOBJS = $(DSRCS:.c=.rel)
COMMON_COBJS = $(COMMON_CSRCS:.c=.rel)
DISCARD_COBJS = $(DISCARD_CSRCS:.c=.rel)
DISCARD_DOBJS = $(patsubst ../dev/%.c,%.rel, $(DISCARD_DSRCS))
OBJS  = $(COBJS) $(AOBJS) $(DOBJS) $(DISCARD_COBJS) $(DISCARD_DOBJS) $(COMMON_COBJS)

JUNK = $(CSRCS:.c=.lst) $(CSRCS:.c=.asm) $(CSRCS:.c=.sym) $(ASRCS:.s=.lst) $(ASRCS:.s=.sym) $(CSRCS:.c=.rst) $(ASRCS:.s=.rst)

all:	$(OBJS)

$(AOBJS): %.rel: %.s
	$(CROSS_AS) $(ASOPTS) $<

$(COBJS): %.rel: %.c
	$(CROSS_CC) $(CROSS_CCOPTS) --codeseg CODE2 -c $<

$(COMMON_COBJS): %.rel: %.c
	$(CROSS_CC) $(CROSS_CCOPTS) --codeseg COMMONMEM -c $<

$(DOBJS): %.rel: ../dev/%.c
	$(CROSS_CC) $(CROSS_CCOPTS) -c $<

$(DISCARD_COBJS): %.rel: %.c
	$(CROSS_CC) $(CROSS_CCOPTS) $(CROSS_CC_SEGDISC) -c $<

$(DISCARD_DOBJS): %.rel: ../dev/%.c
	$(CROSS_CC) $(CROSS_CCOPTS) $(CROSS_CC_SEGDISC) -c $<
clean:
	rm -f $(OBJS) $(JUNK)  core *~ 

image:
	truncate --size=33M mbr
	sudo parted mbr mktable msdos
	sudo parted mbr mkpart primary fat16 1MiB 17MiB
	sudo parted mbr mkpart primary 17MiB 33MiB
	truncate --size=1M mbr
	truncate --size=16M p1
	mkfs.fat p1
	sudo mount p1 ./img
	sudo cp ../fuzix.bin ./img/
	sudo cp 'fuzix.$$C' ./img/
	sudo umount ./img
	cat mbr p1 ../../filesystem-zxevo.img > fuzix.img
	rm p1 
	rm mbr
