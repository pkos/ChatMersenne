include windows.inc
include kernel32.inc
includelib kernel32.lib

.model small
.stack 100h            ; add a stack declaration
.data
counter_msg db "Counter: ", 0
fib_msg db "Fibonacci Number: ", 0
.code

print_string PROC
  push ebp
  mov ebp, esp
                       ; write string to console
  push 0               ; lpNumberOfCharsWritten (not used)
  push -11             ; hConsoleOutput (handle to the console output, -11 is stdout)
  mov edx, [ebp+8]     ; lpBuffer (pointer to the string to be printed)
  push edx
  call dword ptr [GetStdHandle]

  add esp, 8           ; restore stack frame and return
  pop ebp
  ret
print_string ENDP


main PROC
  push bp              ; set up stack frame
  mov bp, sp
  mov eax, 0           ; initialize first calculated Fibonacci number to 0
  mov ebx, 1           ; initialize second predetermined sequence of Fibonacci to 1
  mov ecx, 1           ; initialize counter to 1

  NextLoop:
    mov edx, eax       ; save previous Fibonacci number in edx
    shl ebx, 1         ; multiply previous Fibonacci by 2 using shift left
    add eax, edx       ; add multiplied Fibonacci before previous to current term

    push ecx           ; print counter
    mov edx, offset counter_msg
    call print_string
    pop ecx
    push ecx
    call print_string

    push eax           ; print Fibonacci number
    mov edx, offset fib_msg
    call print_string
    pop eax
    push eax
    call print_string

    mov dl, 0ah        ; print newline
    mov ah, 2
    int 21h

    inc ecx            ; increment counter
    cmp ecx, 10        ; check if we've reached the desired number of sequential Fibonacci numbers
    jne NextLoop       ; if not, loop and calculate the next Fibonacci number
	
    mov sp, bp         ; clean up stack frame
    pop bp

    mov ah, 4ch        ; exit program
    int 21h

main ENDP

END