	.ORIG x3000
	LD R0, Num
	JSR PrintNum
	HALT
Num	.FILL #725
; Subroutine PrintNum 
; Uses a Stack to convert a Signed Number in 2's complement
; from Binary to ASCII and Displays it on the console
; Input: R0 has the number
; Output: None
PrintNum
	ST R7, PNSaveR7
	ST R5, PNSaveR5
	ST R1, PNSaveR1
	ST R0, PNSaveR0
	ADD R1,R0,#0
	BRp Positive
	LD  R0,MinusChar
	TRAP x21
	NOT R1,R1
	ADD R1,R1,#1
Positive
	AND R0,R0,#0
	ADD R0,R0,#5	; Number range is [-32768, 32767] -- 5 digits
	JSR StackInit
	ADD R0,R1,#0
Again	JSR DIV10
	JSR PUSH 	; Should check R5 but...
	ADD R0,R1,#0
	BRp Again
; Print the digits by popping them off the stack
	LD  R1,NumOffset
More	JSR POP
	ADD R5,R5,#0
	BRz Done
	ADD R0,R0,R1
	TRAP x21
	BRnzp More
Done	LD R7, PNSaveR7
	LD R5, PNSaveR5
	LD R1, PNSaveR1
	LD R0, PNSaveR0
	RET
MinusChar .FILL x2D
NumOffset .FILL x30	
PNSaveR0  .BLKW #1
PNSaveR1  .BLKW #1
PNSaveR5  .BLKW #1
PNSaveR7  .BLKW #1


; Subroutine Div10
; Divides a number by 10
; Input: R0 (the dividend)
; Outputs: R0 (the remainder), R1(the quotient)
DIV10    AND  R1, R1, #0
DAGAIN   ADD  R0, R0, #-10
         BRn  DDONE
         ADD  R1, R1, #1
         BR   DAGAIN
DDONE    ADD  R0, R0, #10
         RET


; This is a Stack Implementation
; The stack is of capacity StackCapacity elements
; Each element is a number (could be char)
; Subroutine StackInit
; Invoked once to initialize the SP and size
; to the bottom of the stack
; Input: Max Capacity of the Stack in R0
; Output: None
StackInit
	ST R0,StackCapacity
	AND R0,R0,#0
	ST R0,StackSize
	LD R0,StackBottom	
	ST R0,StackPtr
	LD R0,StackCapacity ;Restore R0
	RET
StackBottom .FILL x3000
StackSize   .BLKW #1
StackPtr  .BLKW #1
StackCapacity  .BLKW #1

; Subroutine PUSH
; Invoked to push an element
; Input: R0 has elemement to push
; Output: R5 has failure(0)/success(1)
PUSH
	ST  R1,PUSaveR1
	ST  R2,PUSaveR2
	AND R5,R5,#0
	LD  R1,StackSize
	LD  R2,StackCapacity
	NOT R2,R2
	ADD R2,R2,#1
	ADD R2,R1,R2
	BRz StackFull
	LD  R2,StackPtr
	ADD R2,R2,#-1
	STR R0,R2,#0		; Add element
	ST  R2,StackPtr		; Update SP
	ADD R1,R1,#1
	ST  R1,StackSize	; Update StackSize
	ADD R5,R5,#1
StackFull
	LD  R1,PUSaveR1
	LD  R2,PUSaveR2
	RET
PUSaveR1  .BLKW #1
PUSaveR2  .BLKW #1

; Subroutine POP
; Invoked to popan element
; Input: None
; Outputs: R5 has failure(0)/success(1); 
;          R0 has the popped element if success
POP
	ST  R1,POSaveR1
	ST  R2,POSaveR2
	AND R5,R5,#0
	LD  R1,StackSize
	BRz StackEmpty
	LD  R2,StackPtr
	LDR R0,R2,#0		; Add element
	ADD R2,R2,#1
	ST  R2,StackPtr		; Update SP
	ADD R1,R1,#-1
	ST  R1,StackSize	; Update StackSize
	ADD R5,R5,#1
StackEmpty
	LD  R1,POSaveR1
	LD  R2,POSaveR2
	RET
POSaveR1  .BLKW #1
POSaveR2  .BLKW #1
	.END