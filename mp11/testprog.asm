;---------------------------------------------------------------------------
; 
; WARNING!  This code was produced automatically using the ECE190 C compiler
; (MP5 in the Spring 2008 semester).  If you choose to modify it by hand,
; be aware that you WILL LOSE such changes when the code is recompiled.
;
; Student-generated code is marked as "STUDENT CODE."
;
;---------------------------------------------------------------------------

	.ORIG x3000

BOGUSFP
	LD	R4,GDPTR
	LEA	R5,BOGUSFP
	LD	R6,SPTR
	JSR	MAIN
	LEA	R0,OUTPREFIX
	PUTS
	LDR	R0,R6,#0
	ADD	R6,R6,#1
	LD	R1,PNPTR
	JSRR	R1
	AND	R0,R0,#0
	ADD	R0,R0,#10
	OUT
	HALT

GDPTR	.FILL GLOBDATA
SPTR	.FILL STACK
PNPTR	.FILL PRINT_NUM
OUTPREFIX	.STRINGZ "main returned "

MAIN	ADD	R6,R6,#-3
	STR	R5,R6,#0
	STR	R7,R6,#1
	ADD	R5,R6,#-1

;---------------------------------------------------------------------------
; local variable space allocation
;---------------------------------------------------------------------------

	ADD R6,R6,#-7

;---------------------------------------------------------------------------
; R0...R3 are callee-saved
;---------------------------------------------------------------------------

	ADD	R6,R6,#-4
	STR	R0,R6,#0	; save R0...R3
	STR	R1,R6,#1
	STR	R2,R6,#2
	STR	R3,R6,#3
	
;---------------------------------------------------------------------------
; STUDENT CODE STARTS HERE (after the symbol table)
;---------------------------------------------------------------------------

;                piles[3]        global          offset=+0
;                 seed           local to main   offset=+0
;                    i           local to main   offset=-1
;                    j           local to main   offset=-2
;                 done           local to main   offset=-3
;            choice_ok           local to main   offset=-4
;                 pnum           local to main   offset=-5
;                  amt           local to main   offset=-6
	LEA R0,LBL2
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL3
LBL2
	.STRINGZ "Please type a number: "
LBL3
	LD R0,LBL4
	JSRR R0
	BRnzp LBL5
LBL4
	.FILL PRINTF
LBL5
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL9
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL10
LBL9
	.FILL #1
LBL10
	ADD R0,R5,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LEA R0,LBL11
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL12
LBL11
	.STRINGZ "%d"
LBL12
	LD R0,LBL13
	JSRR R0
	BRnzp LBL14
LBL13
	.FILL SCANF
LBL14
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#2
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRz LBL8
	ADD R2,R2,#1
LBL8
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL16
	LD R3,LBL15
	JMP R3
LBL15
	.FILL LBL6
LBL16
	LEA R0,LBL17
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL18
LBL17
	.STRINGZ "That's not a number!\n"
LBL18
	LD R0,LBL19
	JSRR R0
	BRnzp LBL20
LBL19
	.FILL PRINTF
LBL20
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL21
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL22
LBL21
	.FILL #3
LBL22
	LDR R0,R6,#0
	ADD R6,R6,#1
	STR R0,R5,#3
	;  LBL24
	LD R3,LBL23
	JMP R3
LBL23
	.FILL LBL1
LBL24
LBL6
	LDR R0,R5,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL25
	JSRR R0
	BRnzp LBL26
LBL25
	.FILL SRAND
LBL26
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL29
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL30
LBL29
	.FILL #0
LBL30
	ADD R0,R5,#-1
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL27
	LD R0,LBL32
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL33
LBL32
	.FILL #3
LBL33
	LDR R0,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnz LBL31
	ADD R2,R2,#1
LBL31
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL35
	LD R3,LBL34
	JMP R3
LBL34
	.FILL LBL28
LBL35
	LD R0,LBL36
	JSRR R0
	BRnzp LBL37
LBL36
	.FILL RAND
LBL37
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL38
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL39
LBL38
	.FILL #10
LBL39
	LDR R1,R6,#0
	ADD R6,R6,#1
	LDR R0,R6,#0
	ADD R6,R6,#1
	LD R3,LBL40
	JSRR R3
	BRnzp LBL41
LBL40
	.FILL MODULUS
LBL41
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL42
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL43
LBL42
	.FILL #5
LBL43
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R0,R1,R0
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	LDR R0,R5,#-1
	ADD R1,R0,#1
	STR R1,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	;  LBL45
	LD R3,LBL44
	JMP R3
LBL44
	.FILL LBL27
LBL45
LBL28
	LD R0,LBL48
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL49
LBL48
	.FILL #0
LBL49
	ADD R0,R5,#-3
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL46
	LD R0,LBL51
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL52
LBL51
	.FILL #0
LBL52
	LDR R0,R5,#-3
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL50
	ADD R2,R2,#1
LBL50
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL54
	LD R3,LBL53
	JMP R3
LBL53
	.FILL LBL47
LBL54
	LD R0,LBL57
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL58
LBL57
	.FILL #0
LBL58
	ADD R0,R5,#-1
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL55
	LD R0,LBL60
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL61
LBL60
	.FILL #3
LBL61
	LDR R0,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnz LBL59
	ADD R2,R2,#1
LBL59
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL63
	LD R3,LBL62
	JMP R3
LBL62
	.FILL LBL56
LBL63
	LDR R0,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL64
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL65
LBL64
	.FILL #1
LBL65
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LEA R0,LBL66
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL67
LBL66
	.STRINGZ "Pile %d: "
LBL67
	LD R0,LBL68
	JSRR R0
	BRnzp LBL69
LBL68
	.FILL PRINTF
LBL69
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#2
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL72
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL73
LBL72
	.FILL #0
LBL73
	ADD R0,R5,#-2
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL70
	LDR R0,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-2
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnz LBL74
	ADD R2,R2,#1
LBL74
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL76
	LD R3,LBL75
	JMP R3
LBL75
	.FILL LBL71
LBL76
	LEA R0,LBL77
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL78
LBL77
	.STRINGZ "*"
LBL78
	LD R0,LBL79
	JSRR R0
	BRnzp LBL80
LBL79
	.FILL PRINTF
LBL80
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LDR R0,R5,#-2
	ADD R1,R0,#1
	STR R1,R5,#-2
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	;  LBL82
	LD R3,LBL81
	JMP R3
LBL81
	.FILL LBL70
LBL82
LBL71
	LEA R0,LBL83
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL84
LBL83
	.STRINGZ "\n"
LBL84
	LD R0,LBL85
	JSRR R0
	BRnzp LBL86
LBL85
	.FILL PRINTF
LBL86
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LDR R0,R5,#-1
	ADD R1,R0,#1
	STR R1,R5,#-1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	;  LBL88
	LD R3,LBL87
	JMP R3
LBL87
	.FILL LBL55
LBL88
LBL56
	LD R0,LBL91
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL92
LBL91
	.FILL #0
LBL92
	ADD R0,R5,#-4
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL89
	LD R0,LBL94
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL95
LBL94
	.FILL #0
LBL95
	LDR R0,R5,#-4
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL93
	ADD R2,R2,#1
LBL93
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL97
	LD R3,LBL96
	JMP R3
LBL96
	.FILL LBL90
LBL97
	LEA R0,LBL98
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL99
LBL98
	.STRINGZ "From which pile will you take sticks? "
LBL99
	LD R0,LBL100
	JSRR R0
	BRnzp LBL101
LBL100
	.FILL PRINTF
LBL101
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL111
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL112
LBL111
	.FILL #1
LBL112
	ADD R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LEA R0,LBL113
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL114
LBL113
	.STRINGZ "%d"
LBL114
	LD R0,LBL115
	JSRR R0
	BRnzp LBL116
LBL115
	.FILL SCANF
LBL116
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#2
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRz LBL110
	ADD R2,R2,#1
LBL110
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL118
	LD R3,LBL117
	JMP R3
LBL117
	.FILL LBL108
LBL118
	LD R0,LBL120
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL121
LBL120
	.FILL #1
LBL121
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnz LBL119
	ADD R2,R2,#1
LBL119
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL108
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL109
LBL108
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL109
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL123
	LD R3,LBL122
	JMP R3
LBL122
	.FILL LBL106
LBL123
	LD R0,LBL125
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL126
LBL125
	.FILL #3
LBL126
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRzp LBL124
	ADD R2,R2,#1
LBL124
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL106
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL107
LBL106
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL107
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL128
	LD R3,LBL127
	JMP R3
LBL127
	.FILL LBL104
LBL128
	LD R0,LBL130
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL131
LBL130
	.FILL #0
LBL131
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL132
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL133
LBL132
	.FILL #1
LBL133
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	NOT R0,R0
	ADD R0,R0,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL129
	ADD R2,R2,#1
LBL129
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL104
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL105
LBL104
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL105
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL135
	LD R3,LBL134
	JMP R3
LBL134
	.FILL LBL102
LBL135
	LEA R0,LBL136
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL137
LBL136
	.STRINGZ "That's not a good choice.\n"
LBL137
	LD R0,LBL138
	JSRR R0
	BRnzp LBL139
LBL138
	.FILL PRINTF
LBL139
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	;  LBL141
	LD R3,LBL140
	JMP R3
LBL140
	.FILL LBL103
LBL141
LBL102
	LD R0,LBL142
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL143
LBL142
	.FILL #1
LBL143
	ADD R0,R5,#-4
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL144
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL145
LBL144
	.FILL #1
LBL145
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	NOT R0,R0
	ADD R0,R0,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R0,R5,#-5
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL103
	;  LBL147
	LD R3,LBL146
	JMP R3
LBL146
	.FILL LBL89
LBL147
LBL90
	LD R0,LBL150
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL151
LBL150
	.FILL #0
LBL151
	ADD R0,R5,#-4
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL148
	LD R0,LBL153
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL154
LBL153
	.FILL #0
LBL154
	LDR R0,R5,#-4
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL152
	ADD R2,R2,#1
LBL152
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL156
	LD R3,LBL155
	JMP R3
LBL155
	.FILL LBL149
LBL156
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL157
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL158
LBL157
	.FILL #1
LBL158
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LEA R0,LBL159
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL160
LBL159
	.STRINGZ "How many sticks will you take from pile %d? "
LBL160
	LD R0,LBL161
	JSRR R0
	BRnzp LBL162
LBL161
	.FILL PRINTF
LBL162
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#2
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL170
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL171
LBL170
	.FILL #1
LBL171
	ADD R0,R5,#-6
	ADD R6,R6,#-1
	STR R0,R6,#0
	LEA R0,LBL172
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL173
LBL172
	.STRINGZ "%d"
LBL173
	LD R0,LBL174
	JSRR R0
	BRnzp LBL175
LBL174
	.FILL SCANF
LBL175
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#2
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRz LBL169
	ADD R2,R2,#1
LBL169
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL177
	LD R3,LBL176
	JMP R3
LBL176
	.FILL LBL167
LBL177
	LD R0,LBL179
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL180
LBL179
	.FILL #0
LBL180
	LDR R0,R5,#-6
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRn LBL178
	ADD R2,R2,#1
LBL178
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL167
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL168
LBL167
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL168
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL182
	LD R3,LBL181
	JMP R3
LBL181
	.FILL LBL165
LBL182
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-6
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRzp LBL183
	ADD R2,R2,#1
LBL183
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL165
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL166
LBL165
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL166
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL185
	LD R3,LBL184
	JMP R3
LBL184
	.FILL LBL163
LBL185
	LEA R0,LBL186
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL187
LBL186
	.STRINGZ "That's not a good choice.\n"
LBL187
	LD R0,LBL188
	JSRR R0
	BRnzp LBL189
LBL188
	.FILL PRINTF
LBL189
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	;  LBL191
	LD R3,LBL190
	JMP R3
LBL190
	.FILL LBL164
LBL191
LBL163
	LD R0,LBL192
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL193
LBL192
	.FILL #1
LBL193
	ADD R0,R5,#-4
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL164
	;  LBL195
	LD R3,LBL194
	JMP R3
LBL194
	.FILL LBL148
LBL195
LBL149
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-6
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	NOT R0,R0
	ADD R0,R0,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R0,R1,R0
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	LD R0,LBL203
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL204
LBL203
	.FILL #0
LBL204
	LD R0,LBL205
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL206
LBL205
	.FILL #0
LBL206
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL202
	ADD R2,R2,#1
LBL202
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL208
	LD R3,LBL207
	JMP R3
LBL207
	.FILL LBL201
LBL208
	LD R0,LBL210
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL211
LBL210
	.FILL #0
LBL211
	LD R0,LBL212
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL213
LBL212
	.FILL #1
LBL213
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL209
	ADD R2,R2,#1
LBL209
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL201
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL200
LBL201
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL200
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL215
	LD R3,LBL214
	JMP R3
LBL214
	.FILL LBL199
LBL215
	LD R0,LBL217
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL218
LBL217
	.FILL #0
LBL218
	LD R0,LBL219
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL220
LBL219
	.FILL #2
LBL220
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL216
	ADD R2,R2,#1
LBL216
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL199
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL198
LBL199
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL198
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL222
	LD R3,LBL221
	JMP R3
LBL221
	.FILL LBL196
LBL222
	LEA R0,LBL223
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL224
LBL223
	.STRINGZ "You win!\n"
LBL224
	LD R0,LBL225
	JSRR R0
	BRnzp LBL226
LBL225
	.FILL PRINTF
LBL226
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL227
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL228
LBL227
	.FILL #1
LBL228
	ADD R0,R5,#-3
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	;  LBL230
	LD R3,LBL229
	JMP R3
LBL229
	.FILL LBL197
LBL230
LBL196
	LD R0,LBL233
	JSRR R0
	BRnzp LBL234
LBL233
	.FILL RAND
LBL234
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL235
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL236
LBL235
	.FILL #3
LBL236
	LDR R1,R6,#0
	ADD R6,R6,#1
	LDR R0,R6,#0
	ADD R6,R6,#1
	LD R3,LBL237
	JSRR R3
	BRnzp LBL238
LBL237
	.FILL MODULUS
LBL238
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R0,R5,#-5
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL231
	LD R0,LBL240
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL241
LBL240
	.FILL #0
LBL241
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL239
	ADD R2,R2,#1
LBL239
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL243
	LD R3,LBL242
	JMP R3
LBL242
	.FILL LBL232
LBL243
	LD R0,LBL244
	JSRR R0
	BRnzp LBL245
LBL244
	.FILL RAND
LBL245
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL246
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL247
LBL246
	.FILL #3
LBL247
	LDR R1,R6,#0
	ADD R6,R6,#1
	LDR R0,R6,#0
	ADD R6,R6,#1
	LD R3,LBL248
	JSRR R3
	BRnzp LBL249
LBL248
	.FILL MODULUS
LBL249
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R0,R5,#-5
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	;  LBL251
	LD R3,LBL250
	JMP R3
LBL250
	.FILL LBL231
LBL251
LBL232
	LD R0,LBL252
	JSRR R0
	BRnzp LBL253
LBL252
	.FILL RAND
LBL253
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	LDR R0,R6,#0
	ADD R6,R6,#1
	LD R3,LBL254
	JSRR R3
	BRnzp LBL255
LBL254
	.FILL MODULUS
LBL255
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL256
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL257
LBL256
	.FILL #1
LBL257
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R0,R5,#-6
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,LBL258
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL259
LBL258
	.FILL #1
LBL259
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-6
	ADD R6,R6,#-1
	STR R0,R6,#0
	LEA R0,LBL260
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL261
LBL260
	.STRINGZ "I take %d from pile %d\n"
LBL261
	LD R0,LBL262
	JSRR R0
	BRnzp LBL263
LBL262
	.FILL PRINTF
LBL263
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#3
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-6
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	LDR R1,R6,#0
	ADD R6,R6,#1
	NOT R0,R0
	ADD R0,R0,#1
	ADD R0,R0,R1
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R0,R5,#-5
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R0,R1,R0
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
	LD R0,LBL271
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL272
LBL271
	.FILL #0
LBL272
	LD R0,LBL273
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL274
LBL273
	.FILL #0
LBL274
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL270
	ADD R2,R2,#1
LBL270
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL276
	LD R3,LBL275
	JMP R3
LBL275
	.FILL LBL269
LBL276
	LD R0,LBL278
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL279
LBL278
	.FILL #0
LBL279
	LD R0,LBL280
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL281
LBL280
	.FILL #1
LBL281
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL277
	ADD R2,R2,#1
LBL277
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL269
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL268
LBL269
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL268
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL283
	LD R3,LBL282
	JMP R3
LBL282
	.FILL LBL267
LBL283
	LD R0,LBL285
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL286
LBL285
	.FILL #0
LBL286
	LD R0,LBL287
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL288
LBL287
	.FILL #2
LBL288
	LDR R1,R6,#0
	ADD R6,R6,#1
	ADD R0,R4,#0
	ADD R1,R1,R0
	LDR R0,R1,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
	LDR R1,R6,#0
	LDR R0,R6,#1
	ADD R6,R6,#2
	AND R2,R2,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	BRnp LBL284
	ADD R2,R2,#1
LBL284
	ADD R6,R6,#-1
	STR R2,R6,#0
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRz LBL267
	AND R0,R0,#0
	ADD R0,R0,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL266
LBL267
	AND R0,R0,#0
	ADD R6,R6,#-1
	STR R0,R6,#0
LBL266
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R0,R0,#0
	BRnp LBL290
	LD R3,LBL289
	JMP R3
LBL289
	.FILL LBL264
LBL290
	LEA R0,LBL291
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL292
LBL291
	.STRINGZ "I win!\n"
LBL292
	LD R0,LBL293
	JSRR R0
	BRnzp LBL294
LBL293
	.FILL PRINTF
LBL294
	LDR R0,R6,#0
	ADD R6,R6,#1
	ADD R6,R6,#1
	ADD R6,R6,#-1
	STR R0,R6,#0
	ADD R6,R6,#1
	LD R0,LBL295
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL296
LBL295
	.FILL #1
LBL296
	ADD R0,R5,#-3
	LDR R1,R6,#0
	STR R1,R0,#0
	ADD R6,R6,#1
LBL264
LBL197
	;  LBL298
	LD R3,LBL297
	JMP R3
LBL297
	.FILL LBL46
LBL298
LBL47
	LD R0,LBL299
	ADD R6,R6,#-1
	STR R0,R6,#0
	BRnzp LBL300
LBL299
	.FILL #0
LBL300
	LDR R0,R6,#0
	ADD R6,R6,#1
	STR R0,R5,#3
	;  LBL302
	LD R3,LBL301
	JMP R3
LBL301
	.FILL LBL1
LBL302
LBL1

;---------------------------------------------------------------------------
; STUDENT CODE ENDS HERE
;---------------------------------------------------------------------------

	LDR	R0,R6,#0	; restore R0...R3
	LDR	R1,R6,#1
	LDR	R2,R6,#2
	LDR	R3,R6,#3

	ADD	R6,R5,#1	; pop off local variables
	LDR	R5,R6,#0
	LDR	R7,R6,#1
	ADD	R6,R6,#2	; leave return value on stack
	RET
	
;---------------------------------------------------------------------------
; C library routines
;---------------------------------------------------------------------------

; assembly routines in this library
;   MULTIPLY (R0 <- R0 * R1)
;   DIVIDE   (R0 <- R0 / R1, rounded toward 0)
;   MODULUS  (R0 <- R0 MOD R1, using C's definition)

; routines with C interfaces in this library
;   int PRINTF (const char* fmt, ...);
;   int SCANF (const char* fmt, ...);
;   void SRAND (int new_seed);
;   int RAND ();
; NOTES: 
;    - ALL C ROUTINES LEAVE A RETURN VALUE LOCATION ON THE STACK, EVEN
;      IF THEY PRODUCE NO RETURN VALUE!
;    - PRINTF and SCANF only handle %d, %%, \n, \\, and normal characters
;

; INTERNAL routines (you should not call them)
;   LOG_RIGHT_SHIFT
;   PRINT_NUM
;   LOAD_FORMAT
;

;---------------------------------------------------------------------------

; MULTIPLY -- calculate R0 * R1
;     INPUTS -- R0 and R1
;     OUTPUTS -- R0 is the product
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: the calling convention here is NOT for use directly by C
;
MULTIPLY
	ADD R6,R6,#-3	; save R1, R2, and R3
	STR R1,R6,#0
	STR R2,R6,#1
	STR R3,R6,#2

	AND R2,R2,#0	; number of negative operands

	ADD R1,R1,#0	; set R1 to its absolute value
	BRzp MULT_R1_NON_NEG
	NOT R1,R1
	ADD R1,R1,#1
	ADD R2,R2,#1
MULT_R1_NON_NEG

	AND R3,R3,#0
MULT_LOOP
	ADD R1,R1,#0
	BRz MULT_FINISH
	ADD R3,R3,R0
	ADD R1,R1,#-1
	BRnzp MULT_LOOP

MULT_FINISH
	ADD R0,R3,#0	; move result into R0

	AND R2,R2,#1	; negate answer?
	BRz MULT_DONE
	NOT R0,R0
	ADD R0,R0,#1

MULT_DONE
	LDR R1,R6,#0	; restore R1, R2, and R3
	LDR R2,R6,#1
	LDR R3,R6,#2
	ADD R6,R6,#3
	RET


; DIVIDE -- calculate R0 / R1 (rounded toward zero)
;     INPUTS -- R0 and R1
;     OUTPUTS -- R0 is the quotient
;     SIDE EFFECTS -- uses stack to save registers; may print divide by
;                     zero error
;     NOTE: the calling convention here is NOT for use directly by C
;
DIVIDE	ADD R6,R6,#-4	; save R1, R2, R3, and R7
	STR R1,R6,#0
	STR R2,R6,#1
	STR R3,R6,#2
	STR R7,R6,#3

	AND R2,R2,#0	; number of negative operands
	ADD R2,R2,#1

	ADD R1,R1,#0	; set R1 to its negative absolute value
	BRn DIV_R1_NEG
	BRp DIV_R1_POS
	LEA R0,MSG_DIV
	PUTS
	AND R0,R0,#0
	BRnzp DIV_DONE
DIV_R1_POS
	NOT R1,R1
	ADD R1,R1,#1
	ADD R2,R2,#-1
DIV_R1_NEG

	ADD R0,R0,#0	; set R0 to its absolute value
	BRzp DIV_R0_NON_NEG
	NOT R0,R0
	ADD R0,R0,#1
	ADD R2,R2,#1
DIV_R0_NON_NEG

	AND R3,R3,#0
DIV_LOOP
	ADD R0,R0,R1
	BRn DIV_FINISH
	ADD R3,R3,#1
	BRnzp DIV_LOOP
DIV_FINISH
	ADD R0,R3,#0	; move result into R0

	AND R2,R2,#1	; negate answer?
	BRz DIV_DONE
	NOT R0,R0
	ADD R0,R0,#1

DIV_DONE
	LDR R1,R6,#0	; restore R1, R2, R3, and R7
	LDR R2,R6,#1
	LDR R3,R6,#2
	LDR R7,R6,#3
	ADD R6,R6,#4
	RET

MSG_DIV	.STRINGZ "\nDIVIDE BY ZERO\n"



; MODULUS -- calculate R0 MOD R1 (defined in C as R0 - (R0 / R1) * R1)
;     INPUTS -- R0 and R1
;     OUTPUTS -- R0 is the modulus
;     SIDE EFFECTS -- uses stack to save registers; may print divide by
;                     zero error
;     NOTE: the calling convention here is NOT for use directly by C
;
MODULUS	ADD R6,R6,#-3	; save R0, R1, and R7
	STR R0,R6,#0
	STR R1,R6,#1
	STR R7,R6,#2

	JSR DIVIDE	; R0 = R0 / R1
	JSR MULTIPLY	; R0 = (R0 / R1) * R1
	NOT R1,R0	; negate it
	ADD R1,R1,#1
	LDR R0,R6,#0	; add to original R0
	ADD R0,R0,R1

	LDR R1,R6,#1	; restore R1 and R7
	LDR R7,R6,#2
	ADD R6,R6,#3
	RET


; SRAND -- set random number generation seed
;     INPUTS -- new seed (on top of stack)
;     OUTPUTS -- one (meaningless) location left on top of stack
;     SIDE EFFECTS -- changes random seed
;     NOTE: call as a C function
;
SRAND	ADD R6,R6,#-1		; save R0
	STR R0,R6,#0
	LDR R0,R6,#1
	ST R0,RAND_SEED
	LDR R0,R6,#0		; restore R0
	RET


; LOG_RIGHT_SHIFT -- logically shift R0 right by one bit (MSB <- 0)
;     INPUTS -- R0
;     OUTPUTS -- R0 shifted right by a bit
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: the calling convention here is NOT for use directly by C
;
LOG_RIGHT_SHIFT
	ADD R6,R6,#-1		; save R1
	STR R1,R6,#0

	AND R0,R0,xFFFE		; set low bit to 0 (will become MSB)

	AND R1,R1,#0		; loop 15 times...
	ADD R1,R1,#15

LRSHFT_LOOP
	ADD R0,R0,#0		; rotate left (copy high bit to low bit)
	BRn LOW_BIT_IS_1
	ADD R0,R0,R0
	BRnzp LRSHFT_NEXT
LOW_BIT_IS_1
	ADD R0,R0,R0
	ADD R0,R0,1

LRSHFT_NEXT
	ADD R1,R1,#-1
	BRp LRSHFT_LOOP

	LDR R1,R6,#0		; restore R1
	ADD R6,R6,#1
	RET


; RAND -- generate random number using the function
;             NEW = (27193 * OLD) + 35993   MOD 65536
;	  the low bit is right-shifted out before returning, since
;         it is not random (the rest are not too bad, at least by 
;         separation of order 2 in Knuth's methods...)
;     INPUTS -- none
;     OUTPUTS -- random value left on top of stack (return value)
;     SIDE EFFECTS -- changes random seed
;     NOTE: call as a C function
;
RAND	ADD R6,R6,#-3		; save R0, R1, and R7
	STR R0,R6,#0
	STR R1,R6,#1
	STR R7,R6,#2
	LD R0,RAND_SEED
	ADD R1,R0,R0		; x 0002
	ADD R1,R1,R0		; x 0003
	ADD R1,R1,R1		; x 0006
	ADD R1,R1,R1		; x 000C
	ADD R1,R1,R0		; x 000D
	ADD R1,R1,R1		; x 001A
	ADD R1,R1,R1		; x 0034
	ADD R1,R1,R0		; x 0035
	ADD R1,R1,R1		; x 006A
	ADD R1,R1,R1		; x 00D4
	ADD R1,R1,R1		; x 01A8
	ADD R1,R1,R1		; x 0350
	ADD R1,R1,R0		; x 0351
	ADD R1,R1,R1		; x 06A2
	ADD R1,R1,R0		; x 06A3
	ADD R1,R1,R1		; x 0D46
	ADD R1,R1,R0		; x 0D47
	ADD R1,R1,R1		; x 1A8E
	ADD R1,R1,R1		; x 351C
	ADD R1,R1,R1		; x 6A38
	ADD R0,R1,R0		; x 6A39 = #27193
	LD R1,RAND_ADD
	ADD R0,R0,R1
	ST R0,RAND_SEED
	JSR LOG_RIGHT_SHIFT	; drop the low bit
	LDR R7,R6,#2		; restore R7
	STR R0,R6,#2		; save return value onto stack
	LDR R0,R6,#0		; restore R0 and R1 
	LDR R1,R6,#1
	ADD R6,R6,#2
	RET

; storage for SRAND and RAND

RAND_SEED 
	.BLKW 1
RAND_ADD
	.FILL #35993


; PRINT_NUM -- print a number in decimal to the monitor (based on code 
;              incorporated as TRAP x26 for MP2 in the Spring 2004 
;              semester of ECE190)
;     INPUTS -- R0 is the number to be printed
;     OUTPUTS -- R0 is the number of characters printed
;     SIDE EFFECTS -- none
;     NOTE: the calling convention here is NOT for use directly by C
;
; The basic strategy is to handle the sign first, then to loop over place
; values starting from 10,000 down to 10.  Place values are subtracted
; repeatedly to calculate each digit, then digits are printed, with 
; leading zeroes omitted.

; R0 is the current digit (calculated in the inner loop)
; R1 points to table of negative digit place values
; R2 holds current digit's place value, again negative
; R3 is the remaining value after removing the previous digit
; R4 is a temporary
; R5 holds the ASCII value '0'
; R6 is a marker used to avoid leading zeroes

PRINT_NUM
	ST R1,PN_SAVE_R1	; callee saves registers
	ST R2,PN_SAVE_R2
	ST R3,PN_SAVE_R3
	ST R4,PN_SAVE_R4
	ST R5,PN_SAVE_R5
	ST R6,PN_SAVE_R6
	ST R7,PN_SAVE_R7

	AND R3,R0,#0		; initialize number of characters printed
	ST R3,PN_PRINTED

	ADD R3,R0,#0		; move to R3 and check for negative value
	BRzp PN_NON_NEG
	LD R0,PN_MINUS		; if negative, print a minus sign
	OUT
	LD R0,PN_PRINTED	; add one to printed characters count
	ADD R0,R0,#1
	ST R0,PN_PRINTED
	NOT R3,R3		; and replace R0 with its absolute value
	ADD R3,R3,#1		; (-32768 will be handled correctly, too)
PN_NON_NEG
	
	LEA R1,PN_SUB		; initialize pointer to place value table
	LD R5,PN_ASC_ZERO	; initialize register with ASCII '0'
	AND R6,R6,#0		; skip leading zeroes
PN_LOOP
	LDR R2,R1,#0		; load digit place value from table
	BRz PN_LAST_DIGIT	; end of table?
	AND R0,R0,#0		; start current digit at 0 (count ADDs)
PN_DIG_LOOP			; loop to determine digit value
	ADD R4,R3,R2		; subtract place value once
	BRn PN_DIG_DONE		; done?
	ADD R3,R4,#0		; no, so copy to remaining value
	ADD R0,R0,#1		;   and increment digit
	BRnzp PN_DIG_LOOP
PN_DIG_DONE
	ADD R4,R0,R6		; do not print leading zeroes
	BRz PN_NO_PRINT
	ADD R0,R0,R5		; print current digit
	OUT
	LD R0,PN_PRINTED	; add one to printed characters count
	ADD R0,R0,#1
	ST R0,PN_PRINTED
	ADD R6,R6,#1		; always print subsequent digits, even zeroes
PN_NO_PRINT
	ADD R1,R1,#1		; point to next place value
	BRnzp PN_LOOP		; loop back for next digit
PN_LAST_DIGIT
	ADD R0,R3,R5		; always print last digit
	OUT
	LD R0,PN_PRINTED	; add one to printed characters count
	ADD R0,R0,#1

	LD R1,PN_SAVE_R1	; restore original register values
	LD R2,PN_SAVE_R2
	LD R3,PN_SAVE_R3
	LD R4,PN_SAVE_R4
	LD R5,PN_SAVE_R5
	LD R6,PN_SAVE_R6
	LD R7,PN_SAVE_R7
	RET

PN_SAVE_R1 .BLKW 1		; space for caller's register values
PN_SAVE_R2 .BLKW 1
PN_SAVE_R3 .BLKW 1
PN_SAVE_R4 .BLKW 1
PN_SAVE_R5 .BLKW 1
PN_SAVE_R6 .BLKW 1
PN_SAVE_R7 .BLKW 1
PN_PRINTED .BLKW 1

PN_SUB  .FILL #-10000		; table of place values
	.FILL #-1000
	.FILL #-100
	.FILL #-10
	.FILL #0

PN_ASC_ZERO .FILL x30		; '0'
PN_MINUS    .FILL x2D		; '-'


; LOAD_FORMAT -- load a character from a format string (for PRINTF or
;		 SCANF), translating escape sequences (-1 for %d)
;                and advancing the string pointer appropriately
;     INPUTS -- R1 is the format string pointer
;     OUTPUTS -- R0 is the next character (-1 for %d)
;                R1 is advanced either one or two locations
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: the calling convention here is NOT for use directly by C
;
LOAD_FORMAT
	ADD R6,R6,#-2	; save R2 and R3
	STR R2,R6,#0
	STR R3,R6,#1
	LDR R0,R1,#0
	LD R2,LDF_TEST_1
	ADD R3,R0,R2
	BRnp LDF_NOT_PCT
	LDR R0,R1,#1
	ADD R2,R0,R2
	BRnp LDF_CHECK_D
	ADD R1,R1,#1
LDF_BAD_PCT
	LDR R0,R1,#0
	BRnzp LDF_DONE
LDF_CHECK_D
	LD R2,LDF_TEST_2
	ADD R0,R0,R2
	BRnp LDF_BAD_PCT
	AND R0,R0,#0
	ADD R0,R0,#-1
	ADD R1,R1,#1
	BRnzp LDF_DONE
LDF_NOT_PCT
	LD R2,LDF_TEST_3
	ADD R3,R0,R2
	BRnp LDF_DONE
	LDR R0,R1,#1
	ADD R2,R0,R2
	BRnp LDF_CHECK_N
	ADD R1,R1,#1
LDF_BAD_BS
	LDR R0,R1,#0
	BRnzp LDF_DONE
LDF_CHECK_N
	LD R2,LDF_TEST_4
	ADD R0,R0,R2
	BRnp LDF_BAD_BS
	AND R0,R0,#0
	ADD R0,R0,#10
	ADD R1,R1,#1
LDF_DONE
	ADD R1,R1,#1	; default string pointer advance
	LDR R2,R6,#0	; restore R2 and R3
	LDR R3,R6,#1
	ADD R6,R6,#2
	RET

LDF_TEST_1 	.FILL xFFDB	; -'%'
LDF_TEST_2	.FILL xFF9C	; -'d'
LDF_TEST_3	.FILL xFFA4	; -'\\'
LDF_TEST_4	.FILL xFF92	; -'n'


; PRINTF -- print formatted data
;     INPUTS -- format string followed by arguments
;     OUTPUTS -- number of characters printed left on top of stack 
;                (return value)
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: call as a C function
;
; R0 holds the character to print
; R1 is the format string pointer
; R2 points to the next argument
; R3 is the number of characters printed so far
;
PRINTF	ADD R6,R6,#-5		; save R0, R1, R2, R3, and R7
	STR R0,R6,#0
	STR R1,R6,#1
	STR R2,R6,#2
	STR R3,R6,#3
	STR R7,R6,#4
	LDR R1,R6,#5
	ADD R2,R6,#6
	AND R3,R3,#0
PR_LOOP	JSR LOAD_FORMAT
	ADD R0,R0,#0
	BRz PR_DONE
	BRp PR_REG
	LDR R0,R2,#0
	ADD R2,R2,#1
	JSR PRINT_NUM
	ADD R3,R3,R0
	BRnzp PR_LOOP
PR_REG	OUT
	ADD R3,R3,#1
	BRnzp PR_LOOP
PR_DONE	LDR R7,R6,#4		; restore R7
	STR R3,R6,#4		; save return value
	LDR R0,R6,#0		; restore R0, R1, R2, and R3
	LDR R1,R6,#1
	LDR R2,R6,#2
	LDR R3,R6,#3
	ADD R6,R6,#4
	RET


; BUF_GETC -- read a character from the keyboard, with preference for
;                a character previously read but buffered (in INBUF)
;     INPUTS -- none
;     OUTPUTS -- R4 holds the character
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: the calling convention here is NOT for use directly by C
;
BUF_GETC
	ADD R6,R6,#-2
	STR R0,R6,#0
	STR R7,R6,#1
	LD R4,INBUF
	BRnp BGC_OLD
	GETC
	OUT
	ADD R4,R0,#0
	BRnzp BGC_DONE
BGC_OLD	LD R0,INBUF2
        ST R0,INBUF
	AND R0,R0,#0
	ST R0,INBUF
BGC_DONE
	LDR R0,R6,#0
	LDR R7,R6,#1
	ADD R6,R6,#2
	RET

; BUF_UNGETC -- push a character back into the input buffer
;     INPUTS -- R4 holds the character
;     OUTPUTS -- none
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: the calling convention here is NOT for use directly by C
;
BUF_UNGETC
	ADD R6,R6,#-1
	STR R0,R6,#0
	LD R0,INBUF
	ST R0,INBUF2
	ST R4,INBUF
	LDR R0,R6,#0
	ADD R6,R6,#1
	RET

; READ_NUM -- read a decimal number from the keyboard, starting with
;             a character previously read but buffered (in INBUF) if necessary;
;             skip white space before the first digit; terminate on non-digit
;             (after first digit); buffer character that causes termination;
;             ignore overflow
;             (this code based on readnumsub.asm code from 190 materials)
;     INPUTS -- none
;     OUTPUTS -- R4 holds the number typed in; R0 holds 1 if number was typed,
;                or 0 if not
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: the calling convention here is NOT for use directly by C
;

; R0 is used as a temporary register
; R1 holds the current value of the number being input
; R2 holds the additive inverse of ASCII '0' (0xFFD0)
; R3 is used as a temporary register
; R4 holds the value of the last key pressed
; R5 marks whether a digit has been seen (positive), just a negative sign (-),
;    or nothing has been seen (0) yet

READ_NUM
	ADD R6,R6,#-5		; save R1, R2, R3, R5, and R7
	STR R1,R6,#0
	STR R2,R6,#1
	STR R3,R6,#2
	STR R5,R6,#3
	STR R7,R6,#4
	AND R1,R1,#0		; clear the current value
	LD R2,RN_NEG_0		; put the value -x30 in R2
	AND R5,R5,#0		; no digits yet
	ST R5,RN_NEGATE
READ_LOOP
	JSR BUF_GETC
	ADD R0,R4,R2		; subtract x30 from R4 and store in R0 
	BRn RN_NON_DIG		; smaller than '0' means a non-digit
	ADD R3,R0,#-10		; check if > '9'
	BRzp RN_NON_DIG		; greater than '9' means a non-digit
	ADD R5,R4,#0		; a digit has been seen
	ADD R3,R1,R1		; sequence of adds multiplies R1 by 10
	ADD R3,R3,R3
	ADD R1,R1,R3
	ADD R1,R1,R1
	ADD R1,R1,R0		; finally, add in new digit
	BRnzp READ_LOOP		; get another digit
RN_NON_DIG
	; if we see space, tab, CR, or LF, we consume if no digits have
	; been seen; otherwise, we stop and buffer the character
	AND R0,R0,#0
	ADD R5,R5,#0
	BRp RN_GOT_NUM 
	BRz RN_NO_DIGITS

	; need to put the minus sign back, too
	JSR BUF_UNGETC
	LD R4,RN_MINUS
	BRnzp RN_SAVE_CHAR

RN_NO_DIGITS
	ADD R3,R4,#-9
	BRz READ_LOOP
	ADD R3,R4,#-10
	BRz READ_LOOP
	ADD R3,R4,#-13
	BRz READ_LOOP
	ADD R3,R4,#-16
	ADD R3,R3,#-16
	BRz READ_LOOP

	LD R3,RN_NEG_MIN
	ADD R3,R3,R4
	BRnp RN_SAVE_CHAR
	ADD R5,R5,#-1
	ST R5,RN_NEGATE
	BRnzp READ_LOOP

RN_GOT_NUM
	ADD R0,R0,#1
	LD R5,RN_NEGATE
	BRz RN_SAVE_CHAR
	NOT R1,R1
	ADD R1,R1,#1
RN_SAVE_CHAR
	JSR BUF_UNGETC
	ADD R4,R1,#0		; move R1 into R4	
	LDR R1,R6,#0		; restore R1, R2, R3, R5, and R7
	LDR R2,R6,#1
	LDR R3,R6,#2
	LDR R5,R6,#3
	LDR R7,R6,#4
	ADD R6,R6,#5
	RET

RN_NEG_0	.FILL xFFD0	; -'0'
RN_NEG_MIN	.FILL xFFD3	; -'-'
RN_MINUS	.FILL x002D	; '-'
RN_NEGATE	.BLKW 1

; SCANF -- scan in formatted data
;     INPUTS -- format string followed by arguments
;     OUTPUTS -- number of integers converted left on top of stack 
;                (return value)
;     SIDE EFFECTS -- uses stack to save registers
;     NOTE: call as a C function
;
; R0 holds the character to be read
; R1 is the format string pointer
; R2 points to the next argument
; R3 is the number of integer conversions so far
; R4 is the character/number actually read from the keyboard
;
SCANF	ADD R6,R6,#-6		; save R0, R1, R2, R3, R4, and R7
	STR R0,R6,#0
	STR R1,R6,#1
	STR R2,R6,#2
	STR R3,R6,#3
	STR R4,R6,#4
	STR R7,R6,#5
	LDR R1,R6,#6
	ADD R2,R6,#7
	AND R3,R3,#0
SC_LOOP	JSR LOAD_FORMAT
	ADD R0,R0,#0
	BRz SC_DONE
	BRp SC_REG
	JSR READ_NUM
	ADD R0,R0,#0
	BRz SC_DONE
	LDR R0,R2,#0
	ADD R2,R2,#1
	STR R4,R0,#0
	ADD R3,R3,#1
	BRnzp SC_LOOP
SC_REG	JSR BUF_GETC
	NOT R0,R0
	ADD R0,R0,#1
	ADD R0,R0,R4
	BRz SC_LOOP
	JSR BUF_UNGETC
SC_DONE	LDR R7,R6,#5		; restore R7
	STR R3,R6,#5		; save return value
	LDR R0,R6,#0		; restore R0, R1, R2, R3, and R4
	LDR R1,R6,#1
	LDR R2,R6,#2
	LDR R3,R6,#3
	LDR R4,R6,#4
	ADD R6,R6,#5
	RET

; buffered input characters (0 means none)
INBUF	.FILL x0000
INBUF2	.FILL x0000

;---------------------------------------------------------------------------
; global data space allocation
;---------------------------------------------------------------------------

GLOBDATA
	.BLKW #3

;---------------------------------------------------------------------------
; stack allocation
;---------------------------------------------------------------------------

	.BLKW #1000
STACK

	.END

