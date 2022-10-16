;This is the mp3 written by Liang Zhixiang for ECE 220
;This program attempts to find a compatible combination of times at 
;which events can be inserted into an existing weekly schedule
;The code use DFS algorithm to handles extra events lists that require popping events 
;from stack to explore alternative hours for events already on the stack

    .ORIG    x3000

;This is the main function
;In this function, we first call the CLEAR_SCHED to initialize the schedule from x4000
;Then we try to translate the information from x5000 to x4000,if there is a error 
;in this step we just print the error and then halt the program
;Next we will try to fit all the extra events into the schedule
;If there is uncompatibility we just print the error and then halt the program
;In the end we need to print the string we stored in x4000 using PRINT_SCHED subroutine
MAIN    
    JSR CLEAR_SCHED
    JSR TRANSLATE
    ADD R0,R0,#0    ;if R0 return with 0, translate successful
    BRnp ENDL
    JSR MP3
    ADD R0,R0,#0    ;if R0 return with 0, MP3 successful   
    BRnp ENDL
    JSR PRINT_SCHED
ENDL    
    HALT

;CLEAR_SCHED starts here. In this part, I initialize 80 consecutive from memory location x4000
;Register table for Initialization
;R1|used as a memory location pointer from x4000
;R2|used to store the x00 into memory from x4000
;R3|used as a counter from 80 to 0	
CLEAR_SCHED
    ST R7,RSEVENONE
    LD R1,SCHEDULE     ;First we need to load the x4000 into R1
    LD R3,EIGHTY       ;Load R3 with 80 as a counter
    AND R2,R2,#0       ;Initialize the R2 to 0 
INIT         
    STR R2,R1,#0    ;store the x00 into memory 
    ADD R1,R1,#1
    ADD R3,R3,#-1
    BRp INIT
    LD R7,RSEVENONE
    RET
RSEVENONE      .BLKW #1

;Translation starts here.
;In this part, we need to put the address of string(from x5000) we want to output into x4000
;Register table for Translation
;R0|used to calculate the offset of memory location
;R1|used as a memory location pointer from x5000
;R2|used as a counter and also used to determine whether stop the second part
;R3|used to store the bitvector
;R4|used as a bitmask for bitvector
;R5|used to calculate the offset of memory location
;R6|used to store the slot
TRANSLATE
    ST R7,RSEVENTWO
    AND R0,R0,#0
    AND R3,R3,#0
    AND R4,R4,#0
    AND R5,R5,#0
    LD R1,TABLE     ;start to translate from x5000
TRANSLATE1    
    ST R1,ADDRESS   ;First we store the R1 into address for future use
    LDR R2,R1,#0    ;Examine whether the char is null in this step 
    BRnp LOOPA
JUSTRET    
    AND R0,R0,#0
    LD R7,RSEVENTWO
    RET    ;If char is null, then go to print the whole table
LOOPA    
    ADD R1,R1,#1    ;In the LOOPA, we will finally arrive to the end of one event
    LDR R2,R1,#0 
    BRz BITVECTOR   ;If char==null, we then process the bitvector
    BRnzp LOOPA
BITVECTOR           ;In the BITVECTOR, we will process bitvector to determine whether output MON-FRI 
    ADD R1,R1,#1    
    LDR R3,R1,#0    ;Store the bitvector into R3
    ADD R1,R1,#1    ;Add R1 with 1 to let it points to the slot
    AND R4,R4,#0
    ADD R4,R4,#1
    ST R4,BITMASK   ;Store bitmask into memory for reuse
    LDR R6,R1,#0    ;Get the slot
    ST R6,SLOT      ;Store slot into memory for reuse
    AND R2,R2,#0
    LD R5,MASK      ;In the mask we store xFFF0 to examine whether slot is in [0,15]
    AND R5,R5,R6
    BRnp ERRORSLOT  ;If slot is not in [0,15], we just print the error
LOOPB               
    LD R4,BITMASK   
    AND R5,R5,#0
    ADD R5,R5,#-5   ;Use R5 as a counter to determine whether go to NEXT
    ADD R5,R5,R2
    BRz NEXT
    AND R5,R3,R4    ;Use bitmask to determine the bit is 1 or zero
    NOT R5,R5       
    ADD R5,R5,#1    ;Make R5 -> -R5
    ADD R5,R5,R4    ;If R5=0, then we store the string into particular memory location
    BRz CALU
DID    
    ADD R2,R2,#1    ;If R5 != 0, we wil ADD R2 with 1 and right shift the R4
    ADD R4,R4,R4
    ST R4,BITMASK
    BRnzp LOOPB     ;Then we process the next bit of bitvector
CALU
    LD R6,SLOT      ;Reload the slot into R6
    AND R0,R0,#0
CALUT    
    ADD R6,R6,#-1   ;We let R0=R0+slot*5 to get the correct address of row
    BRn STORE
    ADD R0,R0,#5
    BRnzp CALUT
STORE
    ADD R5,R2,#0
    ADD R0,R0,R5    ;We let R0=(R0+ particular bit of bitvector) to get the offset
    LD R5,SCHEDULE
    ADD R0,R0,R5    ;Add R0 with R5 to get the correct address
    LDR R5,R0,#0    
    BRnp ERRORREPEAT ;If there is already some data in memory, we print the error of repeat
    LD R5,ADDRESS
    STR R5,R0,#0    ;Store the address of event
    BRnzp DID
NEXT
    ADD R1,R1,#1    ;ADD R1 with 1 to go to the next event
    BRnzp TRANSLATE1
ERRORSLOT           ;If slot is not in [0,15],we use this function to print error
    LD R0,ADDRESS
    PUTS
    LEA R0,SLOTERROR
    PUTS
    LD R7,RSEVENTWO
    RET
ERRORREPEAT         ;If the event is stored repeatedly, we use this function to print error
    LD R0,ADDRESS
    PUTS
    LEA R0,REPEATERROR
    PUTS
    LD R7,RSEVENTWO
    RET

RSEVENTWO      .BLKW #1

;PRINT_SCHED starts here.
;In this part, we will output the whole schedule to the screen from the memory location x4000
;Register table for printing
;R0|used to output the some character such as '|' and also play a role in subroutine 
;R1|used as a memory location pointer to MON-FRI
;R2|used to point to x4000 and iterate through 80 memory locations 
;R3|used as outerloop counter 
;R5|used as inner loop counter
PRINT_SCHED
    ST R7,RSEVENFOUR
FIRSTROW
    LEA R1,SIXSPACE     ;First output the 6 space
    JSR PRINT_CENTERED
    AND R5,R5,#0
    ADD R5,R5,#5        ;R5 as a counter
    LEA R1,MON
OUTPUT1ROW              ;Use PRINT_CENTERED to put the MON-FRI
    LD R0,VLINE         ;Print '|'
    OUT 
    JSR PRINT_CENTERED
    ADD R5,R5,#-1
    BRz OUTPUTMAIN
    ADD R1,R1,#4        ;Add R4 with 4 to get the MON-FRI location
    BRnzp OUTPUT1ROW
OUTPUTMAIN
    LD R2,SCHEDULE      ;Use a double nested loop to print the schedule
    AND R3,R3,#0
    ADD R3,R3,#15       ;Outerloop iterate 16 times
    AND R1,R1,#0
    ST R1,RONE          ;Store R1 for reuse
OUTERLOOP
    LD R0,SPACE1  
    OUT 
    ADD R3,R3,#0
    BRn THEEND  
    LD R1,RONE
    JSR PRINT_SLOT      ;Output the slot
    ADD R1,R1,#1
    ST R1,RONE
    ADD R3,R3,#-1       ;If R3==0 just stop the iteration
    AND R5,R5,#0
    ADD R5,R5,#5        ;Innerloop iterate 5 times
INNERLOOP    
    LD R0,VLINE 
    OUT
    LDR R1,R2,#0
    BRz   A0            ;If memory is empty, output the six space
    BRnzp A1            ;If memory is empty, just use PRINT_CENTERED to print the event
A0  LEA R1,SIXSPACE
A1  JSR PRINT_CENTERED
    ADD R2,R2,#1
    ADD R5,R5,#-1
    BRz   OUTERLOOP     ;When R5==0, go back to the outerloop 
    BRnzp INNERLOOP
THEEND
    LD R7,RSEVENFOUR
    RET

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
REPEATERROR .STRINGZ " conflicts with an earlier event.\n"
SLOTERROR   .STRINGZ " has an invalid slot number.\n"
RONE        .BLKW #1
RSEVENFOUR  .BLKW #1

;MP3 starts here
;In this subroutine we will use DFS algorithm to fit all of the extra
;events into the schedule from x4000 we use a stack 
;in the code to help us handle the extra events lists that require popping events from 
;stack to explore alternative hours for events already on the stack
;Register table for printing
;R0|used as the pointer for extra event list from x6000
;R1|used to save the current slot number 
;R2|used as a bitmask for slot vector and day vector
;R3|used as a counter
;R4|used to determine whether the stack is empty
;R5|used as a stack pointer that always points to the top of the stack
;R6|used to detect if there is already some events day
;R7|multiple using for this subroutine

;Below is the event structure used on the stack
;R5+0=the address of event string
;R5+1=the day vector of event
;R5+2=the slot vector of event
;R5+3=the current hour of event
MP3
    ST R7,RSEVENTHREE
    AND R6,R6,#0
    LD R0,EXTRA		;R0->x6000, as the extra file pointer
    LD R5,STACK		;R5->x8000, as the stack pointer
INSERT_NEXT
    LDR R2,R0,#0	;If we meet x0000 in extra file we just go back to main function
    BRz ALL_DONE
PUSH
    ADD R5,R5,#-4	;each event have 4 memory locations in the stack
    STR R2,R5,#0    ;store event's address into M[R5+0]
    ADD R0,R0,#1
    LDR R2,R0,#0
    STR R2,R5,#1    ;store the day vector into M[R5+1]
    ADD R0,R0,#1
    LDR R2,R0,#0
    STR R2,R5,#2    ;store the slot vector into M[R5+2]
    AND	R2,R2,#0	;init R2 and R1
    AND R1,R1,#0
    ADD R2,R2,#1	;R2 as a bitmask through x0001 to x8000 
    ADD R0,R0,#1	;R0->R0+3, R0 now points to the next 
TRY_TO_FIND
    LDR R3,R5,#2	;M[R5+2]->R3, R3 now have the slot vector
    AND R7,R3,R2	;determine whether this bit can be inserted
	ST R1,TEMPR1	;store R1 and R2 for reuse
	ST R2,TEMPR2
    BRz ADD_SLOT  
    BRnzp FIND_SLOT
ADD_SLOT
    LD R1,TEMPR1	;load R1 and R2 from memory 
	LD R2,TEMPR2
ADD_SLOT_H
    ADD R1,R1,#1	
    ADD R2,R2,R2	;left shift R2 and add R1 with 1
    ST R1,TEMPR1	;store R1 and R2 for reuse
	ST R2,TEMPR2
    BRnp TRY_TO_FIND		;if R2 left shift more than 15 times, we then pop it from stack
    ADD R5,R5,#4	;pop the event
    ADD R0,R0,#-3	;return to last event
    LD  R6,STACK
    NOT R6,R6
    ADD R6,R6,#1	
    ADD R6,R6,R5
    BRnp POP	;when the stack is empty, we meet the conflict
    LEA	R0,ERROR_EXTRA
	PUTS 
	BRnzp ALL_DONE2
POP
    LDR R1,R5,#3	;current slot from last event
    ADD	R7,R1,R1	
	ADD	R7,R7,R7
	ADD	R1,R7,R1    ;R1*5->R1
    LD	R3,SCHEDULE	
	ADD	R1,R1,R3	;5*slot+x3000-> the row we want to locate
	AND	R3,R3,#0	;use R3 as a counter
	ADD R3,R3,#5
	LDR	R7,R5,#0	;negate the event address
	NOT	R7,R7
	ADD	R7,R7,#1
THEDAY
	LDR	R4,R1,#0	;R4 now loads the current event
	ADD	R4,R4,R7	;determine whether the string is same
	BRnp NO_MATCH	
	AND R4,R4,#0
	STR R4,R1,#0	
NO_MATCH
	ADD	R1,R1,#1	
	ADD	R3,R3,#-1		
	BRp	THEDAY	
	LDR	R1,R5,#3	;R1 now store the current hour
	LDR	R3,R5,#2	;R3 now has the slot vector
    AND R2,R2,#0	
	ADD R2,R2,#1
PLUS    
    ADD R1,R1,#-1    
	BRn YES
	ADD R2,R2,R2	;use R1 as a counter to left shift R2 to get the current bitmask
    BRnzp PLUS
YES LDR	R1,R5,#3	;reload R1 from stack with current hour
	BRnzp	ADD_SLOT_H	

FIND_SLOT
    STR R1,R5,#3    ;save current hour to stack
    NOT R2,R2
    AND R3,R3,R2	;move the current hour bit from the bit vector
    STR R3,R5,#2    ;save the new hour bitvector to stack
    ADD R7,R1,R1
    ADD R7,R7,R7
    ADD R1,R1,R7    ;R1*5->R1
    LD R6,SCHEDULE
    ADD R1,R1,R6	;SLOT*5+x4000,meaning we start from monday on that row
    AND R2,R2,#0
    ADD R2,R2,#1	;R2 as a bitmask for dayvector now 
    LDR R3,R5,#0    ;R3 loads the event's address 
    LDR R4,R5,#1    ;R4 loads the day vector
    AND R7,R7,#0
    ADD R7,R7,#5    ;R7 as a counter for iterating 5 times
WHETHER_INSERT
    AND R6,R4,R2	;determine whether insert to this day
    BRz NEXT_DAY
    LDR R6,R1,#0	;if there is already some events in the memory, we try to next slot
    BRnp ADD_SLOT
NEXT_DAY
    ADD R1,R1,#1	
    ADD R2,R2,R2	;left shift R2
    ADD R7,R7,#-1
    BRp WHETHER_INSERT	;if iterate all day and no conflict, we start to save the event into address
    AND R7,R7,#0
    ADD R7,R7,#5	;set R7 as a counter again
    ADD R1,R1,#-5	;let R1 points to Monday
    AND R2,R2,#0	
    ADD R2,R2,#1	;set R2 as a bitmask again
ALL_OK     
    ADD R7,R7,#-1
    BRn INSERT_NEXT	;when R7<0 we finishing inserting this event and go to next
    AND R6,R4,R2	
    BRz ADD_R2
    STR R3,R1,#0	;insert the event address into schedule
ADD_R2
    ADD R2,R2,R2
    ADD R1,R1,#1	;left shift R2 and add R1 with 1
    BRnzp ALL_OK
ALL_DONE
    AND R0,R0,#0	;if can fit all events, return R0 with 0
    LD R7,RSEVENTHREE
    RET
ALL_DONE2
    AND	R0,R0,#0
    ADD R0,R0,#1	;if can not fit all events, return R0 with 1
    LD R7,RSEVENTHREE
    RET

TEMPR1           .BLKW #1
TEMPR2			 .BLKW #1
EXTRA            .FILL x6000
STACK            .FILL x8000
RSEVENTHREE      .BLKW #1
ERROR_EXTRA	     .STRINGZ "Could not fit all events into schedule.\n"

PRINT_SLOT
;The PRINT_SLOT is a subroutine to print an hour. We pass a number from 0 to 15 to R1 
;and then use it in this subroutine.
;Register table for PRINT_SLOT
;R0|store the correspoding time's address for printing (PUT).
;R1|store the input value (from 0 to 15).
;R2|used to calculte the address of time we want to print.
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
