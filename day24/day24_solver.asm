.686P
MODEL FLAT, STDCALL
JUMPS
LOCALS

UNICODE=0

INCLUDE C:\TASM\W32.INC
INCLUDE RABBIT.ASM

EXTRN	RegDeleteKeyA : PROC
EXTRN	RegQueryInfoKeyA : PROC
EXTRN	FileTimeToSystemTime : PROC
EXTRN	SystemTimeToFileTime : PROC
EXTRN	_wsprintfA		: PROC
EXTRN 	GetFileTime	: PROC

.DATA?

hApp	dd ?

hFile 		dd ?
dwFileSize	dd ?
hMemFile	dd ?
pMemFile	dd ?
hMemFlag	dd ?
pMemFlag	dd ?
hMemTemp	dd ?
pMemTemp	dd ?
dwBuffer	dd ?
dwFlagSize	dd ?
hFlag		dd ?
dwCount		dd ?
dwMinCount	dd ?

FILETIME	STRUCT
  dwLowDateTime		dd ?
  dwHighDateTime	dd ?
ENDS

SYSTEMTIME	STRUCT
  wYear 		dw ?
  wMonth 		dw ?
  wDayOfWeek	dw ?
  wDay			dw ?
  wHour			dw ?
  wMinute		dw ?
  wSecond		dw ?
  wMilliseconds	dw ?
ENDS

RABBIT_state STRUCT
	rx dd 8 dup (?)
	rc dd 8 dup (?)
	carry dd ?
ENDS

RABBIT_ctx STRUCT
	m RABBIT_state <>
	w RABBIT_state <>
ENDS

.DATA

szFileName 	db "flag",0
szFlag		db "flag_encrypted",0

stRabbit 		RABBIT_ctx 	<>
stSystemTime	SYSTEMTIME 	<>
stFileTime		FILETIME 	<>

rabbit_key db 087h, 005h, 089h, 0cdh, 0a8h, 075h, 062h, 0efh, 038h, 045h, 0ffh, 0d1h, 041h, 037h, 054h, 0d5h

szTitle	db "hackvent",0
szFmat	db "found rabbit key: %.8x%.8x",0
szOut	db 100 dup (?)

.CODE

Start: 

	call 	GetModuleHandleA, NULL
	mov		hApp, eax

	call	CreateFile, offset szFlag, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ+FILE_SHARE_WRITE, \
	NULL, OPEN_EXISTING, NULL, NULL
	.IF		!eax==INVALID_HANDLE_VALUE
		mov		hFile, eax		
		call	GetFileSize, hFile, NULL
		mov		dwFileSize, eax		
		call	GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, dwFileSize
		mov		hMemFile, eax		
		call	GlobalLock, eax
		mov		pMemFile, eax		
		call	ReadFile, hFile, pMemFile, dwFileSize, offset dwBuffer, NULL
		call	GetFileTime, hFile, offset stFileTime, NULL, NULL 	; we get the creation date from the encrypted flag
		call	CloseHandle, hFile		
		call	GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, dwFileSize
		mov		hMemTemp, eax		
		call	GlobalLock, eax
		mov		pMemTemp, eax
		call	FileTimeToSystemTime, offset stFileTime, offset stSystemTime
		sub		stSystemTime.wMinute, 2 ; substract two minutes from the timestamp
		mov 	dwMinCount, 0
		.WHILE !dwMinCount==5 ; brute in the 5 minutes range
			mov 	dwCount, 0
			.WHILE dwCount<60000
				mov ecx, dwFileSize
				mov esi, pMemFile
				mov edi, pMemTemp
				repz movsb			
				mov ecx, 1000
				mov eax, dwCount
				xor edx, edx
				div ecx
				mov		stSystemTime.wSecond, ax
				mov		stSystemTime.wMilliseconds, dx
				call	SystemTimeToFileTime, offset stSystemTime, offset stFileTime
				xor eax, eax
				mov ecx, 2*17
				lea edi, stRabbit
				repz stosd				
				call	RABBIT_setkey, offset stRabbit, offset rabbit_key
				add		esp, 2*4
				call	RABBIT_setiv, offset stRabbit, offset stFileTime
				add		esp, 2*4
				call	RABBIT_crypt, offset stRabbit, pMemTemp, dwFileSize
				add		esp, 3*4
				mov	eax, pMemTemp
				.IF dword ptr [eax]==10004485h ; .PNG header, upper nibbles					
					call	wsprintf, offset szOut, offset szFmat, stFileTime.dwHighDateTime, stFileTime.dwLowDateTime
					add		esp, 4*4
					call 	MessageBoxA, NULL, offset szOut, offset szTitle, MB_OK
					mov 	eax, dwFileSize
					shl 	eax, 1
					mov 	dwFlagSize, eax
					call	GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, eax
					mov		hMemFlag, eax
					call	GlobalLock, eax
					mov		pMemFlag, eax
					xor 	ebx, ebx
					mov 	edx, ebx
					mov 	ecx, edx
					mov 	esi, pMemTemp
					mov 	edi, pMemFlag
					.WHILE !ecx==dwFileSize ; reverse byte to nibbles
						mov bl, byte ptr [esi+ecx]
						mov dl, bl
						shr bl, 4
						shl bl, 4
						and dl, 0fh
						shl dl, 4
						mov byte ptr [edi+ecx*2], bl
						mov byte ptr [edi+1+ecx*2], dl
						inc ecx
					.ENDW		
					call	CreateFile, offset szFileName, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ+FILE_SHARE_WRITE, \
					   		NULL, CREATE_ALWAYS, NULL, NULL
					.IF	!eax==INVALID_HANDLE_VALUE
						mov		hFile, eax
						call	WriteFile, eax, pMemFlag, dwFlagSize, offset dwBuffer, NULL
						call 	CloseHandle, hFile
					.ENDIF								
					call	ExitProcess, NULL
				.ENDIF
				inc dwCount
			.ENDW
			inc stSystemTime.wMinute
			inc dwMinCount
		.ENDW		
		call	GlobalUnlock, pMemFlag
		call	GlobalFree, hMemFlag
		call	GlobalUnlock, pMemTemp
		call	GlobalFree, hMemTemp
		call	GlobalUnlock, pMemFlag				
		call	GlobalFree, hMemFlag
	.ENDIF

	call	ExitProcess, NULL

End Start