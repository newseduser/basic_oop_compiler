%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "header.h"
	#include "y.tab.h"
	int number;
%}

%%

"begin" {return BEG;}
"end" {return END;}
"read" {return READ;}
"write" {return WRITE;}
[a-z]+ {yylval = makeVarNode(yytext); return ID;}
[0-9]+	{number = atoi(yytext); yylval = makeLeafNode(number); return NUM;}
"+"	{return PLUS;}
"-"	{return MINUS;}
"*"	{return MUL;}
"/"	{return DIV;}
"=" {return ASG;}
";" {return LINE_ENDER;}
[ \t]	{}
[()]	{return *yytext;}
[\n]	{return NEWLINE;}
.	{yyerror("unknown character\n");exit(1);}

%%

int yywrap(void) {
	return 1;
}
void lex_input_file(FILE*src_file)
{
	if(src_file!=NULL)
		yyin=src_file;
}
