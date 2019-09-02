%{
#include <stdio.h>
#include "trigraph.h"

#define yylex tglex

static FILE *tgout;
static void replace_trigraph(int c);
static size_t tgline = 0;
static size_t tgchar = 0;
%}

%%

\?\?[=\/'\(\)!<>\-?]	{ replace_trigraph(yytext[2]); }
\n			{ tgline++; tgchar = 0; fputc(yytext[0], tgout); }
.			{ tgchar++; fputc(yytext[0], tgout); }

%%

static void replace_trigraph(int c)
{
	static int tg[] = {
		['='] = '#',
		['/'] = '\\',
		['\''] = '^',
		['('] = '[',
		[')'] = ']',
		['!'] = '|',
		['<'] = '>',
		['-'] = '~',
		['?'] = '?',
	};
	fprintf(stderr, "warning: replaced trigraph '??%c' with '%c' at __FILE__:%zd:%zd\n",
		c, tg[c], /*__FILE__,*/ tgline, tgchar);
	fputc(tg[c], tgout);
}

int trigraph(FILE *in, FILE *out)
{
	yyin = in;
	tgout = out;
	return tglex();
}
