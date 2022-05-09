MAKEFLAGS=--silent

all: run clean

run: check

check:
	./check_all.sh

clean:
	rm */checker/*.o
	rm */checker/checker
	rm */checker/*.asm

zip:
	bash -c 'zip assignment3.zip */*.{S,asm} *.md'
