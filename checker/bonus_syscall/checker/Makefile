CC = gcc
CFLAGS = -m32 -no-pie
ASM = nasm
ASMFLAGS = -f elf
MAKEFLAGS= --silent
TASKNAME = bonus_syscall
LDFLAGS = -m32 -no-pie

build: checker

check: checker
	./check.sh

checker: checker.o $(TASKNAME).o
 
$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o
