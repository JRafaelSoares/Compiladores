%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "node.h"
#include "tabid.h"
extern int yylex();
int checkString(Node* expr);
int checkReal(Node* expr);
int checkInt(Node* expr);
int checkIntReal(Node* first, Node* second);
void checkDecl(Node* type, Node* init);
void checkArgs(Node* type, Node* init);
int yyerror(char *s);

#define tINTEGER 1
#define tSTRING 2
#define tNUMBER 3
#define tVOID 4
#define tCONSTL 8
#define tPOINTER 16
#define tFUNCT 32
#define tCONSTR 64

/*
integer - 1
string - 2
number - 3
void - 4
constl - 8
pointer - 16
funct - 32
constr - 64
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
%token FOR IN STEP INFO LOCALIZACAO ERROR
%type <n> decls decl functype tipo ids init values lvalue expressao parametros parametro param corpo instrucaos instrucao int arguments int step

%%
file		: decls 							{printNode(uniNode(FILES, $1),0,yynames);}
	
decls 		: decls decl 						{$$ = binNode(DECLS, $1, $2);}
			| 			 						{$$ = nilNode(ENDDECLS);}

decl 		: PUBLIC CONST functype ids init ';' 	{$$ = binNode(DECL, nilNode(PUBLIC), binNode(INFO, binNode(TYPE, $3, $4), $5)); IDnew($3->value.i + 8 + ($4->attrib == IDp ? 16 : 0), $4->value.s, 0); checkDecl($3, $5);}
			| PUBLIC functype ids init ';' 			{$$ = binNode(DECL, nilNode(PUBLIC), binNode(INFO, binNode(TYPE, $2, $3), $4)); IDnew($2->value.i + ($3->attrib == IDp ? 16 : 0), $3->value.s, 0); checkArgs($2, $4);}
			| CONST functype ids init ';' 			{$$ = binNode(DECL, binNode(TYPE, $2, $3), $4); IDnew($2->value.i + 8 + ($3->attrib == IDp ? 16 : 0), $3->value.s, 0); checkDecl($2, $4);}
			| functype ids init ';' 				{$$ = binNode(DECL, binNode(TYPE, $1, $2), $3); IDnew($1->value.i + ($2->attrib == IDp ? 16 : 0), $2->value.s, 0); checkArgs($1, $3);}
			| error ';' 							{$$ = strNode(ERROR, "error");}
			| error '}' 							{$$ = strNode(ERROR, "error");}

init 		: ASSIGN INT 						{$$ = intNode(INT, $2); $$->info = tINTEGER;}
			| ASSIGN CONST STR 					{$$ = strNode(STR, $3); $$->info = tSTRING;}
			| ASSIGN STR 						{$$ = strNode(STR, $2); $$->info = tSTRING;}
			| ASSIGN NUM 						{$$ = realNode(STR, $2); $$->info = tNUMBER;}
			| ASSIGN ID 						{$$ = strNode(ID, $2); $$->info = IDfind($2, 0);}
			| '(' parametros ')' '{' corpo '}' 	{$$ = binNode(INIT, $2, $5);}
			| '(' parametros ')'				{$$ = uniNode(INIT, $2);}
			| 									{$$ = nilNode(ENDINIT);}

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

tipo		: INTEGER 							{$$ = intNode(INTEGER, 1);}
			| STRING 							{$$ = intNode(STRING, 2);}
			| NUMBER 							{$$ = intNode(NUMBER, 3);}	

ids			: ID 								{$$ = strNode(ID, $1);}
			| '*' ID 							{$$ = strNode(IDp, $2);}

functype	: tipo 								{$$ = $1;}
			| VOID 								{$$ = intNode(VOID, 4);}

lvalue		: ID 								{$$ = strNode(ID,$1); $$->info = IDfind($1, 0);}
			| ID '[' expressao ']'				{$$ = binNode(VECT, strNode(ID, $1), $3); $$->info = IDfind($1, 0);}

expressao 	: '(' expressao ')'  				{$$ = $2;}
			| ID '(' arguments ')' 				{$$ = binNode(FUNC, strNode(ID, $1), $3);}
			| ID '(' ')'						{$$ = uniNode(FUNC, strNode(ID, $1));}
			
			| '&' lvalue  						{$$ = uniNode(LOCALIZACAO, $2);}
			| '*' expressao 					{$$ = uniNode(INDIRECAO, $2);}
			| '!' expressao						{$$ = uniNode(FACT, $2); 		if($2->info != INT){yyerror("Invalid type for factorial");}}
			| '-' expressao 					{$$ = uniNode(SIM, $2); 		if($2->info != INT && $$->info != NUM){yyerror("Invalid type for simetric");}}
			| INC expressao 					{$$ = uniNode(INC, $2); 		if($2->info != INT){yyerror("Invalid type for INC");}}
			| DEC expressao 					{$$ = uniNode(DEC, $2); 		if($2->info != INT){yyerror("Invalid type for DEC");}}
			| expressao INC 					{$$ = uniNode(INC, $1);		 	if($1->info != INT){yyerror("Invalid type for INC");}}
			| expressao DEC 					{$$ = uniNode(DEC, $1); 		if($1->info != INT){yyerror("Invalid type for DEC");}}
			
			| expressao '*' expressao 			{$$ = binNode(MUL, $1, $3); 	if(!checkIntReal($1, $3)){yyerror("Invalid types for multiplication");}}
			| expressao '/' expressao  			{$$ = binNode(DIV, $1, $3); 	if(!checkIntReal($1, $3)){yyerror("Invalid types for divisions");}}
			| expressao '%' expressao 			{$$ = binNode(RES, $1, $3); 	if(!checkIntReal($1, $3)){yyerror("Invalid types for rest");}}
			| expressao '+' expressao  			{$$ = binNode(ADD, $1, $3); 	if(!checkIntReal($1, $3)){yyerror("Invalid types for addition");}}
			| expressao '-' expressao 			{$$ = binNode(MIN, $1, $3); 	if(!checkIntReal($1, $3)){yyerror("Invalid types for subtraction");}}
			| expressao '<' expressao 			{$$ = binNode(LESSER, $1, $3); 	if(!(checkIntReal($1, $3) || (checkString($1) && checkString($3)))) {yyerror("Invalid types for lesser");}}
			| expressao '>' expressao 			{$$ = binNode(GREATER, $1, $3); if(!(checkIntReal($1, $3) || (checkString($1) && checkString($3)))) {yyerror("Invalid types for greater");}}
			| expressao GE expressao 			{$$ = binNode(GE, $1, $3); 		if(!(checkIntReal($1, $3) || (checkString($1) && checkString($3)))){yyerror("Invalid types for greater equal");}}
			| expressao LE expressao 			{$$ = binNode(LE, $1, $3); 		if(!(checkIntReal($1, $3) || (checkString($1) && checkString($3)))){yyerror("Invalid types for lesser equal");}}
			| expressao '=' expressao 			{$$ = binNode(EQ, $1, $3); 		if(!(checkIntReal($1, $3) || (checkString($1) && checkString($3)))){yyerror("Invalid types for equal");}}
			| expressao DIF expressao 			{$$ = binNode(DIF, $1, $3); 	if(!(checkIntReal($1, $3) || (checkString($1) && checkString($3)))){yyerror("Invalid types for different");}}
			| '~' expressao 					{$$ = uniNode(RES, $2); 		if(!(checkInt($2))){yyerror("Invalid type for negation");}}
			| expressao '&' expressao 			{$$ = binNode(AND, $1, $3);		if(!(checkInt($1)&&checkInt($3))){yyerror("Invalid type for logical and");}}
			| expressao '|' expressao 			{$$ = binNode(OR, $1, $3); 		if(!(checkInt($1)&&checkInt($3))){yyerror("Invalid type for logical or");}}
			| lvalue ASSIGN expressao 			{$$ = binNode(ASSIGN, $1, $3); 	if($1->info != $3->info){yyerror("Invalid type for assign");}}
			
			| values 							{$$ = $1;}

values 		: INT 								{$$ = intNode(INT, $1); $$->info = tINTEGER;}
			| CONST STR 						{$$ = strNode(STR, $2); $$->info = tSTRING;}
			| STR 								{$$ = strNode(STR, $1); $$->info = tSTRING;}
			| NUM 								{$$ = realNode(NUM, $1); $$->info = tNUMBER;}
			| lvalue 							{$$ = $1;}

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
			| error ';' 										{$$ = strNode(ERROR, "error");}
			| error '}'  										{$$ = strNode(ERROR, "error");}

int 		: INT 												{$$ = intNode(INT, $1);}
			| 													{$$ = intNode(INT, 1);}

step 		: STEP INT 											{$$ = intNode(INT, $2);}
			| STEP lvalue 										{$$ = $2;}
			| 													{$$ = nilNode(NOSTEP);}

arguments	: arguments ',' expressao 							{$$ = binNode(ARGS, $1, $3);}
			| expressao 										{$$ = $1;}


	;
%%
int checkIntReal(Node* first, Node* second){
	return (checkInt(first)||checkReal(first)) && (checkInt(second)||checkReal(second));

}
int checkInt(Node* expr){
	if(expr->info != INT){
		return 0;
	}
	return 1;
}

int checkReal(Node* expr){
	if(expr->info != NUM){
		return 0;
	}
	return 1;
}

int checkString(Node* expr){
	if(expr->info != STR){
		return 0;
	}
	return 1;
}

void checkDecl(Node* type, Node* init){
	//Checks arguments type and if its a declaration of a variable or a function
	(init->attrib == INIT ? yyerror("Function declarations cannot be constant") : 1);
	checkArgs(type, init);
}

void checkArgs(Node* type, Node* init){

	if(init->attrib != INIT && init->attrib != ENDINIT){
		if((type->attrib == INTEGER && init->info == tINTEGER) || (type->attrib == STRING && init->info == tSTRING) || (type->attrib == NUMBER && init->info == tNUMBER)){
			return;
		}
		yyerror("Types do no match");
	}
}

char **yynames =
#if YYDEBUG > 0
		 (char**)yyname;
#else
		 0;
#endif