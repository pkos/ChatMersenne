; Set the processor type and calling convention
.386
.model flat, stdcall
option casemap:none

; Link to kernel32 library for GetStdHandle and WriteConsoleA
includelib kernel32.lib
; Link to user32 library for ExitProcess
includelib user32.lib
; Include the Windows API header
include windows.inc

; Declare external procedures
extrn GetStdHandle:PROC
extrn ExitProcess:PROC
extrn _WriteConsoleA@16:PROC

.data
; Message to display the counter
counter_msg db "Counter: ", 0
; Message to display the Fibonacci number
fib_msg db "Fibonacci Number: ", 0
; New line character to print at end of each loop iteration
newline db 0ah, 0

.code
; Procedure to print a string to the console
print_string PROC
  push ebx                          ; Save ebx
  push ecx                          ; Save ecx
  push edx                          ; Save edx
  push ebp                          ; Save ebp
  mov ebp, esp                      ; Set ebp as base pointer
  push dword [ebp+12]               ; Push the console output buffer handle to stack
  call GetStdHandle                 ; Call GetStdHandle to get the standard output handle
  mov edx, eax                      ; Store the handle in edx
  mov eax, [ebp+8]                  ; Move the address of string to print to eax
  push dword [ebp+16]               ; Push the length of string to print to stack
  push eax                          ; Push the address of string to print to stack
  push dword [ebp+12]               ; Push the console output buffer handle to stack
  push edx                          ; Push the standard output handle to stack
  call _WriteConsoleA@16            ; Call _WriteConsoleA@16 to print the string
  pop ebp                           ; Restore ebp
  pop edx                           ; Restore edx
  pop ecx                           ; Restore ecx
  pop ebx                           ; Restore ebx
  ret 12                            ; Pop the return address from the stack and adjust the stack pointer
print_string ENDP                   ; End of print_string procedure

main PROC
  push ebp                          ; Save ebp
  mov ebp, esp                      ; Set ebp as base pointer
  xor eax, eax                      ; Set eax to 0 to initialize first calculated Fibonacci number to 0
  mov ebx, 1                        ; Set ebx to 1 to initialize second predetermined sequence of Fibonacci to 1
  mov ecx, 1                        ; Set ecx to 1 to initialize counter to 1
NextLoop:                           ; Start of loop to calculate and print Fibonacci numbers
  mov edx, eax                      ; Save previous Fibonacci number in edx
  shl ebx, 1                        ; Multiply previous Fibonacci by 2 using shift left
  add eax, edx                      ; Add multiplied Fibonacci before previous to current term
  push ecx                          ; Push counter value to stack
  mov edx, OFFSET counter_msg       ; Move the address of counter message to edx
  call print_string                 ; Call print_string procedure to print counter message
  pop ecx                           ; Pop counter value from stack
  push eax                          ; Push current Fibonacci number to stack
  mov edx, OFFSET fib_msg           ; Move the address of Fibonacci message to edx
  call print_string                 ; Call print_string procedure to print Fibonacci message
  pop eax                           ; Pop current Fibonacci number from stack
  push OFFSET newline               ; Push the address of newline character to stack
  push -1                           ; Push -1 as length of newline character
  push dword [ebp+16]               ; Handle to console output buffer
  call _WriteConsoleA@16            ; Call _WriteConsoleA@16 to print a newline character
  add esp, 12                       ; Remove the arguments from the stack
  inc ecx                           ; Increment counter
  cmp ecx, 10                       ; Check if we've reached the desired number of sequential Fibonacci numbers
  jne NextLoop                      ; If not, loop and calculate the next Fibonacci number
  xor eax, eax                      ; Return 0 to the operating system
  pop ebp                           ; Restore ebp
  ret 4                             ; Pop the return address and the function arguments and adjust the stack pointer
main ENDP

END