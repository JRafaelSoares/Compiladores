#define INT 257
#define STR 258
#define ID 259
#define NUM 260
#define VOID 261
#define INTEGER 262
#define STRING 263
#define NUMBER 264
#define FOR 265
#define PUBLIC 266
#define CONST 267
#define IF 268
#define THEN 269
#define ELSE 270
#define WHILE 271
#define DO 272
#define IN 273
#define STEP 274
#define UPTO 275
#define DOWNTO 276
#define BREAK 277
#define CONTINUE 278
#define GE 279
#define LE 280
#define DIF 281
#define ASSIGN 282
#define INC 283
#define DEC 284
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
	int i;			/* integer value */
	char* s;
	double d;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
