%include "meminfo.inc"

section loader align=16 vstart=LOADER_ADDR
		jmp start

msg db 'This is a hello message from loader!', 0x0d, 0x0a, 0

start:
		xor ax, ax
		mov ds, ax
		mov es, ax
		mov ss, ax
		mov sp, STACK_ADDR
		
		mov si, msg
		call printmsg
		jmp $

printmsg:
        mov ah, 0x0e
        mov al, [si]
        cmp al, 0
        jz _strend
        int 0x10
        inc si
        jmp printmsg
_strend:
        ret

