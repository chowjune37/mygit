org 0100h
jmp LABEL_BEGIN
%include "pm.inc"

[SECTION .gdt]
LABEL_GDT:		Descriptor	0,		0,		0
LABEL_DESC_CODE32:	Descriptor	0,		Code32Len - 1,	4098h
LABEL_DESC_VIODE:	Descriptor	0B8000h,	0FFFFFh,	92h
LABEL_DESC_STACK:	Descriptor	0,		StackOfTop,	4092h
LABEL_DESC_DATA:	Descriptor	0,		0,		0

GdtLen equ $ - LABEL_GDT
GdtPtr	dw	GdtLen - 1
	dd	090000h + LABEL_GDT

SelectorCode32	equ	LABEL_DESC_CODE32 - LABEL_GDT
SelectorViode	equ	LABEL_DESC_VIODE  - LABEL_GDT
SelectorStack	equ	LABEL_DESC_STACK  - LABEL_GDT

[SECTION .s32]
[BITS 32]
LABEL_SEG_STACK:
	times 512 db 0
StackOfTop equ $ - LABEL_SEG_STACK - 1

[SECTION .b16]
[BITS 16]
LABEL_BEGIN:
	xchg bx,bx
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov ss,ax
	mov gs,ax
	mov ax,0b800h
	mov es,ax
	mov al,'A'
	mov ah,0ch
	mov [es:0],ax

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_CODE32
	mov word [LABEL_DESC_CODE32 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_CODE32 + 4],al
	mov byte [LABEL_DESC_CODE32 + 7],ah

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_STACK
	mov word [LABEL_DESC_STACK + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_STACK + 4],al
	mov byte [LABEL_DESC_STACK + 7],ah

	lgdt [GdtPtr]

	cli

	in al,92h
	or al,00000010b
	out 92h,al
	
	mov eax,cr0
	or eax,1
	mov cr0,eax

	jmp SelectorCode32:0

	jmp $

[SECTION .b32]
[BITS 32]
LABEL_SEG_CODE32:
	mov ax,SelectorStack
	mov gs,ax
	mov esp,StackOfTop
	mov ax,SelectorViode
	mov gs,ax
	mov al,'B'
	mov ah,0ch
	mov [gs:2],ax

	jmp $
Code32Len equ $ - LABEL_SEG_CODE32
