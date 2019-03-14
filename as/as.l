%{
#include <inttypes.h>
#include "as.tab.h"
%}

NONDIGIT	[_a-zA-Z]
DIGIT		[0-9]
IDENTIFIERS	[_a-zA-Z0-9]

%x COMMENT

%%

{DIGIT}+	{ yylval.n = strtoumax(yytext, NULL, 10); return NUMBER; }

{NONDIGIT}{IDENTIFIERS}* { yylval.s = yytext; return TOKEN; }

:|,|\.		{ return yytext[0]; }
\n		{ return NEWLINE; }

;		{ BEGIN COMMENT; }
<COMMENT>.	;
<COMMENT>\n	{ BEGIN INITIAL; return NEWLINE; }

.		;
