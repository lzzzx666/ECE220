




#include <stdio.h>

#include "ece220_label.h"
#include "ece220_parse.h"
#include "ece220_symtab.h"




typedef enum {
    BR_NEVER, BR_P, BR_Z, BR_ZP, BR_N, BR_NP, BR_NZ, BR_ALWAYS, NUM_BR
} br_type_t;





static void gen_long_branch (br_type_t type, ece220_label_t* label);

static void gen_statement (ast220_t* ast);
static void gen_for_statement (ast220_t* ast);
static void gen_if_statement (ast220_t* ast);
static void gen_return_statement (ast220_t* ast);
static void gen_pop_stack (ast220_t* ast);
static void gen_debug_marker (ast220_t* ast);

static void gen_expression (ast220_t* ast);
static void gen_push_int (ast220_t* ast);
static void gen_push_str (ast220_t* ast);
static void gen_push_variable (ast220_t* ast);
static void gen_func_call (ast220_t* ast);
static void gen_get_address (ast220_t* ast);
static void gen_op_assign (ast220_t* ast);
static void gen_op_pre_incr (ast220_t* ast);
static void gen_op_pre_decr (ast220_t* ast);
static void gen_op_post_incr (ast220_t* ast);
static void gen_op_post_decr (ast220_t* ast);
static void gen_op_add (ast220_t* ast);
static void gen_op_sub (ast220_t* ast);
static void gen_op_mult (ast220_t* ast);
static void gen_op_div (ast220_t* ast);
static void gen_op_mod (ast220_t* ast);
static void gen_op_negate (ast220_t* ast);
static void gen_op_log_not (ast220_t* ast);
static void gen_op_log_or (ast220_t* ast);
static void gen_op_log_and (ast220_t* ast);
static void gen_comparison (ast220_t* ast, const char* false_cond);
static void gen_op_cmp_ne (ast220_t* ast);
static void gen_op_cmp_less (ast220_t* ast);
static void gen_op_cmp_le (ast220_t* ast);
static void gen_op_cmp_eq (ast220_t* ast);
static void gen_op_cmp_ge (ast220_t* ast);
static void gen_op_cmp_greater (ast220_t* ast);



static ece220_label_t* return_label = NULL;






void MP11_generate_code (ast220_t* prog) {
	if (!return_label) return_label = label_create();		
	switch (prog->type) {						
		case AST220_FOR_STMT:
		case AST220_IF_STMT:
		case AST220_RETURN_STMT:
		case AST220_POP_STACK:
		case AST220_DEBUG_MARKER: gen_statement(prog); break;	
		default: gen_expression(prog); break;			
	}
	if (prog->next) MP11_generate_code(prog->next);			
	else printf("%s\n", label_value(return_label));			
}




static void 
gen_long_branch (br_type_t type, ece220_label_t* label)
{
    static const char* const br_names[NUM_BR] = {
        "; ", "BRp", "BRz", "BRzp", "BRn", "BRnp", "BRnz", "BRnzp"
    }; 
    br_type_t neg_type;
    ece220_label_t* target_label;
    ece220_label_t* false_label;

    neg_type = (type ^ 7);
    target_label = label_create ();
    false_label = label_create ();
    printf ("\t%s %s\n", br_names[neg_type], label_value (false_label));
    printf ("\tLD R3,%s\n\tJMP R3\n", label_value (target_label));
    printf ("%s\n", label_value (target_label));
    printf ("\t.FILL %s\n", label_value (label));
    printf ("%s\n", label_value (false_label));
}


static void 
gen_statement (ast220_t* ast)
{
    switch (ast->type) {
	case AST220_FOR_STMT:     gen_for_statement (ast);    break;
	case AST220_IF_STMT:      gen_if_statement (ast);     break;
	case AST220_RETURN_STMT:  gen_return_statement (ast); break;
	case AST220_POP_STACK:    gen_pop_stack (ast);        break;
	case AST220_DEBUG_MARKER: gen_debug_marker (ast);     break;
	default: fputs ("BAD STATEMENT TYPE\n", stderr);      break;
    }
}


static void gen_for_statement (ast220_t* ast) {
	ece220_label_t* loop_label = label_create();
	ece220_label_t* break_label = label_create();
	if (ast->left) gen_statement(ast->left);			
	printf("%s\n", label_value(loop_label));
	gen_expression(ast->test);					
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n");
	gen_long_branch(2, break_label);				
	ast220_t* current_stmt = ast->middle;
	while (current_stmt) {
		gen_statement(current_stmt);				
		current_stmt = current_stmt->next;
	}
	if (ast->right) gen_statement(ast->right);			
	gen_long_branch(7, loop_label);					
	printf("%s\n", label_value(break_label));
}


static void gen_if_statement (ast220_t* ast) {
	ece220_label_t* false_label = label_create();
	ece220_label_t* cont_label;
	gen_expression(ast->test);					
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n");
	gen_long_branch(2, false_label);				
	ast220_t* current_stmt = ast->left;
	while (current_stmt) {
		gen_statement(current_stmt);				
		current_stmt = current_stmt->next;
	}
	if (ast->right) {
		cont_label = label_create();
		gen_long_branch(7, cont_label);				
	}
	printf("%s\n", label_value(false_label));
	if (ast->right) {
		current_stmt = ast->right;
		while (current_stmt) {
			gen_statement(current_stmt);			
			current_stmt = current_stmt->next;
		}
		printf("%s\n", label_value(cont_label));
	}
}


static void gen_return_statement (ast220_t* ast) {
	gen_expression(ast->left);					
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tSTR R0,R5,#3\n");
	gen_long_branch(7, return_label);				
}


static void gen_pop_stack (ast220_t* ast) {
	gen_expression(ast->left);
	printf("\tADD R6,R6,#1\n");
}


static void 
gen_debug_marker (ast220_t* ast)
{
    printf ("; --------------- DEBUG(%d) ---------------\n", ast->value);
}


static void 
gen_expression (ast220_t* ast)
{
    switch (ast->type) {
	case AST220_PUSH_INT:     gen_push_int (ast);       break;
	case AST220_PUSH_STR:     gen_push_str (ast);       break;
	case AST220_VARIABLE:     gen_push_variable (ast);  break;
	case AST220_FUNC_CALL:    gen_func_call (ast);      break;
	case AST220_GET_ADDRESS:  gen_get_address (ast);    break;
	case AST220_OP_ASSIGN:    gen_op_assign (ast);      break;
	case AST220_OP_PRE_INCR:  gen_op_pre_incr (ast);    break;
	case AST220_OP_PRE_DECR:  gen_op_pre_decr (ast);    break;
	case AST220_OP_POST_INCR: gen_op_post_incr (ast);   break;
	case AST220_OP_POST_DECR: gen_op_post_decr (ast);   break;
	case AST220_OP_ADD:       gen_op_add (ast);         break;
	case AST220_OP_SUB:       gen_op_sub (ast);         break;
	case AST220_OP_MULT:      gen_op_mult (ast);        break;
	case AST220_OP_DIV:       gen_op_div (ast);         break;
	case AST220_OP_MOD:       gen_op_mod (ast);         break;
	case AST220_OP_NEGATE:    gen_op_negate (ast);      break;
	case AST220_OP_LOG_NOT:   gen_op_log_not (ast);     break;
	case AST220_OP_LOG_OR:    gen_op_log_or (ast);      break;
	case AST220_OP_LOG_AND:   gen_op_log_and (ast);     break;
	case AST220_CMP_NE:       gen_op_cmp_ne (ast);      break;
	case AST220_CMP_LESS:     gen_op_cmp_less (ast);    break;
	case AST220_CMP_LE:       gen_op_cmp_le (ast);      break;
	case AST220_CMP_EQ:       gen_op_cmp_eq (ast);      break;
	case AST220_CMP_GE:       gen_op_cmp_ge (ast);      break;
	case AST220_CMP_GREATER:  gen_op_cmp_greater (ast); break;
	default: fputs ("BAD EXPRESSION TYPE\n", stderr);   break;
    }
}


static void gen_push_int (ast220_t* ast) {
	ece220_label_t* value_label = label_create();
	ece220_label_t* instr_label = label_create();
	printf("\tLD R0,%s\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n\tBRnzp %s\n%s\n\t.FILL #%d\n%s\n", 	
		label_value(value_label), label_value(instr_label), label_value(value_label), ast->value, label_value(instr_label));
}


static void gen_push_str (ast220_t* ast) {
	ece220_label_t* value_label = label_create();
	ece220_label_t* instr_label = label_create();
	printf("\tLEA R0,%s\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n\tBRnzp %s\n%s\n\t.STRINGZ %s\n%s\n", 	
		label_value(value_label), label_value(instr_label), label_value(value_label), ast->name, label_value(instr_label));
}


static void gen_push_variable (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->name);					
	if (!ast->left) {
		printf("\tLDR R0,R%d,#%d\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 				
			5 - variable_entry->is_global, variable_entry->offset);
	} else {
		gen_expression(ast->left);								
		printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R%d,#%d\n\tADD R1,R1,R0\n\tLDR R0,R1,#0\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 
			5 - variable_entry->is_global, variable_entry->offset);
	}
}


static void gen_func_call (ast220_t* ast) {
	ast220_t* args = ast->left;
	int32_t args_count = 0;
	while (args) {
		gen_expression(args);									
		args = args->next;
		args_count++;
	}
	ece220_label_t* subrt_label = label_create();
	ece220_label_t* instr_label = label_create();
	printf("\tLD R0,%s\n\tJSRR R0\n\tBRnzp %s\n%s\n\t.FILL ", 					
		label_value(subrt_label), label_value(instr_label), label_value(subrt_label));
	switch (ast->fnum) {
		case AST220_PRINTF:	printf("PRINTF\n");	break;
		case AST220_RAND:	printf("RAND\n");	break;
		case AST220_SCANF:	printf("SCANF\n");	break;
		case AST220_SRAND:	printf("SRAND\n");	break;
		default: break;
	}
	printf("%s\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R6,R6,#%d\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 
		label_value(instr_label), args_count);
}


static void gen_get_address (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->left->name);				
	if (!ast->left->left) {
		printf("\tADD R0,R%d,#%d\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 				
			5 - variable_entry->is_global, variable_entry->offset);
	} else {
		gen_expression(ast->left->left);							
		printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R%d,#%d\n\tADD R0,R1,R0\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 
			5 - variable_entry->is_global, variable_entry->offset);
	}
}


static void gen_op_assign (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->left->name);				
	gen_expression(ast->right);									
	if (!ast->left->left) {										
		printf("\tADD R0,R%d,#%d\n\tLDR R1,R6,#0\n\tSTR R1,R0,#0\n", 				
			5 - variable_entry->is_global, variable_entry->offset);
	} else {											
		gen_expression(ast->left->left);							
		printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R%d,#%d\n\tADD R0,R1,R0\n\tLDR R1,R6,#0\n\tSTR R1,R0,#0\n", 
			5 - variable_entry->is_global, variable_entry->offset);
	}
}


static void gen_op_pre_incr (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->left->name);				
	printf("\tADD R0,R%d,#%d\n\tLDR R1,R0,#0\n\tADD R1,R1,#1\n\tSTR R1,R0,#0\n\tADD R6,R6,#-1\n\tSTR R1,R6,#0\n", 
		5 - variable_entry->is_global, variable_entry->offset);					
}


static void gen_op_pre_decr (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->left->name);				
	printf("\tADD R0,R%d,#%d\n\tLDR R1,R0,#0\n\tADD R1,R1,#-1\n\tSTR R1,R0,#0\n\tADD R6,R6,#-1\n\tSTR R1,R6,#0\n", 
		5 - variable_entry->is_global, variable_entry->offset);
}


static void gen_op_post_incr (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->left->name);				
	printf("\tADD R0,R%d,#%d\n\tLDR R1,R0,#0\n\tADD R2,R1,#1\n\tSTR R2,R0,#0\n\tADD R6,R6,#-1\n\tSTR R1,R6,#0\n", 
		5 - variable_entry->is_global, variable_entry->offset);
}


static void gen_op_post_decr (ast220_t* ast) {
	symtab_entry_t* variable_entry = symtab_lookup(ast->left->name);				
	printf("\tADD R0,R%d,#%d\n\tLDR R1,R0,#0\n\tADD R2,R1,#-1\n\tSTR R2,R0,#0\n\tADD R6,R6,#-1\n\tSTR R1,R6,#0\n", 
		5 - variable_entry->is_global, variable_entry->offset);
}


static void gen_op_add (ast220_t* ast) {
	gen_expression(ast->left);									
	gen_expression(ast->right);									
	printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n");			
	printf("\tADD R0,R0,R1\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n");
}


static void gen_op_sub (ast220_t* ast) {
	gen_expression(ast->left);									
	gen_expression(ast->right);
	printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n");
	printf("\tNOT R1,R1\n\tADD R1,R1,#1\n\tADD R0,R0,R1\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n");
}


static void gen_op_mult (ast220_t* ast) {
	gen_expression(ast->left);									
	gen_expression(ast->right);
	ece220_label_t* subroutine_label = label_create();
	ece220_label_t* instr_label = label_create();
	printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n");			
	printf("\tLD R3,%s\n\tJSRR R3\n\tBRnzp %s\n%s\n\t.FILL MULTIPLY\n%s\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 
		label_value(subroutine_label), label_value(instr_label), label_value(subroutine_label), label_value(instr_label));
}


static void gen_op_div (ast220_t* ast) {
	gen_expression(ast->left);									
	gen_expression(ast->right);
	ece220_label_t* subroutine_label = label_create();
	ece220_label_t* instr_label = label_create();
	printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n");
	printf("\tLD R3,%s\n\tJSRR R3\n\tBRnzp %s\n%s\n\t.FILL DIVIDE\n%s\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 
		label_value(subroutine_label), label_value(instr_label), label_value(subroutine_label), label_value(instr_label));
}


static void gen_op_mod (ast220_t* ast) {
	gen_expression(ast->left);									
	gen_expression(ast->right);
	ece220_label_t* subroutine_label = label_create();
	ece220_label_t* instr_label = label_create();
	printf("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n");
	printf("\tLD R3,%s\n\tJSRR R3\n\tBRnzp %s\n%s\n\t.FILL MODULUS\n%s\n\tADD R6,R6,#-1\n\tSTR R0,R6,#0\n", 
		label_value(subroutine_label), label_value(instr_label), label_value(subroutine_label), label_value(instr_label));
}


static void gen_op_negate (ast220_t* ast) {
	gen_expression(ast->left);									
	printf("\tLDR R0,R6,#0\n\tNOT R0,R0\n\tADD R0,R0,#1\n\tSTR R0,R6,#0\n");			
}


static void gen_op_log_not (ast220_t* ast) {
	ece220_label_t* branch_label = label_create();
	gen_expression(ast->left);									
	printf("\tAND R2,R2,#0\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n\tBRnp %s\n\tADD R2,R2,#1\n", 
		label_value(branch_label));								
	printf("%s\n\tADD R6,R6,#-1\n\tSTR R2,R6,#0\n", 
		label_value(branch_label));
}


static void gen_op_log_or (ast220_t* ast) {
	ece220_label_t* cmptf_label = label_create();
	ece220_label_t* cmptt_label = label_create();
	gen_expression(ast->left);									
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n");
	gen_long_branch(5, cmptf_label);								
	gen_expression(ast->right);									
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n\tBRnp %s\n\tAND R2,R2,#0\n\tBRnzp %s\n", 
		label_value(cmptf_label), label_value(cmptt_label));					
	printf("%s\n\tAND R2,R2,#0\n\tADD R2,R2,#1\n%s\n\tADD R6,R6,#-1\n\tSTR R2,R6,#0\n", 
		label_value(cmptf_label), label_value(cmptt_label));
}


static void gen_op_log_and (ast220_t* ast) {
	ece220_label_t* cmptf_label = label_create();
	ece220_label_t* cmptt_label = label_create();
	gen_expression(ast->left);									
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n");
	gen_long_branch(2, cmptf_label);								
	gen_expression(ast->right);
	printf("\tLDR R0,R6,#0\n\tADD R6,R6,#1\n\tADD R0,R0,#0\n\tBRz %s\n\tAND R2,R2,#0\n\tADD R2,R2,#1\n\tBRnzp %s\n", 
		label_value(cmptf_label), label_value(cmptt_label));
	printf("%s\n\tAND R2,R2,#0\n%s\n\tADD R6,R6,#-1\n\tSTR R2,R6,#0\n", 
		label_value(cmptf_label), label_value(cmptt_label));
}


static void
gen_comparison (ast220_t* ast, const char* false_cond)
{
    ece220_label_t* false_label;

    false_label = label_create ();
    gen_expression (ast->left);
    gen_expression (ast->right);
    printf ("\tLDR R1,R6,#0\n\tADD R6,R6,#1\n\tLDR R0,R6,#0\n\tADD R6,R6,#1\n");
    printf ("\tAND R2,R2,#0\n\tNOT R1,R1\n\tADD R1,R1,#1\n\tADD R0,R0,R1\n");
    printf ("\tBR%s %s\n\tADD R2,R2,#1\n", false_cond,
	    label_value (false_label));
    printf ("%s\n", label_value (false_label));
    printf ("\tADD R6,R6,#-1\n\tSTR R2,R6,#0\n");
}


static void 
gen_op_cmp_ne (ast220_t* ast)
{
    gen_comparison (ast, "z");
}


static void 
gen_op_cmp_less (ast220_t* ast)
{
    gen_comparison (ast, "zp");
}


static void 
gen_op_cmp_le (ast220_t* ast)
{
    gen_comparison (ast, "p");
}


static void 
gen_op_cmp_eq (ast220_t* ast)
{
    gen_comparison (ast, "np");
}


static void 
gen_op_cmp_ge (ast220_t* ast)
{
    gen_comparison (ast, "n");
}


static void 
gen_op_cmp_greater (ast220_t* ast)
{
    gen_comparison (ast, "nz");
}

