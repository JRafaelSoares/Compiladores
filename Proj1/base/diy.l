%{
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "node.h"
#include "y.tab.h"
void yyerror(char *s);
%}
%x COM1 COM2 STR1
%%
<COM1>.|\n	;
<COM1>"=>"	BEGIN 0;

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

\"([^\"])*\"	yylval.s = malloc(yyleng); *yylval.s = 0; REJECT;
\" BEGIN STR1;
<STR1>\"	BEGIN 0; printf("%s\n", yylval.s); 		return STR;
<STR1>\\([0-9a-fA-F]{1,2}) yylval.s[strlen(yylval.s)] = (char)(int)strtol(yytext+1, NULL, 16); yylval.s[strlen(yylval.s)+1] = '\0';
<STR1>\\\" strcat(yylval.s, "\"");
<STR1>.|\n  strcat(yylval.s, yytext);

[0-9]+			yylval.i = strtol(yytext, 0, 10); 	return INT; 
[a-zA-Z][a-zA-Z_0-9]* 	yylval.s = strdup(yytext); 	return ID;
[0-9]+\.[0-9]+										yylval.d =  strtod(yytext, NULL); ECHO; return NUM;
.													yyerror("Unknown character");
%%
int yywrap(void) { return 1; }
char *getyytext() { return yytext; }

