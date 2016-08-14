jmp LABEL_BEGIN
nop
%include "fat12.inc"

LABEL_BEGIN:
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov ax,0100h
	mov sp,ax

	mov ax,0600h
	mov bx,0700h
	mov cx,0h
	mov dx,0184fh
	int 10h

	xor ah,ah
	xor dl,dl
	int 13h

	jmp $
