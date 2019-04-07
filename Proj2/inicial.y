%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
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
file	:
	;
%%
char *infile = "<<stdin>>";


int yyerror(char *s) {
	extern int yylineno;
  	extern char *getyytext();
  	fprintf(stderr, "%s: %s at or before '%s' in line %d\n", infile, s, getyytext(), yylineno);
  	yynerrs++; return 1; }

int main(int argc, char *argv[]) {
	    extern YYSTYPE yylval;
	    int tk;

	    if (argc > 1) {
    		extern FILE *yyin;
    		if ((yyin = fopen(infile = argv[1], "r")) == NULL) {
      			perror(argv[1]);
      			return 1;
    		}
  		}

	    while ((tk = yylex())) {
		    if (tk > YYERRCODE){		    	
			    printf("%d:\t%s\n", tk, yyname[tk]);
		    }
		    else{		    	
			    printf("%d:\t%c\n", tk, tk);
		    }
		}
	    
	    return yynerrs;
    }

char **yynames =
#if YYDEBUG > 0
		 (char**)yyname;
#else
		 0;
#endif

