CC = gcc
CFLAGS = -m32 -no-pie -fno-pie -g
ASM = nasm
ASMFLAGS = -f elf
TASKNAME = task4
LDFLAGS = -m32 -no-pie -fno-pie

build: checker

check: 
	./check.sh

checker: checker.o $(TASKNAME).o
 
$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o *.out
