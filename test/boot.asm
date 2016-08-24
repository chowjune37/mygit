org 07c00h
jmp LABEL_BEGIN
nop
%include "fat12.inc"
%include "dfun.inc"
LABEL_BEGIN:
	xchg bx,bx
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

	xchg bx,bx
;----------------根目录找文件------------
	mov cx,[D_RootNumSec]
.1_1:
	mov ax,[D_RootNumSec]
	sub ax,cx
	add ax,[D_RootStartSec]
	push cx
	push word [D_TmpSecAddr]
	push ax
	call readsec
	add sp,4
	mov cx,20h
	mov si,[D_TmpSecAddr]
.1_2:
	mov di,D_SearchFileName
	push cx
	mov cx,11
.1_3:
	push cx
	lodsb
	cmp [es:di],al
	jnz .1_4
	inc di
	pop cx
	loop .1_3
	jmp .1_ok
.1_4:
	pop cx
	and si,0FFE0h
	add si,20h
	pop cx
	loop .1_2
	pop cx
	loop .1_1
	jmp $
.1_ok:
	and si,0FFE0h
	;jmp $
;--------------根目录找文件---------
	xchg bx,bx  ;;;;;;;;;;;;;;;;;
;--------------加载文件-------------

	mov ax,[si+26]
	mov word [D_FileClus],ax

.2_6:
	xchg bx,bx	;;;;;;;;;;;;;;;;
	xor ax,ax
	mov al,[D_F_NumClus]
	mov bx,512
	mul bx
	add ax,9000h
	push ax

	mov ax,[D_FileClus]
	sub ax,2
	add ax,33
	
	push ax
	call readsec

	xchg bx,bx ;;;;;;;;;;;;;;;;

	add sp,4
	;------------------

	mov ax,[D_FileClus]
	mov bx,3
	mul bx
	mov bx,2
	div bx
	cmp dx,0
	jnz .2_2		;----奇偶
	mov bx,0
	jmp .2_3
.2_2:
	mov bx,1
.2_3:
	mov [D_F_SD],bl

	mov [D_F_LowByte],ax
	;---------------------
	
	mov ax,[D_FileClus]

	mov bx,512
	xor dx,dx
	div bx
	mov [D_F_NowFAT],al
	inc ax

	push 0500h
	push ax
	call readsec
	xchg bx,bx  ;;;;;;;;;;;;;;;;;;;;;
	add sp,4

	xor ax,ax
	mov al,[D_F_NowFAT]
	mov bx,512
	mul bx
	mov bx,ax
	mov ax,[D_F_LowByte]
	sub ax,bx
	add ax,0500h
	mov si,ax
	mov al,byte [si]
	mov [D_F_LowClus],al
	;---------------------
	mov ax,[D_F_LowByte]
	inc ax
	xor dx,dx
	mov bx,512
	div bx
	cmp al,[D_F_NowFAT] ;????????????????
	jz .2_4
	mov [D_F_NowFAT],al
	push 0500h
	inc ax
	push ax
	call readsec
	xchg bx,bx ;;;;;;;;;;;;;;;;;;;;
	add sp,4
.2_4:
	xor ax,ax
	mov al,[D_F_NowFAT]
	mov bx,512
	mul bx
	mov bx,ax
	mov ax,[D_F_LowByte]
	inc ax
	sub ax,bx
	add ax,0500h
	mov si,ax
	mov al,byte [si]
	mov [D_F_HighClus],al
	;------------------
	mov ax,[D_FileClus]
	cmp byte[D_F_SD],0
	jz .2_5
	shr ax,4
.2_5:
	and ax,0FFFh
	mov [D_FileClus],ax

	inc byte [D_F_NumClus]
	
	cmp ax,0FF8h
	jb .2_6
;--------------加载文件-------------
	jmp $
times 510-($-$$) db 0

dw 0xAA55
