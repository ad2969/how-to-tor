// LPTest4 - ad2969 (60505170)

  // REGISTER USAGES
    // R0 - first argument (*x)
    // R1 - second argument (*y)
    // R2 - third argument (m) - length of x
    // R3 - fourth argument (n) - length of y

    // R4 - m-1,
    // R5 - X[m-1]
    // R6 - n-1,
    // R7 - Y[n-1]
    // R8 - a
    // R9 - b
    // R10 -
    // R11 -

    // R12 - scratch register (default)
    // R13 - stack pointer
    // R14 - link register

.text
.global _start
_start:
    LDR     R0, =array_x          // R0 (*x) = address of array_x
    LDR     R1, =array_y          // R1 (*y) = address of array_y
    MOV     R2, #7                // R2 (m) = 7
    MOV     R3, #6                // R3 (n) = 6
    BL      func
WAIT:
    B WAIT

.global func
func:
    PUSH    {R4-R11, LR}
check_m:
    CMP     R2, #0                     // if(m == 0)
    BNE     check_n
      MOV     R0, #0              // set return value to be zero
      B       RETURN
check_n:
    CMP     R3, #0                    // if(n == 0)
    BNE     IF1
      MOV     R0, #0              // set return value to be zero
      B       RETURN
IF1:
    SUB     R4, R2, #1            // save m - 1 into R4
    ADD     R12, R0, R4           // compute address of X[m-1]
    LDRB    R5, [R12]             // load X[m-1] into R5
    SUB     R6, R3, #1            // save n - 1 into R6
    ADD     R12, R1, R6           // compute address of Y[n-1]
    LDRB    R7, [R12]             // load Y[n-1] into R7
    CMP     R5, R7                   // if( X[m-1] == Y[n-1] )
    BNE     IF2
      LDR     R0, =array_x        // set argument 1 correctly
      LDR     R1, =array_y        // set argument 2 correctly
      MOV     R2, R4              // set argument 3 to (m - 1)
      MOV     R3, R6              // set argument 4 to (n - 1)
      BL      func                // recursive call
      ADD     R0, R0, #1          // func(X, Y, m-1, n-1) + 1;
      B       RETURN
IF2:
    // compute a = func(X, Y, m, n-1);
    LDR     R0, =array_x          // set argument 1 correctly
    LDR     R1, =array_y          // set argument 2 correctly
    MOV     R2, R2                // set argument 3 to m
    MOV     R3, R6                // set argument 4 to (n - 1)
    BL      func                  // recursive call
    MOV     R8, R0                // a = return value
    // compute b = func(X, Y, m-1, n);
    LDR     R0, =array_x          // set argument 1 correctly
    LDR     R1, =array_y          // set argument 2 correctly
    SUB     R2, R2, #1            // set argument 3 to (m - 1)
    ADD     R3, R3, #1            // set argument 4 to n
    BL      func                  // recursive call
    MOV     R9, R0                // b = return value

    CMP     R8, R9                  // if( a > b )
    BLE     return_b
      MOV     R0, R8              // sets return value = a
      B       RETURN
return_b:
    MOV R0, R9                    // sets return value = b
    B       RETURN
RETURN:
  	POP		  {R4-R11, LR}           // load back registers R4 - R7 and LR
    mov     PC, LR                // end function


array_x:
    .asciz "ABCBDAB"

array_y:
    .asciz "BDCABA"
