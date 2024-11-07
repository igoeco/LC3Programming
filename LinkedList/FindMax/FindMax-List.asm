; Find Max with Linked List of Student records
; File: linkedlistex.asm
; Purpose: Find and Print Initials of Student whose score
;          is the Maximum in a list (linked) of 
;          student records; Each student record has two
;          attributes in this order:
;              Name    (a null-terminated string)
;              Score   (between 0 and 100)
;          and a link to the next student record        
;              Next    (address of the next record)
; Notes: The linked is null-terminated
;        that is, the last student record has a next address of 0
    .ORIG   x3000
    LDI R0,stulisthead  ; R0 has the address of first student (pointed to by head)
    AND R1,R1,#0    ; Address of the Max Student (initialized to zero)
    AND     R2,R2,#0    ; Max score so far
    ADD R2,R2,#-1
MoreStuds
    ADD R0,R0,#0     ; See if end reached
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
    LDR R0,R0,#4    ; Move to next student record
    BRnzp   MoreStuds           
DoneLooking
    ADD R0,R1,#0
    TRAP    x22
    TRAP    x25
stulisthead .FILL   x4500
    .END

; Linked list of student records with each student record
; made of three attributes: Name (2 chars), Score and link to next record
; Name is always only two characters and is null-terminated
; x4500 stores the head of the linked list
        .ORIG   x4500
head    .FILL   first
second  .STRINGZ "BY"
        .FILL #85
        .FILL third
fourth  .STRINGZ "DW"
        .FILL #94
        .FILL fifth
first   .STRINGZ "AZ"
        .FILL #75
        .FILL second
fifth   .STRINGZ "EU"
        .FILL #72 
        .FILL #0
third   .STRINGZ "CX"
        .FILL #62
        .FILL fourth
        .END	