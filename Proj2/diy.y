%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "node.h"
#include "tabid.h"
extern int yylex();

int checkRightConst(Node* expr);
int checkLogics(Node* expr1, Node* expr2, char* errorMessage);
int checkZero(Node* expr);
int checkAddress(int type);
int checkMakePointer(Node* expr);
int checkIncrements(Node* expr, char* errorMessage);
int checkSimetric(Node* expr, char* errorMessage);
int checkCalculus(Node* expr1, Node* expr2, char* errorMessage);
int checkFactorial(Node* expr, char* errorMessage);
int checkComparisons(Node* expr1, Node* expr2, char* errorMessage);
int checkPointer(Node* expr);
int checkConst(Node* expr);
int checkVector(int type);
int checkAssign(Node* leftValue, Node* expr);
void setFunctionParameters(Node* params);
struct Args* getParameters(Node* params);
void existsID(Node* type, char* name);
void checkID(Node *type, int idType);
void checkStringDecl(Node *type);
void checkIntDecl(Node* type, int value);
void checkNumDecl(Node* type, int value);
void declareFunction(Node* typeFunc, char* name, Node* params);
int checkString(Node* expr);
int checkReal(Node* expr);
int checkInt(Node* expr);
int checkIntReal(Node* first, Node* second);
void checkDecl(Node* type, Node* init);
void checkArgs(Node* type, Node* init);
int yyerror(char *s);

struct Args { int type; char* name; struct Args *next; };

void printStruct(struct Args* asd);

#define tINTEGER 1
#define tSTRING 2
#define tNUMBER 3
#define tVOID 4
#define tCONSTL 8
#define tPOINTER 16
#define tFUNCT 32
#define tCONSTR 64
#define tZero 128

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
int level = 0;

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
%token FOR IN STEP INFO LOCALIZACAO ERROR VAR
%type <n> decls decl tipo init values lvalue expressao parametro param corpo instrucaos instrucao int arguments step assign

%%
file		: decls 							{printNode(uniNode(FILES, $1),0,yynames);}
	
decls 		: decls decl 						{$$ = binNode(DECLS, $1, $2);}
			| 			 						{$$ = nilNode(ENDDECLS);}

decl 		: PUBLIC assign ';' 	{$$ = binNode(DECL, nilNode(PUBLIC), $2);}
			| PUBLIC init ';' 		{$$ = binNode(DECL, nilNode(PUBLIC), $2);}
			| assign ';' 			{$$ = uniNode(DECL, $1);}
			| init ';'  			{$$ = uniNode(DECL, $1);}
			| error ';' 			{$$ = strNode(ERROR, "error");}
			| error '}' 			{$$ = strNode(ERROR, "error");}

assign 		: CONST tipo ID ASSIGN INT 			{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), intNode(INT, $5)); IDnew(($5 == 0 ? tZero : $2->value.i + tCONSTL), $3, 0); checkIntDecl($2, $5);}
			| CONST tipo ID ASSIGN '-' INT 		{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), intNode(INT, -$6)); IDnew(($6 == 0 ? tZero : $2->value.i + tCONSTL), $3, 0); checkIntDecl($2, $6);			}
			| CONST tipo ID ASSIGN CONST STR 	{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), strNode(STR, $6)); IDnew($2->value.i + tCONSTL + tCONSTR, $3, 0); checkStringDecl($2);}
			| CONST tipo ID ASSIGN STR 			{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), strNode(STR, $5)); IDnew($2->value.i + tCONSTL, $3, 0); checkStringDecl($2);}
			| CONST tipo ID ASSIGN NUM 			{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), realNode(NUM, $5)); IDnew($2->value.i + tCONSTL, $3, 0); checkNumDecl($2, $5);}
			| CONST tipo ID ASSIGN '-' NUM 		{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), realNode(NUM, -$6)); IDnew($2->value.i + tCONSTL, $3, 0); checkNumDecl($2, $6);}
			| CONST tipo ID ASSIGN ID 			{$$ = binNode(ASSIGN, binNode(TYPE, $2, strNode(ID, $3)), strNode(ID,$5)); 		IDnew($2->value.i + tCONSTL, $3, 0); checkID($2, IDfind($5,0));}
			| CONST tipo ID						{$$ = uniNode(VAR, binNode(TYPE, $2, strNode(ID, $3))); IDnew($2->value.i + tCONSTL, $3, 0);}
			
			| tipo ID ASSIGN INT 				{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), intNode(INT, $4));  IDnew(($4 == 0 ? tZero : $1->value.i), $2, 0); checkIntDecl($1, $4);}
			| tipo ID ASSIGN '-' INT 			{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), intNode(INT, -$5)); IDnew(($5 == 0 ? tZero : $1->value.i), $2, 0); checkIntDecl($1, $5);}
			| tipo ID ASSIGN CONST STR 			{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), strNode(STR, $5)); IDnew($1->value.i + tCONSTR, $2, 0); checkStringDecl($1);}
			| tipo ID ASSIGN STR 				{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), strNode(STR, $4)); IDnew($1->value.i, $2, 0); checkStringDecl($1);}
			| tipo ID ASSIGN NUM 				{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), realNode(NUM, $4)); IDnew($1->value.i, $2, 0); checkNumDecl($1, $4);}
			| tipo ID ASSIGN '-' NUM 			{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), realNode(NUM, -$5)); IDnew($1->value.i, $2, 0); checkNumDecl($1, $5);}
			| tipo ID ASSIGN ID 				{$$ = binNode(ASSIGN, binNode(TYPE, $1, strNode(ID, $2)), strNode(ID,$4)); 		IDnew($1->value.i, $2, 0); checkID($1, IDfind($4,0));}
			| tipo ID							{$$ = uniNode(VAR, binNode(TYPE, $1, strNode(ID, $2))); IDnew($1->value.i, $2, 0);}

init 		: tipo ID '(' parametro ')' '{' {declareFunction($1, $2, $4);} corpo '}' 	{$$ = binNode(FUNC, binNode(TYPE, $1, strNode(ID, $2)), binNode(INIT, $4, $8)); IDpop();}
			| tipo ID '(' parametro ')' 				{$$ = binNode(FUNC, binNode(TYPE, $1, strNode(ID, $2)), uniNode(INIT, $4)); declareFunction($1, $2, $4); IDpop();}
			| VOID ID '(' parametro ')' '{' {declareFunction(intNode(VOID, tVOID), $2, $4);} corpo '}' 	{$$ = binNode(FUNC, binNode(TYPE, intNode(VOID, tVOID), strNode(ID, $2)), binNode(INIT, $4, $8)); IDpop();}
			| VOID ID '(' parametro ')'				{$$ = binNode(FUNC, binNode(TYPE, intNode(VOID, tVOID), strNode(ID, $2)), uniNode(INIT, $4)); declareFunction(intNode(VOID, tVOID), $2, $4); IDpop();}
			
			| tipo ID '(' ')' '{' {declareFunction($1, $2, 0);} corpo '}' 	{$$ = uniNode(FUNC, binNode(TYPE, $1, strNode(ID, $2))); IDpop();}
			| tipo ID '(' ')'					{$$ = uniNode(FUNC, binNode(TYPE, $1, strNode(ID, $2))); declareFunction($1, $2, 0); IDpop();}
			| VOID ID '(' ')' '{' {declareFunction(intNode(VOID, tVOID), $2, 0);} corpo '}' 	{$$ = uniNode(FUNC, binNode(TYPE, intNode(VOID, tVOID), strNode(ID, $2))); IDpop();}
			| VOID ID '(' ')'					{$$ = uniNode(FUNC, binNode(TYPE, intNode(VOID, tVOID), strNode(ID, $2))); declareFunction(intNode(VOID, tVOID), $2, 0); IDpop();}

parametro 	: parametro ',' tipo ID 			{$$ = binNode(PARAM, binNode(TYPE, $3, strNode(ID, $4)), $1);}
			| tipo ID 							{$$ = binNode(TYPE, $1, strNode(ID, $2));}

corpo 		: param instrucaos 					{$$ = binNode(BODY, $1, $2);}
			| param 							{$$ = uniNode(BODY, $1);}
			| instrucaos 						{$$ = uniNode(BODY, $1);}
			| 									{$$ = nilNode(NIL);}

param 		: param tipo ID ';' 				{$$ = binNode(PARAM, binNode(TYPE, $2, strNode(ID, $3)), $1); existsID($2, $3);}			
			| tipo ID ';' 						{$$ = binNode(TYPE, $1, strNode(ID, $2)); existsID($1, $2);}

tipo		: INTEGER 							{$$ = intNode(INTEGER, tINTEGER);}
			| STRING 							{$$ = intNode(STRING, tSTRING);}
			| NUMBER 							{$$ = intNode(NUMBER, tNUMBER);}
			| INTEGER '*' 						{$$ = intNode(INTEGER, tINTEGER + tPOINTER);}
			| STRING '*' 						{$$ = intNode(STRING, tSTRING + tPOINTER);}
			| NUMBER '*'						{$$ = intNode(NUMBER, tNUMBER + tPOINTER);}

lvalue		: ID 								{$$ = strNode(ID,$1); $$->info = IDfind($1, 0);}
			| ID '[' expressao ']'				{$$ = binNode(VECT, strNode(ID, $1), $3); $$->info = checkVector(IDfind($1, 0));}

expressao 	: '(' expressao ')'  				{$$ = $2;}
			| ID '(' arguments ')' 				{$$ = binNode(FUNC, strNode(ID, $1), $3); $$->info = IDfind($1,0)%tFUNCT;}
			| ID '(' ')'						{$$ = uniNode(FUNC, strNode(ID, $1)); $$->info = IDfind($1,0)%tFUNCT;}
			
			| '&' lvalue  						{$$ = uniNode(LOCALIZACAO, $2); $$->info = checkAddress($2->info);}
			| '*' expressao 					{$$ = uniNode(INDIRECAO, $2); $$->info = checkMakePointer($2);}
			
			| '!' expressao						{$$ = uniNode(FACT, $2); 		$$->info = checkFactorial($2, "factorial");}
			| '-' expressao 					{$$ = uniNode(SIM, $2); 		$$->info = checkSimetric($2, "simetric");} 
			
			| INC expressao 					{$$ = uniNode(INC, $2); 		$$->info = checkIncrements($2, "increment");}
			| DEC expressao 					{$$ = uniNode(DEC, $2); 		$$->info = checkIncrements($2, "decrement");}
			| expressao INC 					{$$ = uniNode(INC, $1);		 	$$->info = checkIncrements($1, "increment");}
			| expressao DEC 					{$$ = uniNode(DEC, $1); 		$$->info = checkIncrements($1, "decrement");}
			
			| expressao '*' expressao 			{$$ = binNode(MUL, $1, $3); 	$$->info = checkCalculus($1, $3, "multiplication");} 
			| expressao '/' expressao  			{$$ = binNode(DIV, $1, $3); 	$$->info = checkCalculus($1, $3, "division");}
			| expressao '%' expressao 			{$$ = binNode(RES, $1, $3); 	$$->info = checkCalculus($1, $3, "rest");}
			| expressao '+' expressao  			{$$ = binNode(ADD, $1, $3); 	$$->info = checkCalculus($1, $3, "addition");}
			| expressao '-' expressao 			{$$ = binNode(MIN, $1, $3); 	$$->info = checkCalculus($1, $3, "subtraction");}
			
			| expressao '<' expressao 			{$$ = binNode(LESSER, $1, $3); 	$$->info = checkComparisons($1, $3, "lesser");}
			| expressao '>' expressao 			{$$ = binNode(GREATER, $1, $3); $$->info = checkComparisons($1, $3, "greater");}
			| expressao GE expressao 			{$$ = binNode(GE, $1, $3); 		$$->info = checkComparisons($1, $3, "greater or equal");}
			| expressao LE expressao 			{$$ = binNode(LE, $1, $3); 		$$->info = checkComparisons($1, $3, "lesser or equal");}
			| expressao '=' expressao 			{$$ = binNode(EQ, $1, $3); 		$$->info = checkComparisons($1, $3, "equality");}
			| expressao DIF expressao 			{$$ = binNode(DIF, $1, $3); 	$$->info = checkComparisons($1, $3, "different");}
			
			| '~' expressao 					{$$ = uniNode(RES, $2); 		$$->info = checkIncrements($2, "negation");}
			
			| expressao '&' expressao 			{$$ = binNode(AND, $1, $3);		$$->info = checkLogics($1, $3, "AND");}
			| expressao '|' expressao 			{$$ = binNode(OR, $1, $3); 		$$->info = checkLogics($1, $3, "OR");}
			
			| lvalue ASSIGN expressao 			{$$ = binNode(ASSIGN, $1, $3); 	$$->info = checkAssign($1, $3);}
			
			| values 							{$$ = $1;}

values 		: INT 								{$$ = intNode(INT, $1); if($1 == 0){$$->info = tZero;} else{$$->info = tINTEGER;};}
			| CONST STR 						{$$ = strNode(STR, $2); $$->info = tSTRING + tCONSTR;}
			| STR 								{$$ = strNode(STR, $1); $$->info = tSTRING;}
			| NUM 								{$$ = realNode(NUM, $1); $$->info = tNUMBER;}
			| lvalue 							{$$ = $1;}

instrucaos 	: instrucaos instrucao 				{$$ = binNode(INSTRUCAOS, $1, $2);}
			| instrucao 						{$$ = uniNode(INSTRUCAO, $1);}

instrucao	: IF expressao addlvel THEN  instrucao %prec IF 				{$$ = binNode(IF, $2, $5); if($2->info != tINTEGER){yyerror("Invalid type for IF expression");}; level--;}
			| IF expressao addlvel THEN  instrucao ELSE instrucao 			{$$ = binNode(ELSE, binNode(IF, $2, $5), $7); if($2->info != tINTEGER){yyerror("Invalid type for IF expression");}; level--;}
			| DO addlvel instrucao WHILE expressao ';' 						{$$ = binNode(WHILE, binNode(DO, nilNode(START), $3), $5); if($5->info != tINTEGER){yyerror("Invalid type for DO WHILE expression");}; level--;}
			| FOR lvalue IN expressao UPTO expressao step addlvel DO instrucao 	{$$ = binNode(FOR, binNode(IN, $2,binNode(UPTO,binNode(STEP,$4,$7),$6)), uniNode(DO, $10)); level--;}
			| FOR lvalue IN expressao DOWNTO expressao step addlvel DO instrucao 	{$$ = binNode(FOR, binNode(IN, $2,binNode(DOWNTO,binNode(STEP,$4,$7),$6)), uniNode(DO, $10)); level--;}
			| expressao ';' 									{$$ = $1;}
			| BREAK int ';' 									{$$ = uniNode(BREAK, $2); if(level<$2->value.i){yyerror("Integer of break too big for number of cycles");}}
			| CONTINUE int ';' 									{$$ = uniNode(CONTINUE, $2); if(level<$2->value.i){yyerror("Integer of continue too big for number of cycles");}}
			| lvalue '#' expressao ';' 							{$$ = binNode(ALLOCATE, $1, $3);}
			| '{' {IDpush();} corpo '}' 						{$$ = $3; IDpop();}
			| error ';' 										{$$ = strNode(ERROR, "error");}
			| error '}'  										{$$ = strNode(ERROR, "error");}

addlvel		: {level++;}

int 		: INT 												{$$ = intNode(INT, $1);}
			| 													{$$ = intNode(INT, 1);}

step 		: STEP INT 											{$$ = intNode(INT, $2);}
			| STEP lvalue 										{$$ = $2;}
			| 													{$$ = nilNode(NOSTEP);}

arguments	: arguments ',' expressao 							{$$ = binNode(ARGS, $1, $3);}
			| expressao 										{$$ = $1;}

	;
%%

void printStruct(struct Args* asd){

	struct Args* aux = asd;

	while(aux != 0){
		printf("%d ", aux->type);
		aux = aux->next;
	}
	printf("\n");
}

struct Args* getParameters(Node* params){

	struct Args *aux = (struct Args*)malloc(sizeof(struct Args));

	if(params->attrib == TYPE){
		aux->type = LEFT_CHILD(params)->value.i;
		aux->name = RIGHT_CHILD(params)->value.s;
		aux->next = 0;
		return aux;
	}

	aux->next = getParameters(RIGHT_CHILD(params));
	
	struct Args* left = getParameters(LEFT_CHILD(params));
	
	aux->type = left->type;
	aux->name = left->name; 

	return aux; 
}


void existsID(Node* type, char* name){
	if(IDnew(type->value.i, name, 0) != 1){
		yyerror("Variable already exists");
	}
}

int checkAssign(Node* leftValue, Node* expr){

	if(checkConst(leftValue)){
		yyerror("Cannot assign to a constant left value");
		return leftValue->info;	
	}

	if(checkZero(expr)){
		return leftValue->info;
	}
	if((checkInt(leftValue)|| checkReal(leftValue)) && (checkInt(expr)|| checkReal(expr))){
		return leftValue->info;
	}

	if(checkString(leftValue) && (checkString(expr) || (checkInt(expr) && checkPointer(expr)))){
		return leftValue->info;
	}

	if( (checkInt(leftValue) && checkPointer(leftValue))  && (checkString(expr) || (checkInt(expr) && checkPointer(expr))) ){
		if(!checkRightConst(leftValue) && checkRightConst(expr)){
			IDreplace(leftValue->info, leftValue->value.s, 0);
		}
		return leftValue->info;
	}

	if( checkString(leftValue) && checkPointer(leftValue) && checkString(expr) && checkPointer(expr) ){
		if(!checkRightConst(leftValue) && checkRightConst(expr)){
			IDreplace(leftValue->info, leftValue->value.s, 0);
		}
		return leftValue->info;
	}

	if( checkReal(leftValue) && checkPointer(leftValue) && checkReal(expr) && checkPointer(expr)){
		if(!checkRightConst(leftValue) && checkRightConst(expr)){
			IDreplace(leftValue->info, leftValue->value.s, 0);
		}
		return leftValue->info;
	}

	yyerror("Assign types are not compatible");
	return leftValue->info;

}

void declareFunction(Node* typeFunc, char* name, Node* params){

	struct Args* arg = 0;

	if(params != 0){
		arg = getParameters(params);
	}

	if(IDnew(tFUNCT + typeFunc->value.i, name, (long)arg) == 1) {
		IDpush();
		IDnew(typeFunc->value.i, name, 0);
		
		if(params != 0){
			struct Args* aux = arg;

			while(aux->next != 0){
				IDnew(aux->type, aux->name, 0);
				aux = aux->next;
			}
			IDnew(aux->type, aux->name, 0);
		}
	}
}

int checkRightConst(Node* expr){
	if((expr->info / tCONSTR % 2) == 1){
		return 1;
	}
	return 0;
}
int checkLogics(Node* expr1, Node* expr2, char* errorMessage){
	if(checkInt(expr1) && checkInt(expr2) && !checkPointer(expr1) && !checkPointer(expr2)){
		return tINTEGER;
	}
	char error[50];
	sprintf(error, "Invalid type for %s", errorMessage);
	yyerror(error);
	return tINTEGER;
}

int checkAddress(int type){
	if((type / tPOINTER) % 2 == 0){
		return type + tPOINTER +tCONSTR;
	}

	yyerror("Invalid type for adressment");
	return type;
}

int checkMakePointer(Node* expr){
	if(checkPointer(expr) || checkString(expr)){
		int type = expr->info;
		if(checkConst(expr)){ type = type - tCONSTL;}
		if((expr->info / tCONSTR) % 2 == 1 && checkString(expr)) {return tINTEGER + tCONSTL;}  //if string and const direia ent passa a ser cont integer
		return (checkString(expr) ? tINTEGER : type - tPOINTER);
	}

	yyerror("Invalid type for pointer");
	return tINTEGER;
}

int checkIncrements(Node* expr, char* errorMessage){
	if(checkInt(expr) && !checkPointer(expr)){
		return tINTEGER;
	}
	char error[50];
	sprintf(error, "Invalid type for %s", errorMessage);
	yyerror(error);
	return tINTEGER;
}

int checkVector(int type){
	if((type / tPOINTER) % 2 == 0 && type % 4 != tSTRING){
		yyerror("Cannot index a non pointer type ");
		return type + tPOINTER;
	}
	int typeValue = type;
	if((type / tCONSTL) % 2 == 1){ typeValue = typeValue - tCONSTL;}
	if((type / tCONSTR) % 2 == 1 && type % 4 == 2) {return tINTEGER + tCONSTL;}
	return ((type % 4 == tSTRING && (type / tPOINTER) % 2 == 0) ? tINTEGER : typeValue - tPOINTER);
}

int checkSimetric(Node* expr, char* errorMessage){
	if(checkInt(expr) && !checkPointer(expr)){
		return tINTEGER;
	}

	if(checkReal(expr) && !checkPointer(expr)){
		return tNUMBER;
	}

	char error[50];
	sprintf(error, "Invalid type for %s", errorMessage);
	yyerror(error);
	
	return tNUMBER;

}
int checkFactorial(Node* expr, char* errorMessage){

	if(checkInt(expr) && !checkPointer(expr)){
		return tNUMBER;
	}

	char error[50];
	sprintf(error, "Invalid type for %s", errorMessage);
	yyerror(error);
	
	return tNUMBER;
}

int checkCalculus(Node* expr1, Node* expr2, char* errorMessage){

	if(checkInt(expr1) && checkInt(expr2)){
		return tINTEGER;
	}

	if((checkReal(expr1) || checkInt(expr1)) && (checkInt(expr2) || checkReal(expr2))){
		return tNUMBER;
	}

	char error[50];
	sprintf(error, "Invalid type for %s", errorMessage);
	yyerror(error);

	return tINTEGER;
}
int checkComparisons(Node* expr1, Node* expr2, char* errorMessage){

	if (checkInt(expr1) && checkInt(expr2) && !checkPointer(expr1) && !checkPointer(expr2)){
		return tINTEGER;	
	}
	//If they are of type int or number and are not pointer
	if(((checkInt(expr1)||checkReal(expr1)) && !checkPointer(expr1)) && ((checkInt(expr2)||checkReal(expr2)) && !checkPointer(expr2))){
		return tINTEGER;
	}

	//If they are both of type string and are not pointers
	if(checkString(expr1) && checkString(expr2) && !checkPointer(expr1) && !checkPointer(expr2)){
		return tINTEGER;
	}

	if(checkZero(expr1) || checkZero(expr2)){
		return tINTEGER;
	}

	char error[50];
	sprintf(error, "Invalid type for %s", errorMessage);
	yyerror(error);

	return tINTEGER;
}

int checkZero(Node* expr){
	if(expr->info / tZero == 1){
		return 1;
	}
	return 0;
}
int checkPointer(Node* expr){
	if((expr-> info / 16) % 2 == 1){
		return 1;
	}
	return 0;
}

int checkConst(Node* expr){
	if((expr->info / 8) % 2 == 1){
		return 1;
	}
	return 0;
}

int checkInt(Node* expr){
	if(expr->info % 4 == tINTEGER || checkZero(expr)){
		return 1;
	}
	return 0;
}

int checkReal(Node* expr){
	if(expr->info % 4 == tNUMBER || checkZero(expr)){
		return 1;
	}
	return 0;
}

int checkString(Node* expr){
	if(expr->info % 4 == tSTRING || checkZero(expr)){
		return 1;
	}
	return 0;
}

//Declaration checks
void checkIntDecl(Node* type, int value){
	if(!value || type->attrib == INTEGER){
		return;
	}
	yyerror("Invalid type for an integer");
}

void checkNumDecl(Node* type, int value){
	if(!value || type->attrib == NUMBER){
		return;
	}
	yyerror("Invalid type for an integer");
}

void checkStringDecl(Node *type){
	if(type->attrib == STRING || type->value.i == tINTEGER + tPOINTER){
		return;
	}
	yyerror("Invalid type for a string");
}

void checkID(Node *type, int idType){
	if(type->value.i == idType){
		return;
	}

	int id = idType % 4;

	if((type->attrib == INTEGER || type ->attrib == NUMBER) && (id == 1 || id == 3)){
		return;
	}

	if(type->value.i == tINTEGER + tPOINTER && id == 2){
		return;
	}

	yyerror("ID types do not match");
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