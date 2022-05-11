CC = gcc
CFLAGS = -m32 -g -no-pie
ASM = nasm
ASMFLAGS = -f elf32
MAKEFLAGS += --silent
TASKNAME = task1
LDFLAGS = -m32 -no-pie

checker: checker.o $(TASKNAME).o

checker.o: checker.c

$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

check:
	./check.sh

clean:
	rm *.o checker
