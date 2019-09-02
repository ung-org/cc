%{
#define _XOPEN_SOURCE 700
#include <errno.h>
#include <search.h>
#include <stdio.h>
#include <string.h>
#include "version.h"

#define HASHSIZE 1024

int cpplex(void);
int cpperror(const char *s);
%}

%token IDENTIFIER
%token LPAREN
%token H_CHAR Q_CHAR
%token DIGIT
%token IF IFDEF IFNDEF ELIF ELSE ENDIF
%token INCLUDE DEFINE UNDEF LINE ERROR PRAGMA
%token OPERATOR PUNCTUATOR
%token CHARACTER_CONSTANT STRING_LITERAL
%token sign identifier_list constant_expression

%start preprocessing_file

%%

preprocessing_file	: /* empty */
			| group
			;

group	: group_part
	| group group_part;

group_part	: new_line
		| pp_tokens new_line
		| if_section
		| control_line
		;

if_section	: if_group endif_line
		| if_group elif_groups endif_line
		| if_group else_group endif_line
		| if_group elif_groups else_group endif_line
		;

if_group	: '#' IF constant_expression new_line
		| '#' IF constant_expression new_line group
		| '#' IFDEF IDENTIFIER new_line
		| '#' IFDEF IDENTIFIER new_line group
		| '#' IFNDEF IDENTIFIER new_line
		| '#' IFNDEF IDENTIFIER new_line group
		;

elif_groups	: elif_group
		| elif_groups elif_group
		;

elif_group	: '#' ELIF constant_expression new_line
		| '#' ELIF constant_expression new_line group
		;

else_group	: '#' ELSE new_line
		| '#' ELSE new_line group
		;

endif_line	: '#' ENDIF new_line
		;

control_line	: '#' INCLUDE pp_tokens new_line
		| '#' DEFINE IDENTIFIER replacement_list new_line
		| '#' DEFINE IDENTIFIER LPAREN ')' replacement_list new_line
		| '#' DEFINE IDENTIFIER LPAREN identifier_list ')' replacement_list new_line
		| '#' UNDEF IDENTIFIER new_line
		| '#' LINE pp_tokens new_line
		| '#' ERROR new_line
		| '#' ERROR pp_tokens new_line
		| '#' PRAGMA new_line
		| '#' PRAGMA pp_tokens new_line
		| '#' new_line
		;

/* LPAREN: '(' without preceding whitespace */

replacement_list	: /* empty */
			| pp_tokens
			;

pp_tokens	: preprocessing_token
		| pp_tokens preprocessing_token
		;

new_line	: '\n'
		;

preprocessing_token	: header_name
			| IDENTIFIER
			| pp_number
			| CHARACTER_CONSTANT 
			| STRING_LITERAL 
			| OPERATOR
			| PUNCTUATOR
			;

header_name	: '<' h_char_sequence '>'
		| '"' q_char_sequence '"'
		;

h_char_sequence	: H_CHAR
		| h_char_sequence H_CHAR
		;

q_char_sequence	: Q_CHAR
		| q_char_sequence Q_CHAR
		;

pp_number	: DIGIT
		| '.' DIGIT
		| pp_number DIGIT
		/* | pp_number nondigit */
		| pp_number 'e' sign
		| pp_number 'E' sign
		| pp_number '.'
		;

%%

int cpplex(void)
{
	return 0;
}

int cpperror(const char *s)
{
	(void)s;
	return 0;
}

void define(const char *macro, const char *replacement)
{
	static int created = 0;
	if (!created) {
		hcreate(HASHSIZE);
	}
	ENTRY e = {
		.key = strdup(macro),
		.data = strdup(replacement)
	};
	ENTRY *p = hsearch(e, ENTER);
	if (p == NULL) {
		cpperror(strerror(ENOMEM));
	}
	printf("replacing '%s' with '%s'\n", macro, replacement == (char*)-1 ? "INTERNAL" : replacement);
}

void undef(const char *macro)
{
	printf("undefining '%s'\n", macro);
}

void include(const char *path)
{
	printf("adding '%s' to INCLUDE path\n", path);
}

int preprocess(FILE *in, FILE *out, long int version)
{
	printf("preprocessing\n");
	int c = 0;
	while ((c = fgetc(in)) != EOF) {
		fputc(c, out);
	}
}
