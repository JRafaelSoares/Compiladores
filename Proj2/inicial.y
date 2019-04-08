%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "node.h"
#include "tabid.h"
extern int yylex();
int yyerror(char *s);
%}

%union {
	int i;			/* integer value */
	char* s;
	double d;
	Node *n;
};

%nonassoc IF
%nonassoc ELSE
%right ASSIGN
%left '|'
%left '&'
%nonassoc '~'
%left '=' DIF
%left '<' '>' GE LE
%left '+' '-'
%left '*' '/' '%'
%nonassoc '!' INC DEC
%nonassoc '[' '('

%token <i> INT
%token <s> STR ID
%token <d> NUM
%token VOID INTEGER STRING NUMBER
%token FOR VOID PUBLIC CONST IF THEN ELSE WHILE DO FOR 
%token IN STEP UPTO DOWNTO BREAK CONTINUE
%token GE LE DIF ASSIGN INC DEC


%%
file		: decls
	
decls 		:  decls decl
			|

decl 		: public const tipo pointer ID init ';'

public 		: PUBLIC
			| 

const 		: CONST
			|

tipo		: INTEGER
			| STRING
			| NUMBER
			| VOID

pointer 	: '*'
			| 

init 		: ASSIGN values
			| '(' parametros ')' corpo

values		: INT
			| const STR
			| NUM
			| ID

parametros 	: parametros parametro
		   	| 

parametro 	: parametro ',' tipo pointer ID  
			| tipo pointer ID 

corpo 		: '{' param instrucao '}'
			| 

param 		: param parametro ';'
			|  

instrucao	: IF expressao THEN instrucao %prec IF
			| IF expressao THEN instrucao ELSE instrucao
			| DO instrucao WHILE expressao ';'
			| FOR lvalue IN expressao updown expressao step DO instrucao
			| expressao ';'
			| corpo
			| BREAK int ';'
			| CONTINUE int ';'
			| lvalue '#' expressao ';'

int 		: INT
			| 

updown 		: UPTO
			| DOWNTO

step 		: STEP INT
			| 

lvalue		: ID
			| ID '[' INT ']'
			| '*' ID

allvalues 	: INT
			| const STR
			| NUM
			| lvalue

arguments	: arguments ',' lvalue
			| lvalue		

expressao 	: '(' expressao ')'
			| ID '(' arguments ')'
			| '&' lvalue  
			| '!' expressao
			| '-' expressao
			| INC expressao
			| DEC expressao
			| expressao '*' expressao
			| expressao '/' expressao
			| expressao '%' expressao
			| expressao '+' expressao
			| expressao '-' expressao
			| expressao '<' expressao
			| expressao '>' expressao
			| expressao GE expressao
			| expressao LE expressao
			| expressao '=' expressao
			| expressao DIF expressao
			| '~' expressao
			| expressao '&' expressao
			| expressao '|' expressao
			| lvalue ASSIGN expressao
			| allvalues
	;
%%

char **yynames =
#if YYDEBUG > 0
		 (char**)yyname;
#else
		 0;
#endif

