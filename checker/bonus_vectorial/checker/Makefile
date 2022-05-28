ASM = nasm
ASMFLAGS = -f elf64
TASKNAME = bonus_vectorial
CFLAGS = -no-pie -fno-pie -g
LDFLAGS = -no-pie -fno-pie
MAKEFLAGS = --silent

build: checker

check: 
	./check.sh

checker: checker.o $(TASKNAME).o
 
$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o
