%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
//#include "node.h"
#include "tabid.h"
extern int yylex();
int yyerror(char *s);
%}

%union {
	int i;			/* integer value */
	char* s;
	double d;
};

%token <i> INT
%token <s> STR ID
%token <d> NUM
%token VOID INTEGER STRING NUMBER
%token FOR VOID PUBLIC CONST IF THEN ELSE WHILE DO FOR 
%token IN STEP UPTO DOWNTO BREAK CONTINUE
%token GE LE DIF ASSIGN INC DEC


%%
file	: decls
	
decls 	:  decls decl
		|

decl 	: public const tipo pointer ID init ';'

public 	: PUBLIC
		| 

const 	: CONST
		|

tipo	: INTEGER
		| STRING
		| NUMBER
		| VOID

pointer : '*'
		| 

init 	: ASSIGN values
		| '(' parametros ')'

values	: INT
		| const STR
		| NUM
		| ID

parametros 	: parametros parametro
		   	| 

parametro 	: parametro ',' tipo pointer ID  
			| tipo pointer ID 
	;
%%

char **yynames =
#if YYDEBUG > 0
		 (char**)yyname;
#else
		 0;
#endif

