.ORIG    x3000

    LD R1,SCHEDULE
    LD R3,EIGHTY
    AND R2,R2,#0
INIT         
    STR R2,R1,#0
    ADD R1,R1,#1
    ADD R3,R3,#-1
    BRp INIT
    LD R1,TABLE
TRANSLATE
    ST R1,ADDRESS
    LDR R2,R1,#0
    BRz FIRSTROW
LOOPA    
    ADD R1,R1,#1
    LDR R2,R1,#0
    BRz BITVECTOR 
    BRnzp LOOPA
BITVECTOR
    ADD R1,R1,#1
    LDR R3,R1,#0
    ADD R1,R1,#1
    AND R4,R4,#0
    ADD R4,R4,#1
    ST R4,BITMASK
    LDR R6,R1,#0
    ST R6,SLOT
    AND R2,R2,#0
    LD R5,MASK
    AND R5,R5,R6
    BRnp ERRORSLOT
LOOPB
    LD R4,BITMASK
    AND R5,R5,#0
    ADD R5,R5,#-5
    ADD R5,R5,R2
    BRz NEXT
    AND R5,R3,R4
    NOT R5,R5
    ADD R5,R5,#1
    ADD R5,R5,R4
    BRz CALU
DID    
    ADD R2,R2,#1
    ADD R4,R4,R4
    ST R4,BITMASK
    BRnzp LOOPB
CALU
    LD R6,SLOT
    AND R0,R0,#0
CALUT    
    ADD R6,R6,#-1
    BRn STORE
    ADD R0,R0,#5
    BRnzp CALUT
STORE
    ADD R5,R2,#0
    ADD R0,R0,R5
    LD R5,SCHEDULE
    ADD R0,R0,R5
    LDR R5,R0,#0
    BRnp ERRORREPEAT
    LD R5,ADDRESS
    STR R5,R0,#0
    BRnzp DID
NEXT
    ADD R1,R1,#1
    BRnzp TRANSLATE
ERRORSLOT
    LD R0,ADDRESS
    PUTS
    LEA R0,SLOTERROR
    PUTS
    HALT
ERRORREPEAT
    LD R0,ADDRESS
    PUTS
    LEA R0,REPEATERROR
    PUTS
    HALT
FIRSTROW
    LEA R0,SIXSPACE
    PUTS
    AND R5,R5,#0
    ADD R5,R5,#5   
    
    LEA R1,MON
OUTPUT1ROW
    LD R0,VLINE
    OUT 
    JSR PRINT_CENTERED
    ADD R5,R5,#-1
    BRz OUTPUTMAIN
    ADD R1,R1,#4
    BRnzp OUTPUT1ROW
OUTPUTMAIN
    LD R2,SCHEDULE
    AND R3,R3,#0
    ADD R3,R3,#15
    AND R1,R1,#0
    ST R1,RONE
OUTERLOOP
    ADD R3,R3,#0
    BRn THEEND  
    LD R0,SPACE1  
    OUT
    LD R1,RONE
    JSR PRINT_SLOT
    ADD R1,R1,#1
    ST R1,RONE
    ADD R3,R3,#-1
    AND R5,R5,#0
    ADD R5,R5,#5
INNERLOOP    
    LD R0,VLINE
    OUT
    LDR R1,R2,#0
    BRz   A0
    BRnzp A1
A0  LEA R1,SIXSPACE
A1  JSR PRINT_CENTERED
    ADD R2,R2,#1
    ADD R5,R5,#-1
    BRz   OUTERLOOP
    BRnzp INNERLOOP

THEEND
    HALT


SCHEDULE    .FILL x4000
TABLE       .FILL x5000
EIGHTY      .FILL #80
SPACE1      .FILL x0A
SIXTEEN     .FILL #16
SIXSPACE    .STRINGZ "      "
MON         .STRINGZ "Mon"
TUE         .STRINGZ "Tue"
WED         .STRINGZ "Wed"
THU         .STRINGZ "Thu"
FRI         .STRINGZ "Fri"
VLINE	    .FILL x7C	
ADDRESS     .BLKW #1
MASK        .FILL xFFF0
BITMASK     .BLKW #1
SLOT        .BLKW #1
REPEATERROR .STRINGZ " conflicts with an earlier event\n"
SLOTERROR   .STRINGZ " has an invalid slot number.\n"
RONE        .BLKW #1


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
    ST R7, SAVE_R7

PROCESSING
    LEA R2, TIME 
    AND R0, R0, #0
    ADD R1, R1, #0     ;use this to determine whether we will do the MOVE part of subroutine

MOVE    
    BRz FINISH         ;use R1 as a counter to determine whether we should exit KEEP and if R1=0, we can go to the FINISH.
    ADD R2, R2, #2     ;Go to the next initial address
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
    LD R7, SAVE_R7

    RET

SAVE_R0 .BLKW #1 ;Below are the memory locations to store the value of registers
SAVE_R1 .BLKW #1 ;and then restore them in the end of subroutine
SAVE_R2 .BLKW #1
SAVE_R7 .BLKW #1  

TIME           .STRINGZ "07080910111213141516171819202122" ;This is the look-up table for printing the slot
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
    AND R4, R4, #0
    ST  R4, TEMP
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