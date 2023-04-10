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
print_string PROC console_output_handle:DWORD, str_ptr:PTR BYTE, str_len:DWORD
  push console_output_handle        ; Push all arguments to the stack
  push str_ptr
  push str_len
  call _WriteConsoleA@16            ; Call _WriteConsoleA@16 to print the string
  add esp, 12                       ; Remove the arguments from the stack
  ret                               ; Pop the return address from the stack and adjust the stack pointer
print_string ENDP                   ; End of print_string procedure

main PROC
  push ebp                          ; Save ebp
  mov ebp, esp                      ; Set ebp as base pointer
  xor eax, eax                      ; Set eax to 0 to initialize first calculated Fibonacci number to 0
  mov ebx, 1                        ; Set ebx to 1 to initialize second predetermined sequence of Fibonacci to 1
  mov ecx, 1                        ; Set ecx to 1 to initialize counter to 1
  mov esi, OFFSET counter_msg       ; Store the address of the counter message in esi
  mov edi, OFFSET fib_msg           ; Store the address of the Fibonacci message in edi
  xor edx, edx                      ; Set edx to 0 to initialize a third register for multiplication by shifting left
  mov ecx, 8                        ; Initialize the loop counter to 8 for 256-bit integer
Loop256:
  shl eax, 1                        ; Multiply previous Fibonacci by 2 using shift left
  rcl ebx, 1                        ; Multiply previous Fibonacci by 2 using shift left and carry from eax to ebx
  rcl edx, 1                        ; Multiply previous Fibonacci by 2 using shift left and carry from ebx to edx
  dec ecx                           ; Decrement the loop counter
  jnz Loop256                       ; If not, loop and calculate the next bit of the 256-bit integer
  add eax, ebx                      ; Add multiplied Fibonacci before previous to current term
  adc edx, 0                        ; Add the carry bit to the most significant 32 bits of the 256-bit integer
  push ecx                          ; Push counter value to stack
  push edi                          ; Push address of Fibonacci message to stack
  call print_string                 ; Call print_string procedure to print Fibonacci message
  add esp, 8                        ; Remove the arguments from the stack
  push OFFSET newline               ; Push the address of newline character to stack
  push -1                           ; Push -1 as length of newline character
  push dword [ebp+16]               ; Handle to console output buffer
  call _WriteConsoleA@16            ; Call _WriteConsoleA@16 to print a newline character
  add esp, 12                       ; Remove the arguments from the stack
  inc ecx                           ; Increment counter
  cmp ecx, 50000                    ; Check if we've reached the desired number of sequential Fibonacci numbers
  jne NextLoop                      ; If not, loop and calculate the next Fibonacci number
  xor eax, eax                      ; Return 0 to the operating system
  pop ebp                           ; Restore ebp
  ret 4                             ; Pop the return address and the function arguments and adjust the stack pointer
main ENDP

END