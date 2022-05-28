CC = gcc
CFLAGS = -m32 -no-pie -fno-pie -g
MAKEFLAGS = --silent
TASKNAME = bonus_at_t
LDFLAGS = -m32 -no-pie -fno-pie

build: checker

check:
	./check.sh

checker: checker.o $(TASKNAME).o
 
$(TASKNAME).o: ../$(TASKNAME).S
	$(CC) -c $(CFLAGS) $^ -o $@

checker.o: checker.c

clean:
	rm checker *.o
