/*
PROLOGUE
http://www.gnu.org/software/bison/manual/bison.html#Prologue
*/

%{
#include <stdio.h>
#include "comp_grammar.h" /* symbol_table is there.*/
#include "hash_table.h" /* hash table is there*/
%}

/*
DECLARATIONS
*/

/* Declaração dos tokens da gramática da Linguagem K */
%token TK_PR_INT	256		
%token TK_PR_FLOAT	257
%token TK_PR_BOOL	258
%token TK_PR_CHAR	259
%token TK_PR_STRING	260
%token TK_PR_IF		261
%token TK_PR_THEN	262
%token TK_PR_ELSE	263
%token TK_PR_WHILE	264
%token TK_PR_DO		265
%token TK_PR_INPUT	267
%token TK_PR_OUTPUT	268
%token TK_PR_RETURN	269

%token TK_OC_LE		270
%token TK_OC_GE		271
%token TK_OC_EQ		272	
%token TK_OC_NE		273
%token TK_OC_AND	274
%token TK_OC_OR		275

%token TK_LIT_INT	280
%token TK_LIT_FLOAT	281
%token TK_LIT_FALSE	282
%token TK_LIT_TRUE	283
%token TK_LIT_CHAR	284	
%token TK_LIT_STRING	285
%token TK_IDENTIFICADOR 286

%token TOKEN_ERRO	290

%start program

%%

/*
GRAMMAR RULES
http://www.gnu.org/software/bison/manual/bison.html#Rules
*/

/* 2 */
program:
	  program global.decl ';'
	| program func
	| /* empty */
	;

/* 2.1 */
global.decl:
	  decl
	| array.decl
	;

array.decl:
	  decl '[' TK_LIT_INT ']'  //{ $1 $2[$3]; }
	;

decl:
      type ':' TK_IDENTIFICADOR //{ $1 $2; }
    ;

/*
type.and.id:
	  type ':' TK_IDENTIFICADOR
	;
*/

type:
	  TK_PR_INT
	| TK_PR_FLOAT
	| TK_PR_BOOL
	| TK_PR_CHAR
	| TK_PR_STRING
	;

/* 2.2 */
func:
	  type ':' TK_IDENTIFICADOR '(' func.param.list ')' decl.list command.block
	;

func.param.list:
	  param.list
	| /* empty */
	;

param.list:
	  type ':' TK_IDENTIFICADOR ',' param.list
	| type ':' TK_IDENTIFICADOR
	;

decl.list: //pode ser vazia?
	  decl ';' decl.list
	| decl ';'
	;

/* 2.3 */
command.block:
	  '{' command.seq '}'
	;

command.seq:
	  command ';' command.seq
	| command
	| /* empty */
	;

/* 2.4 */
command:
	  command.block
        | ctrl.flow
	| TK_IDENTIFICADOR '=' expr
        | TK_IDENTIFICADOR '[' expr ']' '=' expr
	| TK_PR_OUTPUT output
        | TK_PR_INPUT TK_IDENTIFICADOR
        | TK_PR_RETURN expression 
	;

output: 
	expression
	| expr ',' output
	;

/*2.5*/
expression:
	TK_IDENTIFICADOR
	| TK_IDENTIFICADOR '[' expression ']'
	| TK_IDENTIFICADOR '[' parameter.function ']'
	| '(' expression ')'
	| expression '+' expression
	| expression '-' expression
	| expression '*' expression
	| expression '/' expression
	| expression '<' expression
	| expression '>' expression
	| '!' expression
	| expression TK_OC_LE expression
	| expression TK_OC_GE expression
	| expression TK_OC_EQ expression
	| expression TK_OC_NE expression
	| expression TK_OC_AND expression
	| expression TK_OC_OR expression
	| '*' TK_IDENTIFICADOR
	| '&' TK_IDENTIFICADOR
	| terminal.value
	;
	
parameter.function:
	TK_IDENTIFICADOR
	| TK_IDENTIFICADOR ',' paremeter.function
	| terminal.value
	| terminal.value ',' parameter.function
	;

/* 2.6 */
ctrl.flow:
        | TK_PR_IF '(' expression ')' TK_PR_THEN command
	| TK_PR_IF '(' expression ')' TK PR_THEN command TK_PR_ELSE command
        | TK_PR_DO command TK_PR_WHILE '(' expression ')' 
	;

terminal.value:
	TK_LIT_INT
	| TK_LIT_FLOAT
	| TK_LIT_FALSE
	| TK_LIT_TRUE
	| TK_LIT_CHAR
	| TK_LIT_STRING
	;

int yyerror(char* str)
{
	fflush(stderr);
	fprintf(stderr, "ERRO: \"%s\"\t Linha: %d\n", str, getLineNumber());
	exit(3);
}	