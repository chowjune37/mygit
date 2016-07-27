org 0100h
jmp LABEL_BEGIN
%include "pm.inc"

BasePageDir	equ	200000h
BasePageTbl	equ	201000h
BasePageDir1	equ	210000h
BasePageTbl1	equ	211000h


[SECTION .gdt]
LABEL_GDT:		Descriptor	0,		0,		0
LABEL_DESC_CODE32:	Descriptor	0,		Code32Len - 1,	4098h
LABEL_DESC_VIODE:	Descriptor	0B8000h,	0FFFFFh,	92h
LABEL_DESC_STACK32:	Descriptor	0,		StackOfTop,	4092h
LABEL_DESC_DATA32:	Descriptor	0,		Data32Len - 1,	92h
LABEL_DESC_TSS:		Descriptor	0,		TSSLen - 1,	89h
LABEL_GATE_CODE:	Gate		SelectorCode32,	0,	0,	0ech
LABEL_DESC_PAGEDIR:	Descriptor	BasePageDir,	4095,		92h
LABEL_DESC_PAGETBL:	Descriptor	BasePageTbl,	1023,		8092h

LABEL_DESC_FLAT_RW:	Descriptor	0,		0FFFFFh,	8092h
LABEL_DESC_FLAT_C:	Descriptor	0,		0FFFFFh,	0c098h

LABEL_DESC_CODE323:	Descriptor	0,		Code323Len - 1,	40f8h
LABEL_DESC_STACK323:	Descriptor	0,		StackOfTop,	40f2h

GdtLen equ $ - LABEL_GDT
GdtPtr	dw	GdtLen - 1
	dd	090000h + LABEL_GDT

SelectorCode32	equ	LABEL_DESC_CODE32 - LABEL_GDT
SelectorViode	equ	LABEL_DESC_VIODE  - LABEL_GDT
SelectorStack32	equ	LABEL_DESC_STACK32- LABEL_GDT
SelectorData32	equ	LABEL_DESC_DATA32 - LABEL_GDT
SelectorTss	equ	LABEL_DESC_TSS    - LABEL_GDT
SelectorGate	equ	LABEL_GATE_CODE   - LABEL_GDT + 3h
SelectorDir	equ	LABEL_DESC_PAGEDIR - LABEL_GDT
SelectorTbl	equ	LABEL_DESC_PAGETBL - LABEL_GDT

SelectorFlatRW	equ	LABEL_DESC_FLAT_RW - LABEL_GDT
SelectorFlatC	equ	LABEL_DESC_FLAT_C  - LABEL_GDT

SelectorCode323		equ	LABEL_DESC_CODE323 - LABEL_GDT + 3h
SelectorStack323	equ	LABEL_DESC_STACK323 - LABEL_GDT + 3h

[SECTION .idt]
ALIGN 32
[BITS 32]
LABEL_IDT:

%rep	32
	Gate	SelectorCode32,	SpuriousHandler,	0,	8eh
%endrep
.20h:	Gate	SelectorCode32, ClockHandler,	0,	8eh
%rep	95
	Gate	SelectorCode32,	SpuriousHandler,	0,	8eh
%endrep
.80h:	Gate	SelectorCode32,	UserHandler,	0,	8eh

IdtLen	equ	$ - LABEL_IDT
IdtPtr	dw	IdtLen - 1
	dd	090000h + LABEL_IDT

[SECTION .tss]
LABEL_SEG_TSS:
	dd	0	;back
	dd	StackOfTop	;stackoftop0
	dd	SelectorStack32	;stack0
	dd	0	;stackoftop1
	dd	0	;stack1
	dd	0	;stackoftop2
	dd	0	;stack2
	dd	0	;cr3
	dd	0	;eip
	dd	0	;eflag
	dd	0	;eax
	dd	0	;ecx
	dd	0	;edx
	dd	0	;ebx
	dd	0	;esp
	dd	0	;ebp
	dd	0	;esi
	dd	0	;ebi
	dd	0	;es
	dd	0	;cs
	dd	0	;ss
	dd	0	;ds
	dd	0	;fs
	dd	0	;gs
	dd	0	;ldt
	dw	0
	dw	$ - LABEL_SEG_TSS + 2	;
	db	0FFh	;
TSSLen	equ	$ - LABEL_SEG_TSS

[SECTION .s32]
[BITS 32]
LABEL_SEG_STACK32:
	times 512 db 0
StackOfTop equ $ - LABEL_SEG_STACK32 - 1

[SECTION .d32]
LABEL_SEG_DATA32:
	_dwDispPos:	dd	0
	_Message1:	db	"hello word!!!"
	_MCRNumber:	db	0
	_MemChkBuf:	times 512 db 0
	_StructMem:
		_MemAddrL:	dd	0
		_MemAddrH:	dd	0
		_MemLimitL:	dd	0
		_MemLimitH:	dd	0
		_MemType:	dd	0
	_RAMSize:	dd	0
	_szReturn:	db	0Ah,0
	_TblNumber:	dd	0
	_DirNumber:	dd	0
	_test1:	times 50 db 1
	dwDispPos	equ	_dwDispPos - LABEL_SEG_DATA32
	Message1	equ	_Message1  - LABEL_SEG_DATA32
	MCRNumber	equ	_MCRNumber - LABEL_SEG_DATA32
	MemChkBuf	equ	_MemChkBuf - LABEL_SEG_DATA32
	StructMem	equ	_StructMem - $$;LABEL_SEG_DATA32
		MemAddrL	equ	_MemAddrL  - $$;LABEL_SEG_DATA32
		MemAddrH	equ	_MemAddrH  - $$;LABEL_SEG_DATA32
		MemLimitL	equ	_MemLimitL - $$;LABEL_SEG_DATA32
		MemLimitH	equ	_MemLimitH - $$;LABEL_SEG_DATA32
		MemType		equ	_MemType   - $$;LABEL_SEG_DATA32
	RAMSize		equ	_RAMSize   - LABEL_SEG_DATA32
	szReturn	equ	_szReturn  - LABEL_SEG_DATA32
	TblNumber	equ	_TblNumber - $$
	DirNumber	equ	_DirNumber - $$
	test1		equ	_test1      - $$
Data32Len equ $ - LABEL_SEG_DATA32

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
	add eax,LABEL_SEG_STACK32
	mov word [LABEL_DESC_STACK32 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_STACK32 + 4],al
	mov byte [LABEL_DESC_STACK32 + 7],ah

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_DATA32
	mov word [LABEL_DESC_DATA32 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_DATA32 + 4],al
	mov byte [LABEL_DESC_DATA32 + 7],ah

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_TSS
	mov word [LABEL_DESC_TSS + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_TSS + 4],al
	mov byte [LABEL_DESC_TSS + 7],ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_CODE323
	mov word [LABEL_DESC_CODE323 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_CODE323 + 4],al
	mov byte [LABEL_DESC_CODE323 + 7],ah


	xor eax,eax
	mov ax,cs
	shl eax,4
	add eax,LABEL_SEG_STACK32
	mov word [LABEL_DESC_STACK323 + 2],ax
	shr eax,16
	mov byte [LABEL_DESC_STACK323 + 4],al
	mov byte [LABEL_DESC_STACK323 + 7],ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	call GETMEMSIZE

	lgdt [GdtPtr]

	cli

	lidt [IdtPtr]

	in al,92h
	or al,00000010b
	out 92h,al
	
	mov eax,cr0
	or eax,1
	mov cr0,eax

	jmp SelectorCode32:0

	jmp $

GETMEMSIZE:
	mov ebx,0
	mov di,_MemChkBuf
.loop:
	mov eax,0E820h
	mov ecx,20
	mov edx,0534d4150h
	int 15h
	jc LABEL_CHK_FAIL
	add edi,20
	inc byte [_MCRNumber]
	cmp bx,0
	jne .loop
	jmp LABEL_CHK_OK
LABEL_CHK_FAIL:
	mov byte [_MCRNumber],0
LABEL_CHK_OK:
	ret



[SECTION .b32]
[BITS 32]
LABEL_SEG_CODE32:
	mov ax,SelectorData32
	mov ds,ax
	mov es,ax
	mov ax,SelectorStack32
	mov ss,ax
	mov esp,StackOfTop
	mov ax,SelectorViode
	mov gs,ax

	mov ax,SelectorTss
	ltr ax
	
	mov edi,[dwDispPos]
	mov ah,0ch
	mov al,'A'
	mov [gs:edi],ax

	call DisMemSize
	call PageNumber
	call SETPAGE
	
	xchg bx,bx
	call Init8259A
	xchg bx,bx
	int 80h
	sti

	jmp $

	push demo1Len
	push 300000h
	push 090000h+demo1
	call MemCopy

	push demo2Len
	push 400000h
	push 090000h+demo2

	call MemCopy
	call SelectorFlatC:300000h
	call SETPAGE1
	call SelectorFlatC:300000h

	jmp $

	push SelectorStack323
	push StackOfTop
	push SelectorCode323
	push 0
	retf

	mov ecx,10
	xor esi,esi
	xor edi,edi
	mov eax,Message1
	mov esi,eax
	xor eax,eax
	mov ah,0ch
	cld
.1:
	lodsb
	mov [gs:edi],ax
	add edi,2
	loop .1

	jmp $

_SpuriousHandler:
SpuriousHandler	equ	_SpuriousHandler - $$
	xor ax,ax
	iretd

_ClockHandler:
ClockHandler	equ	_ClockHandler - $$
	inc byte [gs:160*11+80]

	mov al,20h
	out 20h,al
	iretd

_UserHandler:
UserHandler	equ	_UserHandler - $$
	mov ah,0ch
	mov al,'U'
	mov [gs:160*10+80],ax
	iretd

Init8259A:
	mov al,011h
	out 20h,al
	call io_delay

	out 0A0h,al
	call io_delay
;--------------------------
	mov al,20h
	out 21h,al
	call io_delay

	mov al,28h
	out 0A1h,al
	call io_delay
;------------------------
	mov al,4h
	out 21h,al
	call io_delay

	mov al,2h
	out 0A1h,al
	call io_delay
;-----------------------
	mov al,001h
	out 21h,al
	call io_delay

	out 0A1h,al
	call io_delay
;----------------------------
	mov al,11111110b
	out 21h,al
	call io_delay

	mov al,11111111b
	out 0A1h,al
	call io_delay

	ret

io_delay:
	nop
	nop
	nop
	nop
	ret	

demo1:
	push es
	push ds

	mov ah,0ch
	mov al,'A'
	mov [gs:160*8+80],ax

	pop ds
	pop es
	retf
demo1Len	equ	$ - demo1

demo2:
	push es
	push ds

	mov ah,0ch
	mov al,'B'
	mov [gs:160*9+80],ax

	pop ds
	pop es
	retf
demo2Len	equ	$ - demo2



SETPAGE:
	push es
	xor eax,eax
	mov ax,SelectorFlatRW
	mov es,ax
	mov edi,BasePageDir
	mov ecx,[ds:DirNumber]
	mov eax,BasePageTbl + 7h
.2:
	stosd
	add eax,4096
	loop .2
	mov edi,BasePageTbl
	mov ecx,[ds:TblNumber]
	mov eax,7h
.3:
	stosd
	add eax,4096
	loop .3

	xor eax,eax
	mov eax,BasePageDir
	mov cr3,eax
	mov eax,cr0
	or eax,80000000h
	mov cr0,eax
	jmp short .4
.4:
	nop
	pop es
	ret


SETPAGE1:
	push es
	xor eax,eax
	mov ax,SelectorFlatRW
	mov es,ax

	mov eax,400000h+7h
	mov dword [es:201c00h],eax

	mov eax,BasePageDir
	mov cr3,eax

	jmp short .14
.14:
	nop
	pop es
	ret



DisMemSize:
	mov ax,SelectorData32
	mov esi,MemChkBuf
	mov cl,[MCRNumber]
.6:
	push ecx
	mov edi,StructMem
	mov ecx,5
.5:
	push dword [esi]
	call DispInt
	pop eax
	;stosd
	mov dword [es:edi],eax
	add edi,4
	add esi,4
	loop .5
	call DispReturn
	mov eax,[MemType]
	cmp eax,01h
	jne .7
	mov eax,[MemAddrL]
	add eax,[MemLimitL]
	mov [RAMSize],eax
.7:
	pop ecx
	loop .6
	push dword [RAMSize]
	call DispInt
	add esp,4
	call DispReturn
	ret

PageNumber:
	xor edx,edx
	mov eax,[RAMSize]
	mov ebx,1000h
	div ebx
	mov dword [TblNumber],eax
	mov ebx,1024
	div ebx
	cmp edx,0
	je .8
	inc eax
.8:
	mov dword [DirNumber],eax
	ret
	

%include "lib.inc"
Code32Len equ $ - LABEL_SEG_CODE32

[SECTION .b323]
[BITS 32]
LABEL_SEG_CODE323:
	xor eax,eax
	call SelectorGate:0
	jmp $
Code323Len equ	$ - LABEL_SEG_CODE323
