%{
#include <inttypes.h>
%}

%union {
	char *s;
	uintmax_t n;
};

%token<n> NUMBER
%token<s> TOKEN
%token NEWLINE

%%

program
	: /* empty */
	| instruction NEWLINE
;

instruction
	: bare_instruction
	| TOKEN ':' bare_instruction
;

bare_instruction
	: TOKEN
	| TOKEN operand
	| TOKEN operand ',' operand
	| TOKEN operand ',' operand ',' operand
;

operand
	: TOKEN
	| NUMBER
;
