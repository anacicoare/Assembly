ASM = nasm
ASMFLAGS = -f elf32
MAKEFLAGS = --silent
CC = gcc
CFLAGS = -m32 -no-pie
TASKNAME_1 = task2_p1
TASKNAME_2 = task2_p2
LDFLAGS = -m32 -no-pie

build: checker

check:
	./check.sh

checker: checker.o $(TASKNAME_1).o $(TASKNAME_2).o
 
$(TASKNAME_1).o: ../$(TASKNAME_1).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

$(TASKNAME_2).o: ../$(TASKNAME_2).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o
