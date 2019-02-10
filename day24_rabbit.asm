.CODE

RABBIT_crypt    proc near               ; CODE XREF: _main+3F↑p

var_10          = dword ptr -10h
var_C           = dword ptr -0Ch
var_8           = dword ptr -8
var_4           = dword ptr -4
arg_0           = dword ptr  4
arg_4           = dword ptr  8
arg_8           = dword ptr  0Ch

                sub     esp, 10h
                cmp     [esp+10h+arg_8], 0
                push    esi
                mov     esi, [esp+14h+arg_4]
                jz      loc_4011DF
                push    ebx
                push    edi
                mov     edi, [esp+1Ch+arg_0]
                push    ebp
                lea     ebx, [edi+44h]                

loc_401120:                             ; CODE XREF: RABBIT_crypt+D6↓j
                push    ebx
                call    RABBIT_next_state
                mov     eax, [esp+24h+arg_0]
                add     esp, 4
                mov     edx, [ebx]
                mov     ebx, [edi+4Ch]
                mov     ebp, [edi+54h]
                mov     ecx, [eax+50h]
                mov     edi, [edi+58h]
                mov     eax, edi
                shr     eax, 10h
                shl     ecx, 10h
                xor     ecx, eax
                shl     edi, 10h
                xor     edx, ecx
                mov     ecx, [esp+20h+arg_0]
                mov     [esp+20h+var_10], edx
                mov     ecx, [ecx+60h]
                mov     eax, ecx
                shr     eax, 10h
                xor     eax, edi
                shl     ecx, 10h
                mov     edi, [esp+20h+arg_0]
                xor     ebx, eax
                mov     [esp+20h+var_C], ebx
                mov     edx, [edi+48h]
                mov     eax, edx
                shr     eax, 10h
                xor     eax, ecx
                shl     edx, 10h
                mov     ecx, [esp+20h+arg_8]
                xor     ebp, eax
                mov     eax, [edi+50h]
                shr     eax, 10h
                xor     edx, eax
                mov     [esp+20h+var_8], ebp
                mov     eax, [edi+5Ch]
                xor     eax, edx
                xor     edx, edx
                mov     [esp+20h+var_4], eax

loc_401193:                             ; CODE XREF: RABBIT_crypt+CF↓j
                test    ecx, ecx
                jz      short loc_4011DC
                mov     al, byte ptr [esp+edx+20h+var_10]
                xor     [esi], al
                sub     ecx, 1
                jz      short loc_4011DC
                mov     al, byte ptr [esp+edx+20h+var_10+1]
                xor     [esi+1], al
                sub     ecx, 1
                jz      short loc_4011DC
                mov     al, byte ptr [esp+edx+20h+var_10+2]
                xor     [esi+2], al
                sub     ecx, 1
                jz      short loc_4011DC
                mov     al, byte ptr [esp+edx+20h+var_10+3]
                dec     ecx
                xor     [esi+3], al
                add     edx, 4
                add     esi, 4
                mov     [esp+20h+arg_8], ecx
                cmp     edx, 10h
                jb      short loc_401193
                lea     ebx, [edi+44h]
                test    ecx, ecx
                jnz     loc_401120

loc_4011DC:                             ; CODE XREF: RABBIT_crypt+95↑j
                                        ; RABBIT_crypt+A0↑j ...
                pop     ebp
                pop     edi
                pop     ebx

loc_4011DF:                             ; CODE XREF: RABBIT_crypt+D↑j
                pop     esi
                add     esp, 10h
                retn
RABBIT_crypt    endp

; ---------------------------------------------------------------------------


; =============== S U B R O U T I N E =======================================


RABBIT_g_func   proc near               ; CODE XREF: RABBIT_next_state+D6↓p
                                        ; RABBIT_setiv+156↓p

arg_0           = dword ptr  4

                mov     eax, [esp+arg_0]
                xor     edx, edx
                mul     eax
                xor     eax, edx
                retn
RABBIT_g_func   endp

; ---------------------------------------------------------------------------


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame fpd=20h

RABBIT_next_state proc near             ; CODE XREF: RABBIT_crypt+21↑p
                                        ; RABBIT_setkey+C1↓p

var_24          = dword ptr -24h
var_20          = dword ptr -20h
var_1C          = dword ptr -1Ch
arg_0           = dword ptr  4

                sub     esp, 20h
                push    ebx
                push    ebp
                push    esi
                push    edi
                mov     edi, [esp+30h+arg_0]
                lea     ebp, [esp+10h]
                mov     esi, edi
                mov     ebx, 8
                mov     eax, [edi+40h]
                mov     ecx, [edi+20h]
                add     eax, 4D34D34Dh
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+20h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 0D34D34D3h
                mov     ecx, [edi+24h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+24h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 34D34D34h
                mov     ecx, [edi+28h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+28h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 4D34D34Dh
                mov     ecx, [edi+2Ch]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+2Ch], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 0D34D34D3h
                mov     ecx, [edi+30h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+30h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 34D34D34h
                mov     ecx, [edi+34h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+34h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 4D34D34Dh
                mov     ecx, [edi+38h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+38h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 0D34D34D3h
                mov     ecx, [edi+3Ch]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+3Ch], eax
                sbb     eax, eax
                neg     eax
                sub     ebp, edi
                mov     [edi+40h], eax

loc_4012D0:                             ; CODE XREF: RABBIT_next_state+E7↓j
                mov     eax, [esi+20h]
                add     eax, [esi]
                push    eax
                call    RABBIT_g_func
                add     esp, 4
                mov     [esi+ebp], eax
                lea     esi, [esi+4]
                sub     ebx, 1
                jnz     short loc_4012D0
                xor     esi, esi
                mov     eax, 7

loc_4012F0:                             ; CODE XREF: RABBIT_next_state+12C↓j
                mov     edx, [esp+eax*4+30h+var_24]
                mov     ecx, [esp+eax*4+30h+var_20]
                rol     ecx, 10h
                rol     edx, 10h
                add     edx, ecx
                lea     ecx, [eax+1]
                add     edx, [esp+esi*4+30h+var_20]
                and     ecx, 7
                mov     [edi+esi*4], edx
                mov     ecx, [esp+ecx*4+30h+var_20]
                rol     ecx, 8
                add     ecx, [esp+eax*4+30h+var_20]
                add     eax, 2
                add     ecx, [esp+esi*4+30h+var_1C]
                and     eax, 7
                mov     [edi+esi*4+4], ecx
                add     esi, 2
                cmp     esi, 8
                jl      short loc_4012F0
                pop     edi
                pop     esi
                pop     ebp
                pop     ebx
                add     esp, 20h
                retn
RABBIT_next_state endp

; ---------------------------------------------------------------------------


; =============== S U B R O U T I N E =======================================


RABBIT_setiv    proc near               ; CODE XREF: _main+2E↑p

var_24          = dword ptr -24h
var_20          = dword ptr -20h
var_1C          = dword ptr -1Ch
arg_0           = dword ptr  4
arg_4           = dword ptr  8

                sub     esp, 20h
                mov     eax, [esp+20h+arg_4]
                push    ebx
                push    ebp
                push    esi
                mov     ebx, [eax+4]
                mov     ecx, ebx
                mov     esi, [esp+2Ch+arg_0]
                and     ecx, 0FFFF0000h
                push    edi
                mov     edi, [eax]
                mov     edx, ebx
                mov     eax, edi
                shl     edx, 10h
                shr     eax, 10h
                or      ecx, eax
                mov     [esp+30h+arg_4], 4
                movzx   eax, di
                or      edx, eax
                mov     eax, [esi+20h]
                xor     eax, edi
                mov     [esi+64h], eax
                mov     eax, [esi+24h]
                xor     eax, ecx
                mov     [esi+68h], eax
                mov     eax, [esi+28h]
                xor     eax, ebx
                mov     [esi+6Ch], eax
                mov     eax, [esi+2Ch]
                xor     eax, edx
                mov     [esi+70h], eax
                mov     eax, [esi+30h]
                xor     eax, edi
                lea     edi, [esi+44h]
                mov     [esi+74h], eax
                mov     eax, [esi+34h]
                xor     eax, ecx
                mov     [esi+78h], eax
                mov     eax, [esi+38h]
                xor     eax, ebx
                mov     [esi+7Ch], eax
                mov     eax, [esi+3Ch]
                xor     eax, edx
                mov     [esi+80h], eax
                 db 0Fh ,10h, 06h
                 db 0Fh, 11h, 07h
                 db 0Fh, 10h, 46h, 10h
                 db 0Fh, 11h, 47h, 10h


loc_4013D0:                             ; CODE XREF: RABBIT_setiv+1B3↓j
                mov     eax, [edi+40h]
                lea     ebp, [esp+30h+var_20]
                mov     ecx, [edi+20h]
                add     eax, 4D34D34Dh
                add     eax, ecx
                mov     esi, edi
                cmp     eax, ecx
                mov     [edi+20h], eax
                mov     ebx, 8
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 0D34D34D3h
                mov     ecx, [edi+24h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+24h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 34D34D34h
                mov     ecx, [edi+28h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+28h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 4D34D34Dh
                mov     ecx, [edi+2Ch]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+2Ch], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 0D34D34D3h
                mov     ecx, [edi+30h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+30h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 34D34D34h
                mov     ecx, [edi+34h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+34h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 4D34D34Dh
                mov     ecx, [edi+38h]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+38h], eax
                sbb     eax, eax
                neg     eax
                mov     [edi+40h], eax
                add     eax, 0D34D34D3h
                mov     ecx, [edi+3Ch]
                add     eax, ecx
                cmp     eax, ecx
                mov     [edi+3Ch], eax
                sbb     eax, eax
                neg     eax
                sub     ebp, edi
                mov     [edi+40h], eax

loc_401490:                             ; CODE XREF: RABBIT_setiv+167↓j
                mov     eax, [esi+20h]
                add     eax, [esi]
                push    eax
                call    RABBIT_g_func
                add     esp, 4
                mov     [esi+ebp], eax
                lea     esi, [esi+4]
                sub     ebx, 1
                jnz     short loc_401490
                xor     esi, esi
                mov     eax, 7

loc_4014B0:                             ; CODE XREF: RABBIT_setiv+1AC↓j
                mov     edx, [esp+eax*4+30h+var_24]
                mov     ecx, [esp+eax*4+30h+var_20]
                rol     ecx, 10h
                rol     edx, 10h
                add     edx, ecx
                lea     ecx, [eax+1]
                add     edx, [esp+esi*4+30h+var_20]
                and     ecx, 7
                mov     [edi+esi*4], edx
                mov     ecx, [esp+ecx*4+30h+var_20]
                rol     ecx, 8
                add     ecx, [esp+eax*4+30h+var_20]
                add     eax, 2
                add     ecx, [esp+esi*4+30h+var_1C]
                and     eax, 7
                mov     [edi+esi*4+4], ecx
                add     esi, 2
                cmp     esi, 8
                jl      short loc_4014B0
                sub     [esp+30h+arg_4], 1
                jnz     loc_4013D0
                pop     edi
                pop     esi
                pop     ebp
                pop     ebx
                add     esp, 20h
                retn
RABBIT_setiv    endp

; ---------------------------------------------------------------------------


; =============== S U B R O U T I N E =======================================


RABBIT_setkey   proc near               ; CODE XREF: _main+1F↑p

arg_0           = dword ptr  4
arg_4           = dword ptr  8

                mov     eax, [esp+arg_4]
                push    ebx
                push    ebp
                push    esi
                mov     ebx, [eax+0Ch]
                mov     ecx, ebx
                mov     edx, [eax+4]
                mov     ebp, [eax]
                mov     esi, [esp+0Ch+arg_0]
                shl     ecx, 10h
                push    edi
                mov     edi, [eax+8]
                mov     eax, edi
                shr     eax, 10h
                or      ecx, eax
                mov     [esi+10h], edi
                mov     [esi+4], ecx
                mov     eax, ebp
                shl     eax, 10h
                mov     ecx, ebx
                shr     ecx, 10h
                or      ecx, eax
                mov     [esi], ebp
                mov     [esi+0Ch], ecx
                mov     eax, ebp
                shr     eax, 10h
                mov     ecx, edx
                shl     ecx, 10h
                or      ecx, eax
                mov     [esi+8], edx
                mov     [esi+14h], ecx
                mov     eax, edx
                shr     eax, 10h
                mov     ecx, edi
                shl     ecx, 10h
                or      ecx, eax
                mov     [esi+18h], ebx
                mov     eax, edi
                mov     [esi+1Ch], ecx
                rol     eax, 10h
                mov     [esi+20h], eax
                mov     eax, ebx
                rol     eax, 10h
                mov     [esi+28h], eax
                mov     eax, ebp
                rol     eax, 10h
                mov     [esi+30h], eax
                mov     eax, edx
                rol     eax, 10h
                mov     [esi+38h], eax
                mov     eax, edx
                xor     eax, ebp
                mov     dword ptr [esi+40h], 0
                movzx   eax, ax
                xor     eax, ebp
                mov     [esi+24h], eax
                mov     eax, edi
                xor     eax, edx
                movzx   eax, ax
                xor     eax, edx
                mov     [esi+2Ch], eax
                mov     eax, ebx
                xor     eax, edi
                movzx   eax, ax
                xor     eax, edi
                mov     edi, 4
                mov     [esi+34h], eax
                mov     eax, ebx
                xor     eax, ebp
                movzx   eax, ax
                xor     eax, ebx
                mov     [esi+3Ch], eax


loc_4015D0:                             ; CODE XREF: RABBIT_setkey+CC↓j
                push    esi
                call    RABBIT_next_state
                add     esp, 4
                sub     edi, 1
                jnz     short loc_4015D0
                mov     eax, [esi+10h]
                xor     [esi+20h], eax
                mov     eax, [esi+14h]
                xor     [esi+24h], eax
                mov     eax, [esi+18h]
                xor     [esi+28h], eax
                mov     eax, [esi+1Ch]
                xor     [esi+2Ch], eax
                mov     eax, [esi]
                xor     [esi+30h], eax
                mov     eax, [esi+4]
                xor     [esi+34h], eax
                mov     eax, [esi+8]
                xor     [esi+38h], eax
                mov     eax, [esi+0Ch]
                xor     [esi+3Ch], eax
                 db 0Fh ,10h, 06h
                mov     eax, [esi+40h]
                pop     edi
                 db 0Fh, 11h, 46h, 44h
                 db 0Fh, 10h, 46h, 10h
                 db 0Fh, 11h, 46h, 54h
                 db 0Fh, 10h, 46h, 20h 
                 db 0Fh, 11h, 46h, 64h
                 db 0Fh, 10h, 46h, 30h
                 db 0Fh, 11h, 46h, 74h
                mov     [esi+84h], eax
                pop     esi
                pop     ebp
                pop     ebx
                retn
RABBIT_setkey   endp