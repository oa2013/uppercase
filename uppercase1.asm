; Executable name : uppercase1
; Version : 1.0
; Created date : December 15, 2020
; Author : Olga Agafonova
; Description : An exercise from the "Assembly Language Step-by-Step book"
;
; Build using these commands:
; nasm -f elf -g -F stabs uppercase1.asm
; ld -o uppercase1 uppercase1.o
;
; Run using ./uppercase1 - enter a lowercase word and watch it turn into uppercase...

section .bss
    Buff resb 1

section .data

section .text

global _start

_start:

nop                          ; keeps the debugger happy

Read:   mov eax, 3           ; Specify sys_read call
        mov ebx, 0           ; Specify file descriptor 0 - standard input
        mov ecx, Buff        ; Pass address of the buffer to read to
        mov edx, 1           ; Tell sys_read to read one char from input
        int 80h              ; Call sys_read
        
        cmp eax, 0           ; Look at sys_read's return value in eax
        je Exit              ; Jump to Exit if zero (0 means we reached EOF)
        cmp byte [Buff], 61h ; Test input character against lowercase 'a'
        jb Write             ; If below 'a' in ASCII, not lowercase
        cmp byte [Buff], 7Ah ; Test input character against lowercase 'z'
        ja Write             ; If above 'z' in ASCII, not lowercase
                             ; Now, we have a lowercase character...
        sub byte [Buff], 20h ; Subtract 20h from lowercase char to get an uppercase char...
        
                             ; ...and write the char to standard output 
Write:  mov eax, 4           ; Specify sys_write call
        mov ebx, 1           ; Specify file descriptor 1 - standard output
        mov ecx, Buff        ; Pass address of the buffer to write
        mov edx, 1           ; Pass number of chars to write
        int 80h              ; Call sys_read
        jmp Read             ; Go read another character
        
Exit:   mov eax, 1           ; Load code for exit syscall
        mov ebx, 0           ; Return a code of zero to Linux
        int 80h              ; Make a kernel call to exit the program



