CC = gcc
CFLAGS = -m32 -g -no-pie -fno-pie -g
ASM = nasm
ASMFLAGS = -f elf32
MAKEFLAGS += --silent
TASKNAME = task1
LDFLAGS = -m32 -no-pie -fno-pie

checker: checker.o $(TASKNAME).o

checker.o: checker.c

$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

check:
	./check.sh

clean:
	rm *.o checker
