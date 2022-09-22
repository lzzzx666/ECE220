;This is the MP1 written by Liang Zhixiang for ECE220 class.
;This machine program write two subroutines to support printing of a student's time table.
;PRINT_SLOT aimed to print the time while PRINT_CENTERED aimed to print 
;the other string in the student's time table.

    .ORIG    x3000

; Add this test code to the start of your file (just after .ORIG).
; I'd put it in another file, but we can't use the PRINT_SLOT and 
; PRINT_CENTERED labels outside of the mp1.asm file (at least, not 
; easily).

; Read the comments in this file to understand what it's doing and
; for ways that you can use this test code.  You can also just run
; it and diff the output with the output produced by our 'gold'
; (bug-free!) version.

; After assembling mp1 with lc3as, execute the test script by typing
; lc3sim -s script1 > your_output
; (look at the script--it just loads mp1 with a file command, then
; continues execution; when the LC-3 halts, the script is finished,
; so the simulator halts).

; You can then type
; diff your_output out1
; to compare your code's output with ours.
;

    ; feeling lazy, so I'm going to set all of the bits to the same value
    LD     R0,BITS
    ADD    R2,R0,#0
    ADD    R3,R0,#0
    ADD    R4,R0,#0
    ADD    R5,R0,#0
    ADD    R6,R0,#0

    ; let's try PRINT_SLOT ... 11:00
    AND    R1,R1,#0
    ADD    R1,R1,#15

    ; set a breakpoint here in the debugger, then use 'next' to
    ; execute your subroutine and see what happens to the registers;
    ; they're not supposed to change (except for R7)...

    JSR     PRINT_SLOT     ;First ,execute the first subroutine
    LEA     R1, STRING     ;Then change the value of R1 to the start address of string 
    JSR     PRINT_CENTERED ;Then execute the second subroutine

    ; we're short on human time to test your code, so we'll do 
    ; something like the following instead (feel free to replicate)...
    LD     R7,BITS
    NOT    R7,R7
    ADD    R7,R7,#1
    ADD    R0,R0,R7
    BRz    R0_OK
    LEA    R0,R0_BAD
    PUTS

R0_OK    

    ; this trap changes register values, so it's not sufficient
    ; to check that all of the registers are unchanged; HALT may
    ; also lead to confusion because the register values differ
    ; for other reasons (R7 differences, for example).
    HALT

BITS    .FILL    xABCD    ; something unusual
VLINE   .FILL    x7C      ; ASCII vertical line character
R0_BAD  .STRINGZ "PRINT_SLOT changes R0!\n"
STRING  .STRINGZ "liang"
; your code should go here ... don't forget .ORIG and .END

;The first subroutine.
PRINT_SLOT
;The PRINT_SLOT is a subroutine to print an hour. We pass a number from 0 to 15 to R1 
;and then use it in this subroutine.

;Register table for PRINT_SLOT
;R0|store the correspoding time's address for printing (PUT).
;R1|store the input value (from 0 to 15).
;R2|used to calculte the address of time we want to print.
;R3|used to store the multiplcation factor 7

    ST R0, SAVE_R0     ;First we need to store the value of 
    ST R1, SAVE_R1     ;each register into the memory address
    ST R2, SAVE_R2
    ST R3, SAVE_R3
    ST R7, SAVE_R7

PROCESSING
    LEA R2, TIME 
    AND R3, R3, #0
    ADD R3, R3, #2     ;We make R3=2 because each o'clock time string use 2 consecutive memory location.
    AND R0, R0, #0
    ADD R1, R1, #0     ;use this to determine whether we will do the MOVE part of subroutine

MOVE    
    BRz FINISH         ;use R1 as a counter to determine whether we should exit KEEP and if R1=0, we can go to the FINISH.
    ADD R2, R2, R3     ;Go to the next initial address
    ADD R1, R1, #-1    ;minus -1 with R1 to decide whether go to next "move"
    BRnzp MOVE

FINISH  
    LDR R0, R2, #0     ;then pass the address of time from R2 to R0.
    OUT                ;put the string we already store in memory
    ADD R2, R2, #1
    LDR R0, R2, #0
    OUT

FINALOUT
    LEA R0, COMPLEMENT ;After output the clock, we need to put the ":00 " on screen
    PUTS

RESTORE
    LD R0, SAVE_R0  ;After finishing this subroutine, we need to 
    LD R1, SAVE_R1  ;restore the value of each register from memory address
    LD R2, SAVE_R2
    LD R3, SAVE_R3
    LD R7, SAVE_R7

    RET

SAVE_R0 .BLKW #1 ;Below are the memory locations to store the value of registers
SAVE_R1 .BLKW #1 ;and then restore them in the end of subroutine
SAVE_R2 .BLKW #1
SAVE_R3 .BLKW #1
SAVE_R7 .BLKW #1  

TIME           .STRINGZ "070809101112131415161718192021222324" ;This is the look-up table for printing the slot
COMPLEMENT     .STRINGZ ":00 " ;this is the behind part of the time slot we want to output
;The second subroutine.

PRINT_CENTERED
;The second subroutine prints an arbitrary string 
;centered in six spaces, truncating the string or adding 
;extra space characters as necessary.
;We can find that when length=0,1,2,3,4,5,6
;leading space = 3,2,2,1,1,0,0 and trailing space = 3,3,2,2,1,1,0
;so we put these series in the look-up table

;Register table for PRINT_CENTERED
;R0|used to store the ascii value we want to print with OUT.
;R1|used to store the adress of string's beginning location.
;R2|used to load the address of leading series of trailng series.
;R3|used to store the length of the string.
;R4|used to store the length of string into R4 for reuse
;R5|used to store the inverse value of '0' in R5 when calculating the decimal value of space
;R6|used to hold the value of 6 - length anf then used it to decode look-up table

    ST R0, SAVER0     ;First we need to store the value of 
    ST R1, SAVER1     ;each register into the memory address
    ST R2, SAVER2
    ST R3, SAVER3
    ST R4, SAVER4
    ST R5, SAVER5
    ST R6, SAVER6
    ST R7, SAVER7

Initialization
    ADD R2, R1, #0    ;we store the starting address of the string in R2  
    AND R3, R3, #0    ;and initialize R3(counter) to zero 

CALU_LEN        
    LDR R0, R2, #0    ;this subroutine is used to check the string and get the length of it
    BRz CALU_SPACE    ;and it will exit when we met the end of string ('\0')
    ADD R2, R2, #1
    ADD R3, R3, #1
    BRnzp CALU_LEN
        
CALU_SPACE        
    ADD R4, R3, #0    ;store the length of string into R4 for reuse
    ADD R3, R3, #-6   ;test whether R3 is bigger than 6
    BRp PRINT_STRING            
    NOT R6, R3        ;The condition that length is no more than six
    ADD R6, R6, #1    ;we use R6 to hold the value of 6 - length and then used it to decode look-up table
    ST  R6, TEMP

PRINT_LEADSPACE                ;use this subroutine to print the leading space
    LEA R2, LEADINGSERIES      ;here we load the first postion 's address of LEADINGSRIES
    ADD R2, R2, R6
    LDR R3, R2, #0
    LD R0, SPACE
    LOOPONE ADD R3, R3, #-1    ;we use this loop1 to print the leading space
            BRn PRINT_STRING
            OUT
            BRnzp LOOPONE 
                               
PRINT_STRING                    ;use this subroutine to print the string
    AND R6, R6, #0
    ADD R6, R6, #6              ;set R6=6 since the max length of string that put on screen is 6
    ADD R4, R4, #0
    BRz PRINT_TRAILSPACE        ;in this case length=0, so just go to print trailing space
    ADD R2, R1, #0              ;R2 now holds the start position of a string
    LOOPTWO LDR R0, R2, #0      ;we use this loop2 to print the string with length <=6
            OUT
            ADD R2, R2, #1
            ADD R4, R4, #-1
            BRz PRINT_TRAILSPACE ;use R4's value to decide if we go to print space
            ADD R6, R6, #-1
            BRz PRINT_TRAILSPACE ;use R6's value to decide if we go to print space
            BRnzp LOOPTWO       

PRINT_TRAILSPACE         ;use this subroutine to print the trailing space
    LD R6, TEMP          ;get the value of 6-length from memory into R6
    LEA R2, TRAILINGSERIES
    ADD R2, R2, R6
    LDR R3, R2, #0
    LD R0, SPACE
    LOOPTHREE   ADD R3, R3, #-1
                BRn RESTORE_
                OUT
                BRnzp LOOPTHREE 
   
RESTORE_    
    LD R0, SAVER0 ;finally we need to restore the value into these registers
    LD R1, SAVER1
    LD R2, SAVER2
    LD R3, SAVER3
    LD R4, SAVER4
    LD R5, SAVER5
    LD R6, SAVER6
    LD R7, SAVER7

    RET

SAVER0 .BLKW #1 ;Below are the memory locations to store the value of registers
SAVER1 .BLKW #1 ;and then restore them in the end of subroutine
SAVER2 .BLKW #1
SAVER3 .BLKW #1
SAVER4 .BLKW #1
SAVER5 .BLKW #1
SAVER6 .BLKW #1
SAVER7 .BLKW #1 
TEMP           .BLKW #1               ; we use this temporary space to store some certain values
INVERSEZERO    .FILL xFFD0            ; the inverse value of ASCII '0' /'s decimal expression
LEADINGSERIES  .FILL #0               ; look-up tables for leading spaces and trailing spaces
TRAILINGSERIES .FILL #0
               .FILL #1
               .FILL #1
               .FILL #2
               .FILL #2
               .FILL #3
               .FILL #3

SPACE          .FILL x0020            ; the ASCII value of space
       
    .END