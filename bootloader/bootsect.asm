BOOT_ORGI_ADDR  equ  0x7c00
BOOT_NEWADDR	equ  0x2e00
TEMP_STACK      equ  BOOT_NEWADDR-0x100
BOOTSECT_SIZE   equ  512

%define newaddr(addr) (addr - BOOT_ORGI_ADDR + BOOT_NEWADDR)

section bootsect align=16 vstart=BOOT_ORGI_ADDR
jmp start

hellomsg  db 'Welcome to the COS World!', 0x0d, 0x0a, 0
movedmsg  db 'bootsect is moved sucessfully!', 0x0d, 0x0a, 0
errmsg_lba db "The machine doesn't support disk lba mode!", 0x0d, 0x0a, 0

;Print a message that si points and end when meets 0x0
printmsg:
		mov ah, 0x0e
		mov al, [si]
		cmp al ,0x0
		jz _strend
		int 0x10
		inc si
		jmp printmsg	
_strend:		
		ret

;Disk LBA mode MUST BE supported, or boot die here
checklba:
		mov ah, 0x41
		mov bx, 0x55aa
		mov dl, 0x80
		int 0x13
		jnc _haslba	
		mov si, errmsg_lba
		call printmsg
		jmp checklba
_haslba:
		ret			

;Print hello message
sayhello:
		mov si, hellomsg
		call printmsg
		ret

start:
		;Setup some segments and a temporary stack
		xor ax, ax
		mov ds, ax
		mov es, ax
		mov ss, ax
		mov sp, TEMP_STACK

		call checklba
		call sayhello

		;move boot sector from phyaddr 0x7c00 to 0x3000
		xor ax, ax
		mov ds, ax
		mov es, ax
		mov si, BOOT_ORGI_ADDR
		mov di, BOOT_NEWADDR
		mov cx, BOOTSECT_SIZE>>1
		rep movsw

		jmp 0x0 : newaddr(continue_in_new_address)

continue_in_new_address:
		mov si, newaddr(movedmsg)
		call printmsg
		
		jmp $


times 510-($-$$) db 0x0
db 0x55, 0xaa

