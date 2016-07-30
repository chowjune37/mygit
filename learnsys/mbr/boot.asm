org 07c00h
jmp short LABEL_BEGIN
nop

BS_OEMName	db	'testdemo'

BPB_BytePerSec	dw	0x200
BPB_SecPerClus	db	1
BPB_RsvdSecCnt	dw	1
BPB_NumFATs	db	2
BPB_RootEntCnt	dw	0xE0
BPB_TotSec16	dw	0xB40

BPB_Media	db	0xf0
BPB_FATSz16	dw	0x9
BPB_SecPerTrk	dw	18
BPB_NumHeads	dw	0x2
BPB_HiddSec	dd	0
BPB_TotSec32	dd	0

BS_DrvNum	db	0
BS_Reserved1	db	1
BS_BOOTSig	db	0x29
BS_VolID	dd	0
BS_VolLab	db	'hello word!!'
BS_FileSysType	db	'FAT12   '

LABEL_BEGIN:
	mov ax,cs
	mov ds,ax
	mov es,ax
xchg bx,bx
	mov ax,_StruRootEnt

	mov ax,0600h
	mov bx,0700h
	mov cx,0
	mov dx,184fh
	int 10h

	mov ah,0
	mov dl,0
	int 13h
	
	push 13h
	push es
	push 01000h
	call Loader

	push _FileName
	call SearchFile

	push 1h
	push es
	push 01000h
	call Loader

	xchg bx,bx
	call ReadFATS
	jmp $

Loader:
	push bp
	mov bp,sp
	mov ax,[bp+6]
	mov es,ax

	xor dx,dx
	mov ax,[bp+8]
	mov bx,[BPB_SecPerTrk]
	div bx

	mov cl,dl
	inc cl
	mov ch,al
	shr ch,1
	mov dh,al
	and dh,1
	mov dl,0
	mov al,1
	mov ah,2
	mov bx,[bp+4]
	int 13h
	pop bp
	ret
	
SearchFile:
	push bp
	mov bp,sp
	mov si,[_OffMemFile]
	mov di,[bp + 4]
	mov cx,11
.1:
	lodsb
	cmp al,[es:di]
	jne .2
	inc di
	loop .1
	jmp .3
.2:
	and si,0ffe0h
	add si,20h
	mov di,_FileName
	dec word [_RootEntCnt]
	cmp word [_RootEntCnt],0
	jne .1
	jmp .4
.3:
	and si,0ffe0h
	mov ax,_StruRootEnt
	mov di,ax
	mov cx,32
rep	movsb
.4:	
	pop bp
	ret

ReadFATS:
	mov ax,[_StruDIR_FstClus]
.7:
	inc byte [_FileFATsNum]
;	mov [_FileFATs],ax
	push ax
	mov ah,0
	mov al,byte [_FileFATsNum]
	dec al
	mov bl,2
	mul bl
	mov bx,_FileFATs
	add bx,ax
	pop ax
	mov [bx],ax
	and ax,0fffh
	cmp ax,0fffh
	je .5
	xor dx,dx
	mov bx,2
	div bx
	cmp dx,0
	jne .6
	mov bx,3
	mul bx
	mov bx,01000h
	add bx,ax
	mov ax,[bx]
	and ax,0FFFh
	jmp .7
.6:
	mov bx,3
	mul bx
	inc ax
	mov bx,01000h
	add bx,ax
	mov ax,[bx]
	shr ax,4
	and ax,0FFFh
	jmp .7	
.5:	

	ret
	
_OffMemFile	dw	1000h
_FileName	db	'HELLO   ASD'
_FileFATs	times	12	dw	0
_FileFATsNum	db	0
_StruRootEnt:
	_StruDIR_name	times 11 db 0
	_StruDIR_Attr	db	0
	_StruDIR__	times 10 db 0
	_StruDIR_WrtTime	dw	0
	_StruDIR_WrtDate	dw	0
	_StruDIR_FstClus	dw	0
	_StruDIR_FileSize	dd	0
_RootEntCnt	dw	224

times 510-($-$$) db 0
dw 0xaa55
