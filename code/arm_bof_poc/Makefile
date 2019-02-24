# Makefile
ALL := arm_bof_vuln arm_bof_vuln_fortified arm_bof_vuln_stackprot
CXX=
CC=${CXX}gcc
LD=${CXX}ld
DBG=-g -ggdb -gdwarf-4 -O0
CFLAGS=${DBG} -Wall -Wextra
CFLAGS_FORT=-D_REENTRANT -O2 -D_FORTIFY_SOURCE=2 -Wall -Wextra
CFLAGS_STKPROT=-D_REENTRANT -O2 -fstack-protector-strong -Wall -Wextra

all: ${ALL}

arm_bof_vuln: arm_bof_vuln.c
	${CC} ${CFLAGS} -o $@ $<
arm_bof_vuln_fortified: arm_bof_vuln.c
	${CC} ${CFLAGS_FORT} arm_bof_vuln.c -o arm_bof_vuln_fortified
arm_bof_vuln_stackprot: arm_bof_vuln.c
	${CC} -g ${CFLAGS_STKPROT} arm_bof_vuln.c -o arm_bof_vuln_stackprot
clean:
	rm -fv ${ALL} *.o
