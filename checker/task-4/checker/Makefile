CC = gcc
CFLAGS = -m32 -no-pie
ASM = nasm
ASMFLAGS = -f elf
TASKNAME = task4
IMPL = ../../$(TASKNAME)/$(TASKNAME).asm
SKEL = ../$(TASKNAME).asm

build: checker

check: 
	./check.sh

checker: checker.o task4.o
	$(CC) $(CFLAGS) $^ -o $@
 
task4.o: task4.asm
	$(ASM) $(ASMFLAGS) $^

checker.o: checker.c
	$(CC) -c $(CFLAGS) $^

copy:
	if [ -f $(IMPL) ]; then cp $(IMPL) .; else cp $(SKEL) .; fi

clean:
	rm checker *.o *.out