%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "header.h"
	#include "y.tab.h"
	int number;
%}

%%

[0-9]+	{number = atoi(yytext); yylval = makeLeafNode(number); return NUM;}
"+"	{return PLUS;}
"-"	{return MINUS;}
"*"	{return MUL;}
"/"	{return DIV;}
[ \t]	{}
[()]	{return *yytext;}
[\n]	{return END;}
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