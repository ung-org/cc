%{
#include <stdio.h>

int yylex(void);

void yyerror(char *str)
{
	printf("WUT?: %s\n" str);
}
%}

%union {
}

 /* keywords */
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN
	FLOAT FOR GOTO IF INT LONG REGISTER RETURN SHORT SIGNED SIZEOF STATIC
	STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE

 /* operators */
%token LBRACKET RBRACKET LPAREN RPAREN DOT ARROW INCREMENT DECREMENT AMPERSAND
	STAR PLUS MINUS TILDE BANG SLASH PERCENT LSHIFT RSHIFT LESSTHAN
	GREATERTHAN LESSEQUAL GREATEREQUAL ISEQUAL NOTEQUAL CARET PIPE ANDAND
	OROR QUESTION COLON EQUALS STAREQUALS SLASHEQUALS PERCENTEQUALS
	PLUSEQUALS MINUSEQUALS LSHIFTEQUALS RSHIFTEQUALS ANDEQUALS CARETEQUALS
	PIPEEQUALS COMMA HASH HASHHASH

 /* additional punctuators */
%token LBRACE RBRACE SEMICOLON DOTDOTDOT

%%

primary-expression:
	identifier
	| constant
	| string-literal
	| LPAREN expression RPAREN
	;

postfix-expression:
	primary-expression
	| postfix-expression LBRACKET expression RBRACKET
	| postfix-expression LPAREN argument-expression-list RPAREN
	| postfix-expression LPRAEN RPAREN
	| postfix-expression DOT identifier
	| postfix-expression ARROW identifier
	| postfix-expression INCREMENT
	| postfix-expression DECREMENT
	;

argument-expression-list:
	assignment-expression
	| argument-expression-list COMMA assignment-expression
	;

unary-expression:
	postfix-expression
	| INCREMENT unary-expression
	| DECREMENT unary-expression
	| unary-operator cast-expression
	| SIZEOF unary-expression
	| SIZEOF LPAREN type-name RPAREN
	;

unary-operator:
	AMPERSAND
	| STAR
	| PLUS
	| MINUS
	| TILDE
	| BANG
	;

cast-expression:
	unary-expression
	| LPAREN type-name RPAREN cast-expression
	;

multiplicative-expression:
	cast-expression
	| multiplicative-expression STAR cast-expression
	| multiplicative-expression SLASH cast-expression
	| multiplicative-expression PERCENT cast-expression
	;

additive-expression:
	multiplicative-expression
	| additive-expression PLUS multiplicative-expression
	| additive-expression MINUS multiplicative-expression
	;

shift-expression:
	additive-expression
	| shift-expression LSHIFT additive-expression
	| shift-expression RSHIFT additive-expression
	;

relational-expression:
	shift-expression
	| relational-expression LESSTHAN shift-expression
	| relational-expression GREATERTHAN shift-expression
	| relational-expression LESSEQUAL shift-expression
	| relational-expression GREATEREQUAL shift-expression
	;

equality-expression:
	relational-expression
	| equality-expression ISEQUAL relational-expression
	| equality-expression NOTEQUAL relational-expression
	;

AND-expression:
	equality-expression
	| AND-expression AMPERSAND equality-expression
	;

exclusive-OR-expression:
	AND-expression
	| exclusive-OR-expression CARET AND-expression
	;

inclusive-OR-expression:
	exclusive-OR-expression
	| inclusive-OR-expression PIPE exclusive-OR-expression
	;

logical-AND-expression:
	inclusive-OR-expression
	| logical-AND-expression ANDAND inclusive-OR-expression
	;

logical-OR-expression:
	logical-AND-expression
	| logical-OR-expression OROR logical-AND-expression
	;

conditional-expression:
	logical-OR-expression
	| logical-OR-expression QUESTION expression COLON conditional-expression
	;

assignment-expression:
	conditional-expression
	| unary-expression assignment-operator assignment-expression
	;

assignment-operator:
	EQUALS
	| STAREQUALS
	| SLASHEQUALS
	| PERCENTEQUALS
	| PLUSEQUALS
	| MINUSEQUALS
	| LSHIFTEQUALS
	| RSHIFTEQUALS
	| ANDEQUALS
	| CARETEQUALS
	| PIPEEQUALS
	;

expression:
	assignment-expression
	| expression COMMA assignment-expression
	;

constant-expression:
	conditional-expression
	;

declaration:
	declaration-specifiers SEMICOLON
	| declaration-specifiers init-declarator-list SEMICOLON
	;

declaration-specifiers:
	storage-class-specifier
	| storage-class-specifier declaration-specifiers
	| type-specifier
	| type-specifier declaration-specifiers
	| type-qualifier
	| type-qualifier declaration-specifiers
	;

init-declarator-list:
	init-declarataor
	| init-declarator-list COMMA init-declarator
	;

init-declarator:
	declarator
	| declarator EQUALS initializer
	;

storage-class-specifier:
	TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type-specifier:
	VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| struct-or-union-specifier
	| enum-specifier
	| typedef-name
	;

struct-or-union-specifier:
	struct-or-union LBRACE struct-declaration-list RBRACE
	| struct-or-union identifier LBRACE struct-declaration-list RBRACE
	| struct-or-union identifier
	;

struct-or-union:
	STRUCT
	| UNION
	;

struct-declaration-list:
	struct-declaration
	| struct-declaration-list struct declaration
	;

struct-declaration:
	specifier-qualifier-list struct-declarator-list SEMICOLON
	;

specifier-qualifier-list:
	type-specifier
	| type-specifier specifier-qualifier-list
	| type-qualifier
	| type-qualifier specifier-qualifier-list
	;

struct-declarator-list:
	struct-declarator
	| struct-declarator-list COMMA struct-declarator
	;

struct-declarator:
	declarator
	| COMMA constant-expression
	| declarator COMMA constant-expression
	;

enum-specifier:
	ENUM LBRACE enumerator-list RBRACE
	| ENUM identifier LBRACE enumerator-list RBRACE
	| ENUM identifier
	;

enumerator-list:
	enumerator
	| enumerator-list COMMA enumerator
	;

enumerator:
	enumeration-constant
	| enumeration-constant EQUALS constant-expression
	;

type-qualifier:
	CONST
	| VOID
	;

declarator:
	direct-declarator
	| pointer direct-declarator
	;

direct-declarator:
	identifier
	| LPAREN declarator RPAREN
	| direct-declarator LBRACKET RBRACKET
	| direct-declarator LBRACKET constant-expression RBRACKET
	| direct-declarator LPAREN parameter-type-list RPAREN
	| direct-declarator LPAREN RPAREN
	| direct-declarator LPAREN identifier-list RPAREN
	;

pointer:
	STAR
	| STAR type-qualifier-list
	| STAR pointer
	| STAR type-qualifier-list pointer
	;

type-qualifier-list:
	type-qualifier
	| type-qualifier-list type-qualifier
	;

parameter-type-list:
	parameter-list
	| parameter-list COMMA DOTDOTDOT
	;

parameter-list:
	parameter-declaration
	| parameter-list COMMA parameter-declaration
	;

parameter-declaration:
	declaration-specifiers declarator
	| declaration-specifiers
	| declaration-specifiers abstract-declarator
	;

identifier-list:
	identifier
	| identifier-list COMMA identifier
	;

type-name:
	specifier-qualifier-list
	| specifier-qualifier-list abstract-declarator
	;

abstract-declarator:
	pointer
	| direct-abstract-declarator
	| point direct-abstract-declarator
	;

direct-abstract-declarator:
	LPAREN abstract-declarator RPAREN
	| LBRACKET RBRACKET
	| LBRACKET constant-expression RBRACKET
	| direct-abstract-declarator LBRACKET RBRACKET
	| direct-abstract-declarator LBRACKET constant-expression RBRACKET
	| LPAREN RPAREN
	| LPAREN parameter-type-list RPAREN
	| direct-abstract-declarator LPAREN RPAREN
	| direct-abstract-declarator LPAREN parameter-type-list RPAREN
	;

typdef-name:
	identifier
	;

initializer:
	assignment-expression
	| LBRACE initializer-list RBRACE
	| LBRACE initializer-list COMMA RBRACE
	;

initializer-list:
	initializer
	| initializer-list COMMA initializer
	;

statement:
	labeled-statement
	| compound-statement
	| expression-statement
	| selection-statement
	| iteration-statement
	| jump-statement
	;

labeled-statement:
	identifier COLON statement
	| CASE constant-expression COLON statement
	| DEFAULT COLON statement
	;

compound-statement:
	LBRACE RBRACE
	| LBRACE declaration-list RBRACE
	| LBRACE statement-list RBRACE
	| LBRACE declaration-list statement-list RBRACE
	;

declaration-list:
	declaration
	| declaration-list declaration
	;

statement-list:
	statement
	| statement-list statement
	;

expression-statement:
	SEMICOLON
	| expression SEMICOLON
	;

selection-statement:
	IF LPAREN expression RPAREN statement
	| IF LPAREN expression RPAREN statement ELSE statement
	| SWITCH LPAREN expression RPAREN statement
	;

iteration-statement:
	WHILE LPAREN expression RPAREN statement
	| DO statement WHILE LPAREN expression RPAREN SEMICOLON
	| FOR LPAREN SEMICOLON SEMICOLON RPAREN statement
	| FOR LPAREN expression SEMICOLON SEMICOLON RPAREN statement
	| FOR LPAREN SEMICOLON expression SEMICOLON RPAREN statement
	| FOR LPAREN SEMICOLON SEMICOLON expression RPAREN statement
	| FOR LPAREN expression SEMICOLON expression SEMICOLON RPAREN statement
	| FOR LPAREN SEMICOLON expression SEMICOLON expression RPAREN statement
	| FOR LPAREN expression SEMICOLON SEMICOLON expression RPAREN statement
	| FOR LPAREN expression SEMICOLON expression SEMICOLON expression RPAREN statement
	;

jump-statement:
	GOTO identifier SEMICOLON
	| CONTINUE SEMICOLON
	| BREAK SEMICOLON
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	;

translation-unit:
	external-declaration
	| translation-unit external-declaration
	;

external-declaration:
	function-definition
	| declaration
	;

function-definition:
	declarator compound-statement
	| declaration-specifiers declarator compound-statement
	| declarator declaration-list compound-statement
	| declaration-specifiers declarator declaration-list compound-statement
	;

preprocessing-file:
	/* optional */
	| group
	;

group:
	group-part
	| group group-part
	;

group-part:
	new-line
	| pp-tokens new-line
	| if-section
	| control-line
	;

if-section:
	if-group endif-line
	| if-group elif-groups endif-line
	| if-group else-group endif-line
	| if-group elif-groups else-group endif-line
	;

if-group:
	HASH IF constant-expression new-line
	| HASH IF constant-expression new-line group
	| HASH IFDEF identifier new-line
	| HASH IFDEF identifier new-line group
	| HASH IFNDEF identifier new-line
	| HASH IFNDEF identifier new-line group
	;

elif-groups:
	elif-group
	| elif-groups elif-group
	;

elif-group:
	HASH ELIF constant-expression new-line
	| HASH ELIF constant-expression new-line group
	;

else-group:
	HASH ELSE new-line
	| HASH ELSE new-line group
	;

endif-line:
	HASH ENDIF new-line
	;

control-line:
	HASH INCLUDE pp-tokens new-line
	| HASH DEFINE identifier replacement-list new-line
	| HASH DEFINE identifier lparen RPAREN replacement-list new-line
	| HASH DEFINE identifier lparen identifier-list RPAREN replacement-list new-line
	| HASH UNDEF identifier new-line
	| HASH LINE pp-tokens new-line
	| HASH ERROR new-line
	| HASH ERROR pp-tokens new-line
	| HASH PRAGMA new-line
	| HASH PRAGMA pp-tokens new-line
	| HASH new-line
	;

lparen:
	LPAREN	/* without preceding white space */
	;

replacement-list:
	/* optional */
	| pp-tokens
	;

pp-tokens:
	preprocessing-token
	| pp-tokens preprocessing-token
	;

new-line:
	NEWLINE
	;
