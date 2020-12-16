; Executable name : uppercase1
; Version : 1.0
; Created date : December 15, 2020
; Updated date : December 16, 2020
; Author : Olga Agafonova
; Description : An exercise from the "Assembly Language Step-by-Step" book
;
; Build using these commands or use the makefile:
; nasm -f elf -g -F stabs uppercase1.asm
; ld -o uppercase1 uppercase1.o
;
;
; Run using ./uppercase1 - enter a lowercase word and watch it turn into uppercase...

section .bss
    BUFFLEN equ 1024;       ; length of the buffer
    Buff: resb BUFFLEN      ; the buffer itself containing text

section .data

section .text

global _start

_start:

nop                          ; keeps the debugger happy

                             ; Read a buffer full of text from stdin
Read:   mov eax, 3           ; Specify sys_read call
        mov ebx, 0           ; Specify file descriptor 0 - standard input
        
                             ; Setup registers to read from the buffer
        mov ecx, Buff        ; Pass address of the buffer to read to
        mov edx, BUFFLEN     ; Tell sys_read to read one char from input
        int 80h              ; Call sys_read
        mov esi, eax         ; Copy sys_read return value for the future
        cmp eax, 0           ; If eax=0, sys_read reached EOF in stdin
        je Done
        
                             ; Setup registers for the buffer loop
        mov ecx, esi         ; Place the number of bytes read into ecx
        mov ebp, Buff        ; Place address of buffer into ebp
        dec ebp              ; Adjust count to offset

Scan:   cmp byte [ebp+ecx], 61h ; Test input character against lowercase 'a'
        jb Next                 ; If below 'a' in ASCII, not lowercase
        cmp byte [ebp+ecx], 7Ah ; Test input character against lowercase 'z'
        ja Next                 ; If above 'z' in ASCII, not lowercase
                                ; Now, we have a lowercase character...
        sub byte [ebp+ecx], 20h ; Subtract 20h from lowercase char to get an uppercase char
        
Next:   dec ecx              ; Decrement counter
        jnz Scan             ; If there are more characters in buffer, loop back
        
                             ; Write the char to standard output 
Write:  mov eax, 4           ; Specify sys_write call
        mov ebx, 1           ; Specify file descriptor 1 - standard output
        mov ecx, Buff        ; Pass address of the buffer to write
        mov edx, esi         ; Pass the # of bytes of data in the buffer
        int 80h              ; Call sys_read
        jmp Read             ; Go read another character
        
Done:   mov eax, 1           ; Load code for exit syscall
        mov ebx, 0           ; Return a code of zero to Linux
        int 80h              ; Make a kernel call to exit the program



