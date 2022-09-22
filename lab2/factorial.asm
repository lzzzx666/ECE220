    .ORIG x3000

    LD R6,STACK_BASE
    AND R0,R0,#0
TEST_LOOP
    ADD R0,R0,#1
    ST R0,TEST_VAL
    ADD R1,R0,#-7
    BRz TEST_DONE
    JSR FACTORIAL
    ADD R1,R6,R6    ; check for stack corruption
    BRz STACK_OK
    LEA R0,BAD_STACK_MSG
    BRnzp TEST_FAIL
STACK_OK
    LEA R1,TABLE
    LD R2,TEST_VAL
    ADD R1,R1,R2
    LDR R1,R1,#0
    ADD R1,R1,R0
    BRz TEST_PASSED
    LEA R0,BAD_RESULT_MSG
TEST_FAIL
    PUTS
    LD R0,TEST_VAL
    LD R1,ASCII_ZERO
    ADD R0,R0,R1
    OUT
    HALT
TEST_PASSED
    LD R0,TEST_VAL
    BRnzp TEST_LOOP
TEST_DONE
    LEA R0,MSG_PASSED
    PUTS
    HALT
    
STACK_BASE .FILL x8000
TEST_VAL .BLKW #1
BAD_STACK_MSG .STRINGZ "Stack corrupted when computing factorial of "
BAD_RESULT_MSG .STRINGZ "Wrong answer when computing factorial of "
MSG_PASSED .STRINGZ "All tests passed!"
ASCII_ZERO .FILL x0030
TABLE
    .FILL #-1   ; - 0! not used
    .FILL #-1   ; - 1!
    .FILL #-2   ; - 2!
    .FILL #-6   ; - 3!
    .FILL #-24  ; - 4!
    .FILL #-120 ; - 5!
    .FILL #-720 ; - 6!
    
; MULT--multiply top two values on 
;     INPUTS: R0, R1--operands
;     OUTPUTS: R0: product
;     CALLER-SAVED: R1, R2, R7
;     CALLEE-SAVED: R3, R4, R5, R6
MULT
    AND R2,R2,#0
    ADD R1,R1,#0
    BRz MULTDONE
MULTLOOP
    ADD R2,R2,R0
    ADD R1,R1,#-1
    BRnp MULTLOOP
MULTDONE
    ADD R0,R2,#0
    RET

; STACKMULT--multiply top two values on 
;            stack and push product to
;            stack
;     CALLER-SAVED: R0, R1, R2, R7
;     CALLEE-SAVED: R3, R4, R5, R6
;     ASSUMPTIONS:
;         R6 points to a valid stack with
;            2+ things on it
STACKMULT
    ST R7,SM_R7     ; save R7
    LDR R1,R6,#0    ; pop first value to R1
    ADD R6,R6,#1
    LDR R0,R6,#0    ; pop second value to R0
    ADD R6,R6,#1
    JSR MULT        ; multiply R0 <- R0 * R1
    ADD R6,R6,#-1   ; push R0
    STR R0,R6,#0
    LD R7,SM_R7     ; restore R7
    RET
SM_R7 .BLKW #1

; FACTORIAL--replace R0 with its factorial
;     INPUT: R0 -- the input value
;     OUTPUT: R0 -- (original R0)!
;             R0 * (R0 - 1) * ... * 1
;     CALLER-SAVED: ALL REGISTERS
;     ASSUMPTIONS: 
;         R0 is at least 1
;         R6 points to a valid stack
FACTORIAL
    ; write your code here
    ; remember that STACKMULT may change
    ;    R0, R1, R2, and R7
    ST  R7,SAVER7
    ADD R3,R0,#0
    ADD R6,R6,#-1;?push?R0
    STR R3,R6,#0
    FAC_LOOP 
    ADD R3,R3,#-1
    BRz END
    ADD R6,R6,#-1;?push?R1
    STR R3,R6,#0
    JSR STACKMULT
    BRnzp FAC_LOOP

    END
    LDR R0, R6,#0
    ADD R6,R6,#1
    LD R7,SAVER7
    RET

SAVER7 .BLKW #1
.END

