CC = sdcc
ASM = sdasz80
AR = sdar
LINKER = sdcc
FCC = ../../Library/tools/fcc
FCCOPTS = -O2
PLATFORM =
#PLATFORM = -tzx128

PROGLOAD=`(cat ../../Kernel/platform/config.h; echo PROGLOAD) | cpp -E | tail -n1`

.SUFFIXES: .c .rel

SRCSNS = \
	basename.c \
	cat.c \
	chgrp.c \
	chmod.c \
	chown.c \
	cmp.c \
	cp.c \
	date.c \
	dirname.c \
	false.c \
	groups.c \
	head.c \
	init.c \
	kill.c \
	ln.c \
	logname.c \
	mkdir.c \
	mkfifo.c \
	mknod.c \
	mv.c \
	pagesize.c \
	printenv.c \
	prtroot.c \
	pwd.c \
	reboot.c \
	rm.c \
	rmdir.c \
	sum.c \
	sync.c \
	tee.c \
	telinit.c \
	touch.c \
	tr.c \
	true.c \
	uname.c \
	while1.c \
	whoami.c \
	yes.c

SRCS  = banner.c \
	bd.c \
	cal.c \
	cksum.c \
	cut.c \
	dd.c \
	decomp16.c \
	df.c \
	dosread.c \
	du.c \
	echo.c \
	ed.c \
	env.c \
	factor.c \
	fdisk.c \
	fgrep.c \
	fsck.c \
	grep.c \
	id.c \
	ll.c \
	ls.c \
	man.c \
	mkfs.c \
	mode.c \
	more.c \
	mount.c \
	od.c \
	passwd.c \
	patchcpm.c \
	ps.c \
	sleep.c \
	ssh.c \
	sort.c \
	stty.c \
	su.c \
	tail.c \
	umount.c \
	uniq.c \
	uud.c \
	uue.c \
	uptime.c \
	wc.c \
	which.c \
	who.c \
	write.c \
	xargs.c

SRCSBAD = sed.c socktest.c

OBJS = $(SRCS:.c=.rel)
OBJSNS = $(SRCSNS:.c=.rel)
OBJSBAD = $(SRCSBAD:.c=.rel)

LIBS = ../../Library/libs/syslib.lib

APPSNS = $(OBJSNS:.rel=)

APPS = $(OBJS:.rel=) $(OBJSBAD:.rel=) $(OBJSNS:.rel=)

all: $(APPS) sizes


$(APPSNS): OPTS = --nostdio

$(OBJS): %.rel: %.c

$(OBJSNS): %.rel: %.c

$(OBJSBAD): %.rel: %.c
	$(FCC) $(PLATFORM) -c $<

.c.rel:
	$(FCC) $(PLATFORM) $(FCCOPTS) -c $<

%: %.rel
	$(FCC) $(PLATFORM) $(OPTS) $< -o $@

sizes: $(APPS)
	ls -l $(APPS) >size.report

clean:
	rm -f $(OBJS) $(APPS) $(SRCS:.c=) core *~ *.asm *.lst *.sym *.map *.noi *.lk *.ihx *.tmp *.bin size.report

rmbak:
	rm -f *~ core

