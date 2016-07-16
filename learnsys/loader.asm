org 0100h
jmp LABEL_BEGIN
%include "pm.inc"

[SECTION .gdt]
LABEL_GDT:		Descriptor	0,	0,	0
LABEL_DESC_CODE32:	Descriptor	0,	0,	0

GdtLen equ $ - LABEL_GDT
GdtPtr	dw	GdtLen - 1
	dd	090000h + LABEL_GDT

SelectorCode32	equ	LABEL_DESC_CODE32 - LABEL_GDT

[SECTION .b16]
[BITS 16]
LABEL_BEGIN:
	jmp $
