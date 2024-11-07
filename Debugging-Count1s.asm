; Program to count number of 1's in given input
; Author: Ramesh Yerraballi
; Date: 10/18/2019
; Input: Number at x4000
; Output: Number of 1s in Input
;         stored at x4001
    .ORIG x3000
    LD  R0, ptInput ; Pointer(address) of Input
    AND R2, R2, #0  ; Clear Count
    LDR R1, R0, #0  ; Get Input
More
    BRzp Next
    ADD R2, R2, #1 ; found another 1
Next
    ADD R1, R1, R1 ; left shift
    BRnp More
    STR R2, R0, #1  ; Output to x4001
    HALT
ptInput  .FILL x4000
    .END
	.ORIG x4000
Number .FILL x3322 
Count  .BLKW #1     ; Output should be 6
	.END
    