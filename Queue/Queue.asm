;; Program to show the working of the Queue Data Structure
; Author: Ramesh Yerraballi
; Date:   11/8/19
; The following code is a "Driver/Tester" to
; exercise the implementation of Queue given below
; We will repeatedly prompt the user for a Command
; The command is either of these two cases:
; a.    +<element>
; or
; b.    - 
; If case "a." then the element (a char here)
; is en-queued 
; If clase "b." then the element is dequeued and printed out
	.ORIG x3000
    LD  R0,QCap
    JSR QueueInit
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
    JSR  EnQueue
    ADD  R5,R5,#0
    BRp  Loop
    LEA   R0,FailureMsgEQ
    TRAP x22
    BRnzp Loop
CheckMinus
    LD   R1,CharMinus
    ADD  R1,R0,R1
    BRnp Done         ; Invalid Command quits program
IsMinus
    JSR DeQueue
    ADD R5,R5,#0
    BRp PrintOut
    LEA R0, FailureMsgDQ
    TRAP x22
    BRnzp Loop
PrintOut
    ADD R1,R0,#0      ; Move item to R1
    LEA R0,ElementDQMsg
    TRAP x22
    ADD R0,R1,#0      ; Move item back to R0 
    TRAP x21
    BRnzp Loop
Done
    HALT
QCap    .FILL   #5
Prompt  .STRINGZ "\nCommand: "
CharPlus   .FILL  #-43   ; '+'
CharMinus   .FILL  #-45  ; '-'
FailureMsgEQ  .STRINGZ "\n   Enqueue Failed (Queue Full)\n"
FailureMsgDQ  .STRINGZ "\n   Dequeue Failed (Queue Empty)\n"
ElementDQMsg  .STRINGZ "\n Dequeued: "       
;=================================================
; This is a Queuue Implementation
; The Queue is of capacity QueueCapacity elements
; Each element is a number (could be char)
; Stores the Head and Tail in memory
; Implements the Queue as a Circular Buffer
; That is, as elements get added and removed we
; perform a wraparound
;=================================================
; Subroutine QueueInit
; Invoked once to initialize the size to zero
;  and set the head and tail of the queue
; Input: Max Capacity of the Queue in R0
; Output: None
QueueInit
    ST R0, QISaveR0
    ST R1, QISaveR1
    ST R0,QueueCapacity
    AND R1, R1, #0
    ST R1, QueueSize        ; Current Size of Queue is 0
    LD R1, QueueStart       ; Start location is where Queue is allocated
    ST R1, QueueHead        ; Location where elements are de-queued from
    ST R1, QueueTail        ; Location where elements are en-queued at
    ADD R1,R1,R0
    NOT R1,R1
    ADD R1,R1,#1            ; Store Physical end address of Queue storage
    ST R1,QueueEnd          ;  in negative for for comparison later
    NOT R0,R0
    ADD R0,R0,#1            ; Store capacity in negative
    ST R0,QueueCapacity     ;  form for comparison later
    LD R1, QISaveR1
    LD R0, QISaveR0
    RET
QueueStart .FILL Queue
QueueSize  .BLKW #1
QueueEnd   .BLKW #1
QueueHead  .BLKW #1
QueueTail  .BLKW #1
QueueCapacity  .BLKW #1
QISaveR0  .BLKW #1
QISaveR1  .BLKW #1
; Subroutine EnQueue
; Invoked to en-queue (add) an element
; Input: R0 has elemement to en-queue
; Output: R5 has failure(0)/success(1)
EnQueue
    ST  R1,EQSaveR1
    ST  R2,EQSaveR2
    AND R5,R5,#0        ; Assume return of failure(0)
    LD  R1,QueueSize
    LD  R2,QueueCapacity
    ADD R2,R1,R2
    BRz QueueFull
    LD  R1,QueueTail
    STR R0,R1,#0        ; Enqueue item at Tail
    LD  R2,QueueEnd
    ADD R2,R1,R2
    BRz WrapAroundOnEQ
    ADD R1,R1,#1
    BRnzp TailUpdate
WrapAroundOnEQ
    LD  R1,QueueStart
TailUpdate
    ST  R1,QueueTail    ; QueueTail update
    LD  R2,QueueSize    ; and QueueSize
    ADD R2,R2,#1        ; increment
    ST  R2,QueueSize
    ADD R5,R5,#1        ; return success(1)
QueueFull
    LD  R1,EQSaveR1
    LD  R2,EQSaveR2
    RET
EQSaveR1  .BLKW #1
EQSaveR2  .BLKW #1

; Subroutine DeQueue
; Invoked to de-queue element
; Input: None
; Outputs: R5 has failure(0)/success(1); 
;          R0 has the de-queued element if success
DeQueue
    ST  R1,DQSaveR1
    ST  R2,DQSaveR2
    AND R5,R5,#0        ; Assume return of failure(0)
    LD  R1,QueueSize
    BRz QueueEmpty
    LD  R1,QueueHead
    LDR R0,R1,#0        ; DeQueue item from Head
    LD  R2,QueueEnd
    ADD R2,R1,R2
    BRz WrapAroundOnDQ
    ADD R1,R1,#1
    BRnzp HeadUpdate
WrapAroundOnDQ
    LD  R1,QueueStart
HeadUpdate
    ST  R1, QueueHead   ; QueueHead update
    LD  R2,QueueSize    ; and QueueSize
    ADD R2,R2,#-1       ; decreement
    ST  R2,QueueSize
    ADD R5,R5,#1        ; return success(1)    
QueueEmpty
    LD  R1,DQSaveR1
    LD  R2,DQSaveR2
    RET
DQSaveR1  .BLKW #1
DQSaveR2  .BLKW #1
Queue     .BLKW #20		; Location of the Queue (for now we set its capacity to 20)
                        ; Actual capacity is set in QueueInit
	.END