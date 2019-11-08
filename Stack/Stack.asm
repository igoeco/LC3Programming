;; Program to show the working of the Stack Data Structure
; Author: Ramesh Yerraballi
; Date:   11/8/19
; The following code is a "Driver/Tester" to
; exercise the implementation of Stack given below
; We will repeatedly prompt the user for a Command
; The command is either of these two cases:
; a.    +<element>
; or
; b.    - 
; If case "a." then the element (a char here)
; is pushed
; If clase "b." then the element is popped and printed out
	.ORIG x4000
    LD  R0,SCap
    JSR StackInit
Loop    
    LEA R0,Prompt
    TRAP x22
    TRAP x20    ; Read Input
    TRAP x21    ; Echo back
    LD   R1,CharPlus
    ADD  R1,R0,R1
    BRnp CheckMinus
IsPlus
    TRAP x20
    TRAP x21    ; Get Element (a char)
    JSR  PUSH
    ADD  R5,R5,#0
    BRp  Loop
    LEA   R0,FailureMsgPush
    TRAP x22
    BRnzp Loop
CheckMinus
    LD   R1,CharMinus
    ADD  R1,R0,R1
    BRnp Done         ; Invalid Command quits program
IsMinus
    JSR POP
    ADD R5,R5,#0
    BRp PrintOut
    LEA R0, FailureMsgPop
    TRAP x22
    BRnzp Loop
PrintOut
    ADD R1,R0,#0      ; Move item to R1
    LEA R0,ElementPopMsg
    TRAP x22
    ADD R0,R1,#0      ; Move item back to R0 
    TRAP x21
    BRnzp Loop
Done
    HALT
SCap    .FILL   #5
Prompt  .STRINGZ "\nCommand: "
CharPlus   .FILL  #-43   ; '+'
CharMinus   .FILL  #-45  ; '-'
FailureMsgPush  .STRINGZ "\n   Push Failed (Stack Full)\n"
FailureMsgPop  .STRINGZ "\n   Pop Failed (Stack Empty)\n"
ElementPopMsg  .STRINGZ "\n Popped: "      
;=================================================
; This is a Stack Implementation
; The stack is of capacity StackCapacity elements
; Each element is a number (could be char)
; Does not use R6 as the SP; Stores the SP in memory
;=================================================
; Subroutine StackInit
; Invoked once to initialize the SP and size
; to the bottom of the stack
; Input: Max Capacity of the Stack in R0
; Output: None
StackInit
	ST R0,StackCapacity
	AND	R0,R0,#0
	ST R0,StackSize
	LD R0,StackBottom	
	ST R0,StackPtr
	LD R0,StackCapacity ;Restore R0
	RET
StackBottom .FILL x4000		; Location of Stack's Bottom
StackSize   .BLKW #1
StackPtr  .BLKW #1
StackCapacity  .BLKW #1

; Subroutine PUSH
; Invoked to push an element
; Input: R0 has element to push
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
	STR R0,R2,#0		; Push element
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
; Invoked to pop an element
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
	LDR R0,R2,#0		; Pop element
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