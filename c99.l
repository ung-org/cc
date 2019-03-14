%{
#include "c99.tab.h"
%}

%%
;		{ printf ("SEMICOLON\n"); return SEMICOLON; }
"+"		{ printf ("PLUS\n"); return PLUS; }
"-"		{ printf ("MINUS\n"); return MINUS; }
int		{ printf ("INT\n"); return INT; }
"\".*\""	{ printf ("string literal:%s\n", yytext); return STRING; }
[a-zA-z_]+	{ printf ("identifier: %s\n", yytext); return IDENTIFIER; }
"/*[.]**/"	{ printf ("COMMENT\n"); return COMMENT; }
%%

int yywrap (void) { return 0; }
