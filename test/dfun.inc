;readsec(扇区号,缓冲区内存地址)

readsec:
	push bp
	mov bp,sp
	mov ax,[bp+4]
	xor dx,dx
	div word [BPB_SecPerTrk]
	inc dl
	mov cl,dl
	mov ch,al
	shr ch,1
	mov dh,al
	and dh,1
	xor dl,dl
	mov ah,02h
	mov al,01h
	mov bx,[bp+6]
	int 13h
	pop bp
	ret
