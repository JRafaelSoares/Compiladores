%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "node.h"
#include "tabid.h"
extern int yylex();
int yyerror(char *s);
/*
integer - 1
string - 2
number - 3
void - 4
constl - 8
pointer - 16
funct - 32
public - 64
constr - 128
*/
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
%token FILES NIL DECLS DECL TYPE IDp VECT 
%token INDIRECAO SIM MUL DIV RES ADD MIN LESSER GREATER EQ RES AND OR FUNC FACT 
%token INIT PARAMS PARAM BODY INSTRUCAO INSTR ARGS ENDDECLS ENDINIT START INSTRUCAO BREAK CONTINUE ALLOCATE INSTRUCAOS NULLARGS NOSTEP
%token FOR IN STEP
%type <n> decls decl tipo ids init values lvalue expressao parametros parametro param corpo instrucaos instrucao int arguments int step

%%
file		: decls 							{printNode(uniNode(FILES, $1),0,yynames);}
	
decls 		: decls decl 						{$$ = binNode(DECLS, $1, $2);}
			| 			 						{$$ = nilNode(ENDDECLS);}

decl 		: PUBLIC CONST tipo ids init ';' 	{$$ = binNode(DECL, binNode(TYPE, $3, $4), $5); IDnew($3->value.i + 64 + 8 + ($4->attrib == IDp ? 16 : 0), $4->value.s, 0);}
			| PUBLIC tipo ids init ';' 			{$$ = binNode(DECL, binNode(TYPE, $2, $3), $4); IDnew($2->value.i + 64 + ($3->attrib == IDp ? 16 : 0), $3->value.s, 0);}
			| CONST tipo ids init ';' 			{$$ = binNode(DECL, binNode(TYPE, $2, $3), $4); IDnew($2->value.i + 8 + ($3->attrib == IDp ? 16 : 0), $3->value.s, 0);}
			| tipo ids init ';' 				{$$ = binNode(DECL, binNode(TYPE, $1, $2), $3); IDnew($1->value.i + ($2->attrib == IDp ? 16 : 0), $2->value.s, 0);}

ids			: ID 								{$$ = strNode(ID, $1);}
			| '*' ID 							{$$ = strNode(IDp, $2);}

tipo		: INTEGER 							{$$ = intNode(INTEGER, 0);}
			| STRING 							{$$ = intNode(STRING, 1);}
			| NUMBER 							{$$ = intNode(NUMBER, 2);}
			| VOID 								{$$ = intNode(VOID, 3);}

init 		: ASSIGN values 					{$$ = $2;}
			| '(' parametros ')' '{' corpo '}' 	{$$ = binNode(INIT, $2, $5);}
			| '(' parametros ')'				{$$ = uniNode(INIT, $2);}
			| 									{$$ = nilNode(ENDINIT);}		

values 		: INT 								{$$ = intNode(INT, $1);}
			| CONST STR 						{$$ = strNode(STR, $2);}
			| STR 								{$$ = strNode(STR, $1);}
			| NUM 								{$$ = realNode(NUM, $1);}
			| lvalue 							{$$ = $1;}

lvalue		: ids 								{$$ = $1;}
			| ID '[' expressao ']'				{$$ = binNode(VECT, strNode(ID, $1), $3);}

expressao 	: '(' expressao ')'  				{$$ = $2;}
			| ID '(' arguments ')' 				{$$ = binNode(FUNC, strNode(ID, $1), $3);}
			| '&' lvalue  						{$$ = uniNode(INDIRECAO, $2);}
			| '!' expressao						{$$ = uniNode(FACT, $2);}
			| '-' expressao 					{$$ = uniNode(SIM, $2);}
			| INC expressao 					{$$ = uniNode(INC, $2);}
			| DEC expressao 					{$$ = uniNode(DEC, $2);}
			| expressao INC 					{$$ = uniNode(INC, $1);}
			| expressao DEC 					{$$ = uniNode(DEC, $1);}
			| expressao '*' expressao 			{$$ = binNode(MUL, $1, $3);}
			| expressao '/' expressao  			{$$ = binNode(DIV, $1, $3);}
			| expressao '%' expressao 			{$$ = binNode(RES, $1, $3);}
			| expressao '+' expressao  			{$$ = binNode(ADD, $1, $3);}
			| expressao '-' expressao 			{$$ = binNode(MIN, $1, $3);}
			| expressao '<' expressao 			{$$ = binNode(LESSER, $1, $3);}
			| expressao '>' expressao 			{$$ = binNode(GREATER, $1, $3);}
			| expressao GE expressao 			{$$ = binNode(GE, $1, $3);}
			| expressao LE expressao 			{$$ = binNode(LE, $1, $3);}
			| expressao '=' expressao 			{$$ = binNode(EQ, $1, $3);}
			| expressao DIF expressao 			{$$ = binNode(DIF, $1, $3);}
			| '~' expressao 					{$$ = uniNode(RES, $2);}
			| expressao '&' expressao 			{$$ = binNode(AND, $1, $3);}
			| expressao '|' expressao 			{$$ = binNode(OR, $1, $3);}
			| lvalue ASSIGN expressao 			{$$ = binNode(ASSIGN, $1, $3);}
			| values 							{$$ = $1;}

parametros 	: parametros parametro  			{$$ = binNode(PARAMS, $1, $2);}
		   	| 									{$$ = nilNode(NIL);}

parametro 	: parametro ',' tipo ids 			{$$ = binNode(PARAM, $1, binNode(TYPE, $3, $4));}
			| tipo ids 							{$$ = binNode(TYPE, $1, $2);}

corpo 		: param instrucaos 					{$$ = binNode(BODY, $1, $2);}
			| param 							{$$ = uniNode(BODY, $1);}
			| instrucaos 						{$$ = uniNode(BODY, $1);}
			| 									{$$ = nilNode(NIL);}

param 		: param parametro ';' 				{$$ = binNode(PARAM, $1, $2);}			
			| parametro ';' 					{$$ = uniNode(PARAM, $1);}

instrucaos 	: instrucaos instrucao 				{$$ = binNode(INSTRUCAOS, $1, $2);}
			| instrucao 						{$$ = uniNode(INSTRUCAO, $1);}

instrucao	: IF expressao THEN instrucao %prec IF 				{$$ = binNode(IF, $2, $4);}
			| IF expressao THEN instrucao ELSE instrucao 		{$$ = binNode(ELSE, binNode(IF, $2, $4), $6);}
			| DO instrucao WHILE expressao ';' 					{$$ = binNode(WHILE, binNode(DO, nilNode(START), $2), $4);}
			| DO WHILE expressao ';' 							{$$ = binNode(WHILE, uniNode(DO, nilNode(START)), $3);}
			| FOR lvalue IN expressao UPTO expressao step DO instrucao 	{$$ = binNode(FOR, binNode(IN, $2,binNode(UPTO,binNode(STEP,$4,$7),$6)), uniNode(DO, $9));}
			| FOR lvalue IN expressao DOWNTO expressao step DO instrucao 	{$$ = binNode(FOR, binNode(IN, $2,binNode(DOWNTO,binNode(STEP,$4,$7),$6)), uniNode(DO, $9));}
			| expressao ';' 									{$$ = $1;}
			| BREAK int ';' 									{$$ = uniNode(BREAK, $2);}
			| CONTINUE int ';' 									{$$ = uniNode(CONTINUE, $2);}
			| lvalue '#' expressao ';' 							{$$ = binNode(ALLOCATE, $1, $3);}
			| '{' corpo '}' 									{$$ = $2;}

int 		: INT 												{$$ = intNode(INT, $1);}
			| 													{$$ = nilNode(NIL);}

step 		: STEP INT 											{$$ = intNode(INT, $2);}
			| STEP lvalue 										{$$ = $2;}
			| 													{$$ = nilNode(NOSTEP);}

arguments	: arguments ',' values 								{$$ = binNode(ARGS, $1, $3);}
			| expressao 										{$$ = $1;}
			| 													{$$ = nilNode(NULLARGS);}


	;
%%
char **yynames =
#if YYDEBUG > 0
		 (char**)yyname;
#else
		 0;
#endif