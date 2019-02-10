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

.DATA?

hApp	dd ?
hIcon	dd ?

.DATA

szClassName		db "flag_cryptor",0
szAppName		db "Hackvent 2018",0

stWinClass 	WNDCLASSEX 	<>
stMessage	MSG			<>

.CODE

Start: 

	call 	GetModuleHandleA, NULL
	mov		hApp, eax
	call	WinMain, hApp, NULL, NULL, SW_SHOWDEFAULT
	call	ExitProcess, NULL

WinMain	PROC, hDlg:DWORD, hPrevInst:DWORD, CmdLine:LPSTR, CmdShow:DWORD 

	mov		stWinClass.wc_cbSize, size WNDCLASSEX
	mov		stWinClass.wc_style, NULL
	mov		stWinClass.wc_lpfnWndProc, offset WndProc
	mov		stWinClass.wc_cbClsExtra, NULL
	mov		stWinClass.wc_cbWndExtra, NULL
	push	hApp
	pop		stWinClass.wc_hInstance
	call	LoadIcon, hApp, 5000
	mov		hIcon, eax
	mov		stWinClass.wc_hIcon, eax
	call	LoadCursor, NULL, IDC_ARROW
	mov		stWinClass.wc_hCursor, eax
	mov		stWinClass.wc_hbrBackground, COLOR_WINDOW
	mov		stWinClass.wc_lpszMenuName, NULL
	mov		stWinClass.wc_lpszClassName, offset szClassName
	call	RegisterClassEx, offset stWinClass
	call	CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassName, offset szAppName, \
			WS_OVERLAPPEDWINDOW-WS_MAXIMIZEBOX-WS_THICKFRAME, CW_USEDEFAULT, CW_USEDEFAULT, \
			400, 120, NULL, NULL, hApp, NULL
	mov		hDlg, eax	
	call	ShowWindow, hDlg, SW_NORMAL
    call 	UpdateWindow, hDlg
    .WHILE TRUE    
        call	GetMessage, offset stMessage, NULL, 0, 0 
        .BREAK .IF eax==FALSE        	
             call	IsDialogMessage, hDlg, offset stMessage
        	.IF	eax==FALSE
				call 	TranslateMessage, offset stMessage
				call	DispatchMessage, offset stMessage
			.ENDIF
    .ENDW
    mov     eax, stMessage.ms_wParam 
    ret
    
WinMain	ENDP

.DATA

szEditClass	db "STATIC",0
szButClass	db "BUTTON",0
szOk		db "Encrypt",0
szExit		db "Exit",0
szFontName	db "Calibri",0

.DATA?

hFile 		dd ?
dwFileSize	dd ?
hMemFile	dd ?
pMemFile	dd ?
hMemFlag	dd ?
pMemFlag	dd ?
dwBuffer	dd ?
hFont 		dd ?
hEditSerial	dd ?
dwFlagSize	dd ?
hFlag		dd ?

FILETIME	STRUCT
  dwLowDateTime		dd ?
  dwHighDateTime	dd ?
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

.DATA

szCaption	db "HACKVent 2018",0
szFileName 	db "flag",0
szMsg		db "flag encryptor ready - press encrypt",0
szFlag		db "flag_encrypted",0

stRabbit 		RABBIT_ctx 	<>
stFileTime		FILETIME 	<>
stSystemTime	SYSTEMTIME 	<>

.CODE

WndProc	PROC, hDlg:DWORD, uMsg:UINT, wParam:DWORD, lParam:DWORD
	.IF		uMsg==WM_CREATE
		call	CreateWindowEx, WS_EX_CLIENTEDGE, offset szEditClass, NULL,\ 
        		WS_CHILD+WS_VISIBLE+ES_CENTER+ES_AUTOHSCROLL+WS_TABSTOP,\ 
        		12, 20, 366, 20, hDlg, 2000, hApp, NULL
		mov		hEditSerial, eax
		call	SetFocus, eax		
		call	CreateWindowEx, WS_EX_STATICEDGE, offset szButClass, offset szOk,\ 
                WS_CHILD+WS_VISIBLE+WS_TABSTOP,\ 
                12, 50, 60, 28, hDlg, 3000, hApp, NULL
		call	CreateWindowEx, WS_EX_STATICEDGE, offset szButClass, offset szExit,\ 
                WS_CHILD+WS_VISIBLE+WS_TABSTOP,\ 
                318, 50, 60, 28, hDlg, 4000, hApp, NULL                
		call	CenterWindow, hDlg
       	call	CreateFontA, 16, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
        		OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH, offset szFontName
       	mov		hFont, eax			
       	call	SendDlgItemMessage, hDlg, 2000, WM_SETFONT, HFONT, NULL
       	call	SendDlgItemMessage, hDlg, 3000, WM_SETFONT, HFONT, NULL		
       	call	SendDlgItemMessage, hDlg, 4000, WM_SETFONT, HFONT, NULL     	
       	call	SetDlgItemText, hDlg, 2000, offset szMsg	
	.ELSEIF	uMsg==WM_COMMAND
		and 	wParam, 0FFFFh
		.IF		wParam==3000
			call	CreateFile, offset szFileName, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ+FILE_SHARE_WRITE, \
			NULL, OPEN_EXISTING, NULL, NULL
			.IF		!eax==INVALID_HANDLE_VALUE
				mov		hFile, eax
				call	GetFileSize, hFile, NULL
				mov		dwFileSize, eax
				xor 	edx, edx
				mov 	ecx, 2
				div 	ecx
				.IF !edx==0
					inc dwFileSize
				.ENDIF
				call	GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, dwFileSize
				mov		hMemFile, eax
				call	GlobalLock, eax
				mov		pMemFile, eax
				push 	eax
				call	ReadFile, hFile, pMemFile, dwFileSize, offset dwBuffer, NULL
				call	CloseHandle, hFile
				pop 	eax
				.IF ![eax]==474E5089h
					call	SetDlgItemText, hDlg, 2000, offset szNoGood	
				.ELSE
					mov 	eax, dwFileSize
					shr 	eax, 1
					mov 	dwFlagSize, eax
					call	GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, eax
					mov		hMemFlag, eax
					call	GlobalLock, eax
					mov		pMemFlag, eax
					xor 	ebx, ebx
					mov 	edx, ebx
					mov 	ecx, edx
					mov 	esi, pMemFile
					mov 	edi, pMemFlag
					.WHILE !ecx==dwFlagSize
						mov bl, byte ptr [esi+ecx*2]
						shr bl, 4
						shl bl, 4
						mov dl, byte ptr [esi+1+ecx*2]
						shr dl, 4
						or bl, dl
						mov byte ptr [edi+ecx], bl
						inc ecx
					.ENDW
					call	GlobalUnlock, pMemFile
					call	GlobalFree, hMemFile	
					call	GetRegDate					
					call	RABBIT_setkey, offset stRabbit, offset rabbit_key
					add		esp, 2*4
					call	RABBIT_setiv, offset stRabbit, offset stFileTime
					add		esp, 2*4
					call	RABBIT_crypt, offset stRabbit, pMemFlag, dwFlagSize
					add		esp, 3*4			    
				    call	CreateFile, offset szFlag, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ+FILE_SHARE_WRITE, \
					   		NULL, CREATE_ALWAYS, NULL, NULL
					.IF	!eax==INVALID_HANDLE_VALUE
						mov		hFlag, eax
						call	WriteFile, eax, pMemFlag, dwFlagSize, offset dwBuffer, NULL
						.IF !eax==0
							call	SetDlgItemText, hDlg, 2000, offset szSuccess	
						.ENDIF
					.ELSE
						call	SetDlgItemText, hDlg, 2000, offset szWrite
					.ENDIF
				.ENDIF				
				call	CloseHandle, hFlag
				call	GlobalUnlock, pMemFlag				
				call	GlobalFree, hMemFlag
			.ELSE
				call	SetDlgItemText, hDlg, 2000, offset szError	
			.ENDIF
		.ELSEIF	wParam==4000		
			call	PostQuitMessage, NULL
		.ENDIF
	.ELSEIF	uMsg==WM_LBUTTONDOWN
		call	PostMessageA, hDlg, WM_NCLBUTTONDOWN, HTCAPTION, lParam		
  	.ELSEIF	uMsg==WM_DESTROY
    	call	PostQuitMessage, NULL
	.ELSE		
        call	DefWindowProc, hDlg, uMsg, wParam, lParam
   	.ENDIF
   	ret

WndProc	ENDP

.DATA

rabbit_key db 087h, 005h, 089h, 0cdh, 0a8h, 075h, 062h, 0efh, 038h, 045h, 0ffh, 0d1h, 041h, 037h, 054h, 0d5h

szSubKey	db "SOFTWARE\HACKvent2018",0
szSuccess	db "success: flag encrypted and written to disk",0
szError		db "error: could not open file - supply a flag please",0
szWrite		db "error: could not write the encrypted flag",0
szNoGood	db "error: this flag is not allowed",0

.DATA?

hRegKey dd ?

.CODE

GetRegDate	PROC
	call	RegCreateKeyExA, HKEY_CURRENT_USER, offset szSubKey, NULL, NULL, NULL, KEY_WRITE+KEY_READ, NULL, offset hRegKey, NULL
	call	RegQueryInfoKeyA, hRegKey, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, offset stFileTime
	call	RegCloseKey, hRegKey
	call	FileTimeToSystemTime, offset stFileTime, offset stSystemTime
	call	SystemTimeToFileTime, offset stSystemTime, offset stFileTime
	call	RegDeleteKeyA, HKEY_CURRENT_USER, offset szSubKey
	ret
GetRegDate	ENDP

CenterWindow	PROC, hDlg:DWORD

.DATA

stDlgRect	RECT	<>
stDeskRect	RECT	<>

.CODE

LOCAL	DlgHight:DWORD
LOCAL	DlgWidth:DWORD
LOCAL	Dlg_X:DWORD
LOCAL	Dlg_Y:DWORD

	call	GetWindowRect, hDlg, offset stDlgRect
	call	GetDesktopWindow	
	call	GetWindowRect, eax, offset stDeskRect	
	mov		eax, stDlgRect.rc_bottom
	sub		eax, stDlgRect.rc_top
	mov		DlgHight, eax
	mov		eax, stDlgRect.rc_right
	sub		eax, stDlgRect.rc_left
	mov		DlgWidth, eax	
	mov		eax, stDeskRect.rc_bottom
	sub		eax, DlgHight
	shr		eax, 1
	mov		Dlg_Y, eax
	mov		eax, stDeskRect.rc_right
	sub		eax, DlgWidth
	shr		eax, 1
	mov		Dlg_X, eax
	call	MoveWindow, hDlg, Dlg_X, Dlg_Y, DlgWidth, DlgHight, TRUE
	xor		eax, eax
	ret
	
CenterWindow	ENDP

End Start