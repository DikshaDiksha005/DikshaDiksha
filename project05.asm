.ORIG x3000

; Initialize the runtime stack
LD R6, STACK_START

; Ask user for input
LEA R0, PROMPT
PUTS

; Read a single digit
GETC
OUT

; Convert ASCII to integer
LD R1, NEG_ASCII
ADD R0, R0, R1

; Save original input
ST R0, INPUT_N

; Calculate Fibonacci recursively
JSR FIBONACCI

; Save result
ST R0, RESULT

; Print a new line
LD R0, NEWLINE
OUT

; Print F(
LEA R0, F_TEXT
PUTS

; Print original n
LD R0, INPUT_N
LD R1, ASCII_ZERO
ADD R0, R0, R1
OUT

; Print ) =
LEA R0, EQUAL_TEXT
PUTS

; Load Fibonacci result
LD R2, RESULT

; Initialize tens counter
AND R3, R3, #0

; Determine tens digit
TENS_LOOP
    ADD R4, R2, #-10
    BRn PRINT_RESULT

    ADD R2, R2, #-10
    ADD R3, R3, #1
    BRnzp TENS_LOOP

PRINT_RESULT
    ADD R4, R3, #0
    BRz PRINT_ONES

    ; Print tens digit
    ADD R0, R3, #0
    LD R1, ASCII_ZERO
    ADD R0, R0, R1
    OUT

PRINT_ONES
    ; Print ones digit
    ADD R0, R2, #0
    LD R1, ASCII_ZERO
    ADD R0, R0, R1
    OUT

; Finish output
LD R0, NEWLINE
OUT

HALT

; Recursive Fibonacci function
; Input: R0 = n
; Return: R0 = Fibonacci(n)

FIBONACCI
    ; Create stack frame
    ADD R6, R6, #-3

    ; Save return address and n
    STR R7, R6, #0
    STR R0, R6, #1

    ; Check F(0)
    ADD R1, R0, #0
    BRz FIB_DONE

    ; Check F(1)
    ADD R1, R0, #-1
    BRz FIB_DONE

    ; Recursive call F(n-1)
    ADD R0, R0, #-1
    JSR FIBONACCI

    ; Save first result
    STR R0, R6, #2

    ; Recursive call F(n-2)
    LDR R0, R6, #1
    ADD R0, R0, #-2
    JSR FIBONACCI

    ; Add both Fibonacci results
    LDR R1, R6, #2
    ADD R0, R0, R1

FIB_DONE
    ; Restore return address
    LDR R7, R6, #0

    ; Release stack frame
    ADD R6, R6, #3

    RET

; Program data
PROMPT      .STRINGZ "Please enter a number n: "
F_TEXT      .STRINGZ "F("
EQUAL_TEXT  .STRINGZ ") = "

INPUT_N     .BLKW #1
RESULT      .BLKW #1

NEG_ASCII   .FILL #-48
ASCII_ZERO  .FILL #48
NEWLINE     .FILL x000A
STACK_START .FILL xF000

.END