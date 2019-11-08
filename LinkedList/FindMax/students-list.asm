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