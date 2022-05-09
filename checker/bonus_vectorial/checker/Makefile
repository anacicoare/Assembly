ASM = nasm
ASMFLAGS = -f elf64
TASKNAME = bonus_vectorial
IMPL = ../../$(TASKNAME)/$(TASKNAME).asm
SKEL = ../$(TASKNAME).asm

build: checker

check: 
	./check.sh

checker: checker.o bonus_vectorial.o
 
bonus_vectorial.o: $(SOURCE)
	$(ASM) $(ASMFLAGS) $^

checker.o: checker.c

copy:
	if [ -f $(IMPL) ]; then cp $(IMPL) .; else cp $(SKEL) .; fi

clean:
	rm checker *.o
