%{
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "node.h"
#include "y.tab.h"
#include <math.h>
int yyerror(char *s);
int octal(char *s);
int integer(char *integer);
int binary(char *binary);
double number(char *s);
int counter = 0;
%}
%x COM1 COM2 STR1
%%

<COM1>"=<" counter++;
<COM1>"=>"	counter--; if(counter < 0) {counter = 0; BEGIN 0;};
<COM1>.|\n	;

<COM2>[^\n]	;
<COM2>\n 	BEGIN 0;

"=<"		BEGIN COM1;
"=="		BEGIN COM2;

"integer"											return INTEGER;
"string"											return STRING;
"number"											return NUMBER;
"void"												return VOID;
"public"											return PUBLIC;
"const"												return CONST;
"if"												return IF;
"then"												return THEN;
"else"												return ELSE;
"while"												return WHILE;
"do"												return DO;
"for"												return FOR;
"in"												return IN;
"step"												return STEP;
"upto"												return UPTO;
"downto"											return DOWNTO;
"break"												return BREAK;
"continue"											return CONTINUE;
">="												return GE;
"<="												return LE;
"<>"												return DIF;
":="												return ASSIGN;
"++"												return INC;
"--"												return DEC;


\"([^\"])*\"	yylval.s = malloc(yyleng); *yylval.s = 0; REJECT;
\" BEGIN STR1;
<STR1>\"	BEGIN 0; return  STR;
<STR1>\\n		strcat(yylval.s, "\n");
<STR1>\\r		strcat(yylval.s, "\r");
<STR1>\\t		strcat(yylval.s, "\t");
<STR1>\\([0-9a-fA-F]{1,2})  yylval.s[strlen(yylval.s)] = (char)(int)strtol(yytext+1, NULL, 16); yylval.s[strlen(yylval.s)+1] = '\0';
<STR1>\\\" strcat(yylval.s, "\"");
<STR1>.|\n  strcat(yylval.s, yytext); 

"0b"[01]+       yylval.i = binary(yytext+2); return INT;
0[0-9]*					yylval.i = octal(yytext); return INT;
[1-9][0-9]*			yylval.i = integer(yytext); return INT; 
[a-zA-Z][a-zA-Z_0-9]* 	yylval.s = strdup(yytext); 	return ID;
[-+*/%<>=!|&~] 			return *yytext;
[1-9][0-9]*\.[0-9]+([eE][+-][0-9]+)?		yylval.d = number(yytext); return NUM;  
[\#\{\}\(\)\[\]\;\,]    return *yytext;
[ \n\r\t]+    ;
.						return yyerror("Unknown character"); 

%%
int yywrap(void) { return 1; }
char *getyytext() { return yytext; }

int integer(char *integer)
{	
  if(strlen(integer) > 10){
    yyerror("integer overflow");
    return -1;
  }
  else{
  	int value = strtol(integer, 0, 10);
    printf("%d\n", value);
  	if(value <= 0){
      yyerror("integer overflow");
  	}
  	return value;
  }
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

  int value = strtol(binary, 0, 2);
  if(value < 0){
    yyerror("binary overflow");
  }
  return value;
}

double number(char *s){

  double value = strtod(s, NULL);

  if(value < 0.0 || value == INFINITY){
    yyerror("number overflow");
  }
  return value;
}

void StringToHex(char *yylval, char *text){

}

