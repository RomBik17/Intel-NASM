
%include "kernel.inc"       ; macros kernel
global getstr
section .text
getstr:                     ; arg1-buffer address, arg2 - length
        push ebp
        mov ebp, esp        
        xor ecx, ecx        ; count
        mov edx, [ebp+8]    ; temporary address in buffer
.again: 
        inc ecx
        cmp ecx, [ebp+12]   ; compare to buffer size
        jae .quit
        push ecx
        push edx            ; save registers ecx, edx
        kernel 3, 0, edx, 1 ; read one symbol in buffer
        pop edx             
        pop ecx             ; restore edx, ecx
        cmp eax, 1          ; system call gave 1?
        jne .quit
        mov al, [edx]       ; code of readed symbol
        cmp al, 10          ; is it code of string transfer?
        je .quit
        inc edx
        jmp .again
.quit:
        mov [edx], byte 0
        mov esp, ebp
        pop ebp
        ret