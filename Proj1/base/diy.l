%{
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "node.h"
#include "y.tab.h"

int yyerror(char *s);
int octal(char *s);
int integer(char *integer);
int binary(char *binary);
double number(char *s);
void StringToHex(char *yylval, char *text);

int counter = 0;
int stringFlag = 0;
int nFlag = 0;
%}
%x COM1 COM2 STR1 DEL
%%

<COM1>"=<" counter++;
<COM1>"=>"	counter--; if(counter < 0) {counter = 0; BEGIN 0;};
<COM1>.|\n	;

<COM2>[^\n]	;
<COM2>[\n] 	BEGIN 0;

"=<"		BEGIN COM1;
"=="		BEGIN COM2; if(nFlag != 0){return 59;}

"integer"			nFlag = 0;	return INTEGER;
"string"			nFlag = 0;	return STRING;
"number"			nFlag = 0;	return NUMBER;
"void"				nFlag = 0;	return VOID;
"public"			nFlag = 0;	return PUBLIC;
"const"				nFlag = 0;	return CONST;
"if"					nFlag = 0;  return IF;
"then"				nFlag = 0;	return THEN;
"else"				nFlag = 0;	return ELSE;
"while"				nFlag = 0;	return WHILE;
"do"					nFlag = 0;  return DO;
"for"					nFlag = 0;  return FOR;
"in"					nFlag = 0;  return IN;
"step"				nFlag = 0;	return STEP;
"upto"				nFlag = 0;	return UPTO;
"downto"			nFlag = 0;	return DOWNTO;
"break"				nFlag = 0;	return BREAK;
"continue"		nFlag = 0;	return CONTINUE;
">="					nFlag = 0;  return GE;
"<="					nFlag = 0;  return LE;
"<>"					nFlag = 0;  return DIF;
":="					nFlag = 0;  return ASSIGN;
"++"					nFlag = 0;  return INC;
"--"					nFlag = 0;  return DEC;


\"([^\"]|\\\"])*\"	yylval.s = malloc(yyleng); *yylval.s = 0; stringFlag = 1; REJECT;
\"  BEGIN STR1;
<STR1>\"	BEGIN 0; nFlag = 1; return STR;
<STR1>\\n		if(stringFlag != 0) {strcat(yylval.s, "\n");}
<STR1>\\r		if(stringFlag != 0) {strcat(yylval.s, "\r");}
<STR1>\\t		if(stringFlag != 0) {strcat(yylval.s, "\t");}
<STR1>\\([0-9a-fA-F]{1,2})  if(stringFlag != 0) {StringToHex(yylval.s, yytext);}
<STR1>\\\"  if(stringFlag != 0) {strcat(yylval.s, "\"");}
<STR1>.|\n  if(stringFlag != 0) {strcat(yylval.s, yytext);}

"0b"[01]+       yylval.i = binary(yytext+2); nFlag = 1; return INT;
0[0-9]*					yylval.i = octal(yytext); nFlag = 1; return INT;
[1-9][0-9]*			yylval.i = integer(yytext); nFlag = 1; return INT; 
[a-zA-Z][a-zA-Z_0-9]* 	yylval.s = strdup(yytext); nFlag = 1;	return ID;
[\)\!]      nFlag = 1; return *yytext;
[-+*/%<>=|&~]   nFlag = 0;  return *yytext;
[1-9][0-9]*\.[0-9]+([eE][+-][0-9]+)?		yylval.d = number(yytext); nFlag = 1; return NUM;  
[\#\{\}\(\[\]\;\,]    nFlag = 0; return *yytext;
[\n]      if(nFlag != 0){ nFlag = 0; return 59;}
[ \r\t]+    ;
.						return yyerror("Unknown character"); 

%%
int yywrap(void) {
  if (YYSTATE == COM1 || YYSTATE == COM2) yyerror("unterminated comment");
  if (YYSTATE == STR1) yyerror("unterminated string");
  return 1;
} 
char *getyytext() { return yytext; }

int integer(char *integer)
{	
    errno = 0;
  	int value = strtol(integer, 0, 10);
  	if(errno == ERANGE){
      yyerror("integer overflow");
  	  return 0;
    }
  	return value;
}

//Check from B programming
int octal(char *s)
{
  int i, a = 0, b = 0;

  for (i = 0; i < strlen(s); i++) {
    if (s[i] < '0' || s[i] > '9') break;
    b = b * 8 + s[i] - '0';
    if (b < a) {
      yyerror("octal overflow");
      break;
    }
    a = b;
  }
  return a;
}

int binary(char *binary){

  errno = 0;
  int value = strtol(binary, 0, 2);
  if(errno == ERANGE){
    yyerror("binary overflow");
    return 0;
  }
  return value;
}

double number(char *s){

  errno = 0;
  double value = strtod(s, NULL);

  if(errno == ERANGE){
    yyerror("number overflow");
    return 0;
  }
  return value;
}

void StringToHex(char *yylval, char *text){
  int size = strlen(yylval);

  errno = 0;

  int value = strtol(text+1, NULL, 16);

  if(errno == ERANGE){
    yyerror("Hexadecimal overflow");
    yylval[size] = '1';
    yylval[size+1] = '\0'; 
  }
  yylval[size] = (char)value;
  yylval[size+1] = '\0';
}

