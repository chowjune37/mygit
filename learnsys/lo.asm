org 0100h
jmp LABEL_BEGIN
%include "pm.inc"
;%macro Descriptor 3
;	dw	%2 & 0ffffh
;	dw	%1 & 0ffffh
;	db	(%1 >> 16) & 0ffh
;	dw	((%2 >> 8) & 0f00h) | (%3 & 0f0ffh)
;	db	(%1 >> 24) & 0ffh
;%endmacro

;%macro Gate 4
;	dw	%2 & 0ffffh
;	dw	%1
;	dw	(%3 & 1fh)|((%4 << 8) & 0ff00h)
;	dw	((%2 >> 16) & 0ffffh)
;%endmacro

[SECTION .gdt]
LABEL_GDT:		Descriptor	0,	0,	0
LABEL_DESC_CODE32:	Descriptor	0,	Code32Len - 1,0c098h
LABEL_DESC_STACK0:	Descriptor	0,	TopOfStack0,04092h
LABEL_DESC_CODE32_3:	Descriptor	0,	Code323Len - 1,0c0d8h
LABEL_DESC_STACK3:	Descriptor	0,	TopOfStack3,040d2h
LABEL_GATE_CODE32:	Gate	SelectorCode32,0,0,0ech
LABEL_DESC_TSS:		Descriptor	0,	TSSLen-1,89h

GdtLen equ $ - LABEL_GDT
GdtPtr	dw	GdtLen - 1
	dd	090000h + LABEL_GDT

SelectorCode32	equ	LABEL_DESC_CODE32 - LABEL_GDT
SelectorStack0	equ	LABEL_DESC_STACK0 - LABEL_GDT
SelectorCode323	equ	LABEL_DESC_CODE32_3 - LABEL_GDT+2h
SelectorStack3	equ	LABEL_DESC_STACK3 - LABEL_GDT+2h
SelectorGateCode32 equ  LABEL_GATE_CODE32 - LABEL_GDT+3h
SelectorTSS	equ	LABEL_DESC_TSS - LABEL_GDT

[SECTION .ldt]
[BITS 32]
LABEL_TSS:
	DD	0
	DD	TopOfStack0
	DD	SelectorStack0
	DD	0
	DD	0
	DD	0
	DD	0
	DD	0	;cr3
	DD	0	;eip
	DD	0	;eflags
	DD	0	;eax
	DD	0	;ecx
	DD	0	;edx
	DD	0	;ebx
	DD	0	;esp
	DD	0	;ebp
	DD	0	;esi
	DD	0	;edi
	DD	0	;es
	DD	0	;cs
	DD	0	;ss
	DD	0	;ds
	DD	0	;fs
	DD	0	;gs
	DD	0	;ldt
	DW	0	;
	DW	$ - LABEL_TSS + 2	;
	DB	0ffh	;
TSSLen	equ	$ - LABEL_TSS

[SECTION .s0]
[BITS 32]
LABEL_SEG_STACK0:
times 512 db 0
TopOfStack0	equ  $ - LABEL_SEG_STACK0 - 1

[SECTION .s3]
[BITS 32]
LABEL_SEG_STACK3:
times 512 db 0
TopOfStack3	equ  $ - LABEL_SEG_STACK3 - 1

[SECTION .r16]
[BITS 16]
LABEL_BEGIN:
	xchg bx,bx
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov ss,ax
	mov esp,0100h
	mov ax,0b800h
	mov gs,ax

	mov ah,0ch
	mov al,'A'
	mov [gs:0],ax

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
	add eax,LABEL_SEG_STACK0
	mov word [LABEL_DESC_STACK0 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_STACK0 + 4],al
	mov byte [LABEL_DESC_STACK0 + 7],ah

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_CODE32_3
	mov word [LABEL_DESC_CODE32_3 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_CODE32_3 + 4],al
	mov byte [LABEL_DESC_CODE32_3 + 7],ah

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_STACK3
	mov word [LABEL_DESC_STACK3 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_STACK3 + 4],al
	mov byte [LABEL_DESC_STACK3 + 7],ah

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_TSS
	mov word [LABEL_DESC_TSS + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_TSS + 4],al
	mov byte [LABEL_DESC_TSS + 7],ah

	lgdt [GdtPtr]

	cli

	in al,92h
	or al,00000010h
	out 92h,al

	mov eax,cr0
	or eax,1
	mov cr0,eax

	jmp dword SelectorCode32:0

	jmp $

[SECTION .c32]
[BITS 32]
LABEL_SEG_CODE32:
	xchg bx,bx
	mov ax,SelectorStack0
	mov ss,ax
	mov esp,TopOfStack0

	mov ax,SelectorStack3
	mov ds,ax
	
	mov ax,SelectorTSS
	ltr ax

	push SelectorStack3
	push TopOfStack3
	push SelectorCode323
	push 0
	retf
	jmp $
Code32Len equ $ - LABEL_SEG_CODE32

[SECTION .c323]
[BITS 32]
LABEL_SEG_CODE32_3:
	mov ax,cs
	
	call SelectorGateCode32:0
	jmp $
Code323Len equ $ - LABEL_SEG_CODE32_3
