CC = gcc
CFLAGS = -m32 -no-pie
ASM = nasm
ASMFLAGS = -f elf
TASKNAME = task4
LDFLAGS = -m32 -no-pie

build: checker

check: 
	./check.sh

checker: checker.o $(TASKNAME).o
 
$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o
