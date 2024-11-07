; Find Max with Array of Student records
; File: FindMax.asm
; Purpose: Find and Print Initials of Student whose score
;          is the Maximum in a variable length array of 
;          student records; Each student record has two three
;          attributes in this order:
;              Name    (a null-terminated string)
;              Score   (between 0 and 100)
; Notes: The array is null-terminated
;        that has a student record with first initial 0
    .ORIG   x3000
    LD   R0 ,stuarrayloc    ; R0 has location of student record array
    AND  R1 ,R1,#0  ; Address of the Max Student (initialized to zero)
    AND  R2 ,R2,#0  ; Max score so far
    ADD R2 ,R2,#-1
MoreStuds
    LDR R3,R0,#0     ; Get student's initial
    BRz DoneLooking
    LDR R3,R0,#3     ; R3 has score of current student record
; Compare R3,R2
    NOT R4,R2
    ADD R4,R4,#1
    ADD R4,R3,R4
    BRn NotHigher
; Here means new Max
    ADD R1,R0,#0    ; Copy address to R1
    ADD R2,R3,#0    ; Set new Max
NotHigher
    ADD R0,R0,#4    ; Move to next student record
    BRnzp   MoreStuds           
DoneLooking
    ADD   R0,R1,#0
    TRAP  x22
    TRAP  x25
stuarrayloc  .FILL    x4500
    .END 

; Array of student records with each student record
; made of two attributes: Name and Score
; Name is always only two characters and is null-terminated
        .ORIG   x4500
stuarray
        .STRINGZ "AZ"
        .FILL #75
        .STRINGZ "BY"
        .FILL #85
        .STRINGZ "CX"
        .FILL #62
        .STRINGZ "DW"
        .FILL #94
        .STRINGZ "EU"
        .FILL #72
        .FILL #0   ; Sentinel is a zero
        .END	