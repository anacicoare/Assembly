ASM=nasm
ASMFLAGS=-f elf64
MAKEFLAGS=--silent
TASKNAME = bonus_x64
IMPL = ../../$(TASKNAME)/$(TASKNAME).asm
SKEL = ../$(TASKNAME).asm

build: checker

check:
	./check.sh

checker: checker.o bonus_x64.o
 
bonus_x64.o: bonus_x64.asm
	$(ASM) $(ASMFLAGS) $^

checker.o: checker.c

copy:
	if [ -f $(IMPL) ]; then cp $(IMPL) .; else cp $(SKEL) .; fi

clean:
	rm checker *.o
