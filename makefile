uppercase1: uppercase1.o
	ld -m elf_i386 -o uppercase1 uppercase1.o
uppercase1.o: uppercase1.asm
	nasm -f elf32 -g -F stabs uppercase1.asm -l uppercase1.lst
