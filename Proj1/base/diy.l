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
%}
%x COM1 COM2 STR1 DEL
%%

<COM1>"=<" counter++;
<COM1>"=>"	counter--; if(counter < 0) {counter = 0; BEGIN 0;};
<COM1>.|\n	;

<COM2>[^\n]	;
<COM2>[\n] 	BEGIN 0;

<DEL>" " ;
<DEL>[\;\n]   BEGIN 0; return 59;
<DEL>[^\;\n ] yyless(0); BEGIN 0; 

"=<"		BEGIN COM1;
"=="		BEGIN COM2;

"integer"											return INTEGER;
"string"											return STRING;
"number"											return NUMBER;
"void"												return VOID;
"public"											return PUBLIC;
"const"												return CONST;
"if"												  return IF;
"then"												return THEN;
"else"												return ELSE;
"while"												return WHILE;
"do"												  return DO;
"for"										      return FOR;
"in"												  return IN;
"step"												return STEP;
"upto"												return UPTO;
"downto"											return DOWNTO;
"break"												return BREAK;
"continue"										return CONTINUE;
">="												  return GE;
"<="												  return LE;
"<>"												  return DIF;
":="												  return ASSIGN;
"++"												  return INC;
"--"												  return DEC;


\"([^\"|\\\"])*\"	yylval.s = malloc(yyleng); *yylval.s = 0; stringFlag = 1; REJECT;
\"  BEGIN STR1;
<STR1>\"	BEGIN 0; BEGIN DEL; return STR;
<STR1>\\n		if(stringFlag != 0) {strcat(yylval.s, "\n");}
<STR1>\\r		if(stringFlag != 0) {strcat(yylval.s, "\r");}
<STR1>\\t		if(stringFlag != 0) {strcat(yylval.s, "\t");}
<STR1>\\([0-9a-fA-F]{1,2}) if(stringFlag != 0) {StringToHex(yylval.s, yytext);}
<STR1>\\\" if(stringFlag != 0) {strcat(yylval.s, "\"");}
<STR1>.|\n  if(stringFlag != 0) {strcat(yylval.s, yytext);}

"0b"[01]+      yylval.i = binary(yytext+2); BEGIN DEL; return INT;
0[0-9]*					yylval.i = octal(yytext); BEGIN DEL; return INT;
[1-9][0-9]*			yylval.i = integer(yytext); BEGIN DEL; return INT; 
[a-zA-Z][a-zA-Z_0-9]* 	yylval.s = strdup(yytext); BEGIN DEL;	return ID;
[\)\!]    BEGIN DEL; return *yytext;
[-+*/%<>=|&~] 		return *yytext;
[1-9][0-9]*\.[0-9]+([eE][+-][0-9]+)?		yylval.d = number(yytext); BEGIN DEL; return NUM;  
[\#\{\}\(\[\]\;\,]    return *yytext;
[ \n\r\t]+    ;
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

