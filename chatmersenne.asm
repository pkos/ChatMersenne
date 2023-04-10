.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib      ; link to the kernel32 library for GetStdHandle and WriteConsoleA
includelib user32.lib        ; link to the user32 library for ExitProcess
include windows.inc          ; include the Windows API header

extrn GetStdHandle:PROC      ; declare GetStdHandle function from kernel32 library
extrn ExitProcess:PROC       ; declare ExitProcess function from user32 library
extrn _WriteConsoleA@16:PROC ; declare _WriteConsoleA@16 function from kernel32 library

.data
counter_msg db "Counter: ", 0       ; message to display the counter
fib_msg db "Fibonacci Number: ", 0  ; message to display the Fibonacci number
newline db 0ah, 0                   ; new line character to print at end of each loop iteration

.code

print_string PROC
  push ebx             ; save ebx
  push ecx             ; save ecx
  push edx             ; save edx
  push ebp             ; save ebp
  mov ebp, esp         ; set ebp as base pointer

  push dword [ebp+12]  ; push the console output buffer handle to stack
  call GetStdHandle    ; call GetStdHandle to get the standard output handle
  mov edx, eax         ; store the handle in edx

  mov eax, [ebp+8]     ; move the address of string to print to eax
  push dword [ebp+16]  ; push the length of string to print to stack
  push eax             ; push the address of string to print to stack
  push dword [ebp+12]  ; push the console output buffer handle to stack
  push edx             ; push the standard output handle to stack
  call _WriteConsoleA@16 ; call _WriteConsoleA@16 to print the string

  pop ebp              ; restore ebp
  pop edx              ; restore edx
  pop ecx              ; restore ecx
  pop ebx              ; restore ebx
  ret 12               ; pop the return address from the stack and adjust the stack pointer
print_string ENDP      ; end of print_string procedure

main PROC
  push ebp             ; save ebp
  mov ebp, esp         ; set ebp as base pointer
  xor eax, eax         ; set eax to 0 to initialize first calculated Fibonacci number to 0
  mov ebx, 1           ; set ebx to 1 to initialize second predetermined sequence of Fibonacci to 1
  mov ecx, 1           ; set ecx to 1 to initialize counter to 1

NextLoop:              ; start of loop to calculate and print Fibonacci numbers
  mov edx, eax         ; save previous Fibonacci number in edx
  shl ebx, 1           ; multiply previous Fibonacci by 2 using shift left
  add eax, edx         ; add multiplied Fibonacci before previous to current term

  push ecx             ; push counter value to stack
  mov edx, OFFSET counter_msg  ; move the address of counter message to edx
  call print_string    ; call print_string procedure to print counter message
  pop ecx              ; pop counter value from stack

  push eax             ; push current Fibonacci number to stack
  mov edx, OFFSET fib_msg  ; move the address of Fibonacci message to edx
  call print_string    ; call print_string procedure to print Fibonacci message
  pop eax              ; pop current Fibonacci number from stack

  push OFFSET newline  ; push the address of newline character to stack
  push -1
  push dword [ebp+16]  ; handle to console output buffer
  
  call _WriteConsoleA@16  ; call _WriteConsoleA@16 to print a newline character
  add esp, 12
  
  inc ecx              ; increment counter
  cmp ecx, 10          ; check if we've reached the desired number of sequential Fibonacci numbers
  jne NextLoop         ; if not, loop and calculate the next Fibonacci number
  
  xor eax, eax         ; return 0 to the operating system
  pop ebp
  ret 4
  main ENDP

END