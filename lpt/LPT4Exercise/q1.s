// LAB Proficiency Test 4 Recursion Practice

  // REGISTER USAGES
    // R0 - first argument (n)
    // R1 - second argument (*a)
    // R2 - third argument (m)
    // R3 -

    // R4 - result
    // R5 - numCalls
    // R6 -
    // R7 -
    // R8 -
    // R9 -
    // R10 -
    // R11 -

    // R12 - scratch register (default)
    // R13 - stack pointer
    // R14 - link register

.text
.global _start
_start:
    MOV     R0, #15               // R0 (n) = 15 ?
    LDR     R1, =array_a          // R1 (a) = array address
    MOV     R2, #50               // R2 (m) = 50 ?
    BL      func
WAIT:
    B WAIT

.global func
func:
    PUSH    {R4-R7, LR}           // save registers R4 - R7 and LR
    SUB     R4, R0, #10           // result = n - 10
    LDR     R12, [R1]             // load a[0] into R12
    ADD     R5, R12, #1           // numcalls = a[0] + 1
    STR     R5, [R1]              // store a[0] = numcalls
L1:
    CMP     R0, #100              //   if( n <= 100 )
    BGT     L2
    ADD     R0, R0, #11           // set argument 1 (R0) = n + 11
    BL      func                  // temp = func(n + 11, a, m), returns to R0
                                  // set first argument R0 = temp
    BL      func                     // result = func(temp, a, m), returns to R0
    MOV     R4, R0                // result = R0, the return value from above
L2:
    CMP     R5, R3                //   if( numCalls < m )
    BGE     RETURN
    STR     R4, [R1, R5, LSL#2]  // a[numCalls] = result
RETURN:
    MOV     R0, R4                // return result
  	POP		  {R4-R7, LR}           // load back registers R4 - R7 and LR
    mov     PC, LR                // end function

array_a:
    .word 0
    .word 1
    .word 2
    .word 3
    .word 4
    .word 5
    .word 6
    .word 7
    .word 8
    .word 9
    .word 10
    .word 11
    .word 12
    .word 13
    .word 14
