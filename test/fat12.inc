BS_OEMName	db	'ForrestY'
BPB_BytePerSec	dw	0200h
BPB_SecPerClus	db	01h
BPB_RsvdSecCnt	dw	01h
BPB_NumFATs	db	02h
BPB_RootEntCnt	dw	0E0h
BPB_TotSec16	dw	0B40h
BPB_Media	db	0F0h
BPB_FATSz16	dw	09h
BPB_SecPerTrk	dw	012h
BPB_NumHeads	dw	02h
BPB_HiddSec	dd	0h
BPB_TotSec32	dd	0h
BS_DrvNum	db	0h
BS_Reserved1	db	0h
BS_BootSig	db	029h
BS_VolID	dd	0h
BS_VolLab	db	'ORANGES.02 '
BS_FileSysType	db	'FAT12   '

D_RootStartSec	dw	013h
D_RootNumSec	dw	0Eh
D_TmpSecAddr	dw	0500h
D_SearchFileName	db	'LOADER  BIN'

D_FileClus:
	D_F_LowClus	db	0
	D_F_HighClus	db	0
	D_F_LowByte	dw	0
	D_F_NumClus	db	0
	D_F_NowFAT	db	0
	D_F_SD		db	0
