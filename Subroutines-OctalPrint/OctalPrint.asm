; The purpose of this LC3 program is to demonstrate
; the use of subroutines
; Author: Ramesh Yerraballi
; Date:   11/1/19
; OctalPrint.asm
; Convert and print the octal representation of
; a given input at x4000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;main program
    .ORIG  x3000
; Convert to Octal String
    LEA R4,OctString
    LDI R0,InputLoc
More
    BRz Done
    JSR DivBy8      ; Call DivBy8 to get Quotient(in R1)
                    ; and Remainder(in R2) when R0/8
    LD  R3,NumASCIIOffset
    ADD R3,R3,R2    ; Add Number Offset
    STR R3,R4,#0    ; before writing octal char
    ADD R4,R4,#1    ; Goto next octal char
    ADD R0,R1,#0    ; Make Quotient the next R0
    BRnp More
Done
    AND R3,R3,#0
    STR R3,R4,#0    ; Null-Terminate the String
; Reverse the String
    LEA R0,OctString
    JSR RevString   ; Call RevString to reverse in place
                    ; the string whose address is in R0
    TRAP x22        ; Call PUTS to display
    HALT
NumASCIIOffset .FILL #48     
OctString .BLKW #10
InputLoc  .FILL x4000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Subroutine DivBy8
; Divides a number by 8 and returns the Quotient and Remainder
; Input: R0 (the dividend)
; Outputs: R1(the quotient) and R2 (the remainder), 
DivBy8
    ST   R0,DvSaveR0
    AND  R1,R1,#0
DvAgain   
    ADD  R0,R0,#-8
    BRn  DvDone
    ADD  R1,R1,#1
    BRnzp DvAgain
DvDone   
    ADD  R2,R0,#8
    LD   R0,DvSaveR0
    JMP R7
DvSaveR0  .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Subroutine RevString
; Reverses a null-terminated String
; Input: R0 has the address of a null-terminated string
; Output: None (the string is reversed in memory)
RevString
    ST  R0,RvSaveR0
    ST  R1,RvSaveR1
    ST  R2,RvSaveR2
    ST  R3,RvSaveR3
    ST  R4,RvSaveR4
    ST  R7,RvSaveR7
    JSR StrLen   ; Find length of String in R1
    ADD R1,R1,#-1 ; Index of the last character
    ADD R1,R0,R1 ; R1 has address of the last character 
    ; swap the characters at R0 and R1
RAgain
    LDR R3,R0,#0
    LDR R4,R1,#0
    STR R4,R0,#0
    STR R3,R1,#0
    ADD R0,R0,#1
    ADD R1,R1,#-1
    NOT R3,R1      ; If R0 < R1 then more characters
    ADD R3,R3,#1
    ADD R3,R0,R3
    BRn RAgain
    LD  R0,RvSaveR0
    LD  R1,RvSaveR1
    LD  R2,RvSaveR2
    LD  R3,RvSaveR3
    LD  R4,RvSaveR4
    LD  R7,RvSaveR7
    JMP R7
RvSaveR0  .BLKW #1
RvSaveR1  .BLKW #1
RvSaveR2  .BLKW #1
RvSaveR3  .BLKW #1
RvSaveR4  .BLKW #1
RvSaveR7  .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Subroutine StrLen
; Computes the Length of a String
; Input: R0 has the address of a null-terminated string
; Output: R1 has the length of the String
StrLen
    ST  R0,StSaveR0
    ST  R2,StSaveR2
    AND R1,R1,#0
SAgain
    LDR R2,R0,#0
    BRz SDone
    ADD R1,R1,#1
    ADD R0,R0,#1
    BRnzp SAgain
SDone
    LD  R0,StSaveR0
    LD  R2,StSaveR2
    JMP R7
StSaveR0  .BLKW #1
StSaveR2  .BLKW #1
    .END
    