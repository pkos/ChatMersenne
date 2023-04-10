.model small
.code

main PROC

     mov eax, 0
     mov ebx, 1
     mov ecx, 1

  Next:
    mov edx, eax   ; save previous term in edx
	shl ebx, 1     ; multiply previous term by 2 using shift left
	add eax, edx   ; add term before pervious to current term
;	add eax, 0x30  ; convert digit in exa to ASCII code character
;	mov eax, 02h   ; write to terminal in DOS
	inc ecx        ; increment counter
	cmp ecx, 10    ; check if we've reached the desired number of terms (execute until ctrl^c)
	jne Next       ; if not, go to next term

main ENDP

END