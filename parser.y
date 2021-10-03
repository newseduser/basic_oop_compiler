%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "header.h"
	#include "codes.c"
	int yylex(void);
    #define YYSTYPE tnode*
    tnode*parse_tree;
%}


%token NUM PLUS MINUS MUL DIV END
%left PLUS MINUS
%left MUL DIV

%%

program : expr END	{
				$$ = $2;
				parse_tree=$1;
                return 0;
			}
		;

expr : expr PLUS expr		{$$ = makeOperatorNode('+',$1,$3);}
	 | expr MINUS expr  	{$$ = makeOperatorNode('-',$1,$3);}
	 | expr MUL expr	{$$ = makeOperatorNode('*',$1,$3);}
	 | expr DIV expr	{$$ = makeOperatorNode('/',$1,$3);}
	 | '(' expr ')'		{$$ = $2;}
	 | NUM			{$$ = $1;}
	 ;

%%

void yyerror(char const *s)
{
    printf("yyerror %s",s);
}
int lex_input_file(FILE*);

int main(int argc, char**argv)
 {
    if(argc<2)
    {
        printf("No args.");
        return 0;
    }
	FILE*src_file = fopen(argv[1],"r");
	lex_input_file(src_file);
    yyparse();
    FILE*target_file;
    target_file = fopen("fin.xsm","w");
	codeWrite(parse_tree,target_file);
	return 0;
}