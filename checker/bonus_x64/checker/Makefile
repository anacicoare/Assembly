ASM = nasm
ASMFLAGS = -f elf64
MAKEFLAGS = --silent
TASKNAME = bonus_x64

build: checker

check:
	./check.sh

checker: checker.o $(TASKNAME).o
 
$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o
