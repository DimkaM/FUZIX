CC = fcc
ASM = sdasz80
AR = sdar
LINKER = sdldz80
export MAKE = make
# This gets set for 'awkward' devices like ZX128
#PLATFORM = -zx128
PLATFORM = -zxevo
export PLATFORM
#CC_OPT = -mz80 -c --opt-code-size --std-c99 --max-allocs-per-node 2000000 -I../include
#CC_OPT = -mz80 --std-c99 -c --opt-code-size --max-allocs-per-node 20000 -I../include -I../../Kernel/include
# for stuff that gives sdcc nightmares
#CC_NOOPT = -mz80 --std-c99 -c --opt-code-size --max-allocs-per-node 1000 -I../include
CC_OPT = -O2 -c
CC_NOOPT = -c
ASM_OPT = -l -o -s
LINKER_OPT = -m -i -o
SRC_CRT0 = crt0$(PLATFORM).s
OBJ_CRT0 = $(SRC_CRT0:.s=.rel)
SRC_CRT0NS = crt0nostdio$(PLATFORM).s
OBJ_CRT0NS = $(SRC_CRT0NS:.s=.rel)
SRC_ASM = enter.s htonl-z80.s htons-z80.s
OBJ_ASM = $(SRC_ASM:.s=.rel)
SRC_C =  __argv.c abort.c asctime.c assert.c atexit.c atoi_small.c
SRC_C += bcmp.c bcopy.c bsearch.c bzero.c calloc.c cfree.c clock.c closedir.c
SRC_C += closedir_r.c clock_gettime.c clock_getres.c clock_settime.c
SRC_C += creat.c crypt.c ctermid.c ctime.c cuserid.c
SRC_C += difftime.c err.c errno.c error.c
SRC_C += execl.c execv.c execvp.c exit.c
SRC_C += fclose.c fflush.c fgetc.c fgetgrent.c fgetpwent.c
SRC_C += fgetpos.c fgets.c fopen.c fork.c fprintf.c fputc.c fputs.c fread.c
SRC_C += free.c fsetpos.c ftell.c fwrite.c getcwd.c
SRC_C += getenv.c __getgrent.c getgrgid.c getgrnam.c getloadavg.c getlogin.c
SRC_C += getopt.c
SRC_C += getpw.c __getpwent.c getpwnam.c getpwuid.c gets.c gettimeofday.c
SRC_C += getw.c gmtime.c gmtime_r.c grent.c
SRC_C += inet_addr.c inet_aton.c inet_network.c inet_ntoa.c inet_ntop.c inet_pton.c
SRC_C += index.c initgroups.c isatty.c killpg.c
SRC_C += libintl.c
SRC_C += localtim.c localtim_r.c lseek.c lsearch.c lstat.c ltoa.c ltostr.c
SRC_C += malloc.c mkfifo.c mkstemps.c nanosleep.c opendir.c opendir_r.c
SRC_C += pause.c perror.c
SRC_C += popen.c printf.c putenv.c putgetch.c putpwent.c putw.c pwent.c qsort.c
SRC_C += raise.c rand.c readdir.c readlink.c realloc.c regerror.c
SRC_C += regsub.c remove.c rewind.c rewinddir.c rindex.c seekdir.c setbuffer.c setenv.c
SRC_C += setlocale.c setvbuf.c settimeofday.c sleep.c sprintf.c 
SRC_C += stat.c stdio0.c stime.c
SRC_C += strcasecmp.c strcasestr.c strdup.c stricmp.c strlcpy.c strncasecmp.c
SRC_C += strnlen.c strnicmp.c strsep.c strxfrm.c strcoll.c strsignal.c
SRC_C += strtod.c strtol.c swab.c system.c telldir.c time.c tmpfile.c tmpnam.c ttyname.c
SRC_C += tzset.c ungetc.c usleep.c utent.c utimes.c utsname.c
SRC_C += vfprintf.c vprintf.c wait.c xitoa.c pathconf.c
SRC_C += gethostname.c sysconf.c confstr.c memccpy.c getpass.c
# ctype
SRC_C += isalnum.c isalpha.c isascii.c isblank.c iscntrl.c isdigit.c
SRC_C += isgraph.c islower.c isprint.c ispunct.c isspace.c isupper.c
SRC_C += isxdigit.c toupper.c tolower.c
# tty layer
SRC_C += tcgetattr.c tcsetattr.c tcdrain.c tcflow.c tcflush.c
SRC_C += cfmakeraw.c cfspeed.c revoke.c
# scanf
SRC_C += fscanf.c scanf.c sscanf.c vfscanf.c vscanf.c vsscanf.c
# Seems to give the compiler a hard time
SRC_HARD += regexp.c
# Pieces we inherit in this case from the compiler library instead
#SRC_C += strcpy.c strlen.c abs.c atof.c atoi.c atol.c labs.c
#SRC_C += strcat.c strchr.c strcmp.c strcspn.c strncat.c strncmp.c
#SRC_C += strncpy.c strpbrk.c strrchr.c strspn.c strstr.c strtok.c
#SRC_C += memchr.c memcmp.c memcpy.c memset.c

SRC_C += termcap.c

SRC_CURS = $(shell find curses -name '*.c')

OBJ_C = $(SRC_C:.c=.rel)
OBJ_CURS = $(SRC_CURS:.c=.rel)
OBJ_HARD = $(SRC_HARD:.c=.rel)
OBJ_ALL = $(OBJ_ASM) $(OBJ_C) $(OBJ_CURS) $(OBJ_HARD)

all: syslib$(PLATFORM).lib crt0$(PLATFORM).rel crt0nostdio$(PLATFORM).rel liberror.txt

libc.l:%.l:$(OBJ_ALL)
	ls $(OBJ_ALL) > libc.l

syscall.l: fuzix/syslib.l
	../tools/syscall
	(cd fuzix; $(MAKE))
	cat fuzix/syslib.l | tr " " "\\n" | sed -e "s/^/fuzix\//" >syscall.l

sdccz80.lib:
	../tools/libclean

syslib$(PLATFORM).lib: syscall.l libc.l sdccz80.lib
	cat libc.l syscall.l >syslib.l
	cp sdccz80.lib syslib$(PLATFORM).lib
	$(AR) rc syslib$(PLATFORM).lib @syslib.l
	$(AR) s syslib$(PLATFORM).lib
	ln -sf syslib$(PLATFORM).lib c$(PLATFORM).lib

fuzix/syslib.l:
	../tools/syscall
	$(MAKE) -C fuzix

liberror.txt:
	../tools/liberror > liberror.txt

$(OBJ_ASM):%.rel: %.s
	$(ASM) $(ASM_OPT) $@ $(@:.rel=.s)

$(OBJ_CRT0):%.rel: %.s
	$(ASM) $(ASM_OPT) $@ $(@:.rel=.s)

$(OBJ_CRT0NS):%.rel: %.s
	$(ASM) $(ASM_OPT) $@ $(@:.rel=.s)

$(OBJ_C):%.rel: %.c
	$(CC) $(CC_OPT) $(@:.rel=.c)

$(OBJ_CURS):%.rel: %.c
	$(CC) $(CC_OPT) $(@:.rel=.c) -o $@

$(OBJ_HARD):%.rel: %.c
	$(CC) $(CC_NOOPT) $(@:.rel=.c)

clean:
	rm -rf *.rel *.asm *.sym *.lst *.lib *~ syscall.l  libc.l syslib.l liberror.txt
	(cd curses; rm -rf *.rel *.asm *.sym *.lst *~)
	(cd fuzix; $(MAKE) clean)

install:
	cp crt0$(PLATFORM).rel crt0nostdio$(PLATFORM).rel c$(PLATFORM).lib /opt/fcc/lib/
