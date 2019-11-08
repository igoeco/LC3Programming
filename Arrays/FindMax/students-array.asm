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