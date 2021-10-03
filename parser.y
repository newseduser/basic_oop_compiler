%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "header.h"
	#include "codes.c"
	int yylex(void);
    #define YYSTYPE tnode*
    tnode*parse_tree;
%}


%token ID NUM PLUS MINUS MUL DIV END BEG READ WRITE
%left PLUS MINUS
%left MUL DIV

%%

program : BEG NEWLINE Slist END {
				$$ = $3;
				parse_tree=$3;
				printf("[+] Syntax Matched!\n");fflush(stdout);
                return 0;
};

Slist : Slist Stmt LINE_ENDER NEWLINE {$$ = createTree(0,'c',NULL,$1,$2);} | Stmt LINE_ENDER NEWLINE {$$=$1;} | Slist NEWLINE {$$=$1;};
Stmt : InputStmt {$$=$1;} | OutputStmt {$$=$1;} | AsgStmt {$$=$1;} ;
InputStmt : READ '(' ID ')'  {$$ = makeActionNode('r',$3);};
OutputStmt : WRITE '(' expr ')'  {$$ = makeActionNode('w',$3);};
AsgStmt : expr ASG expr  {$$ = makeOperatorNode('=',$1,$3);};
expr : expr PLUS expr		{$$ = makeOperatorNode('+',$1,$3);}
	 | expr MINUS expr  	{$$ = makeOperatorNode('-',$1,$3);}
	 | expr MUL expr	{$$ = makeOperatorNode('*',$1,$3);}
	 | expr DIV expr	{$$ = makeOperatorNode('/',$1,$3);}
	 | '(' expr ')'		{$$ = $2;}
	 | NUM			{$$ = $1;}
	 | ID			{$$ = $1;}
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
