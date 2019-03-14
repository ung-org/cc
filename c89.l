%{

%}

DIGIT [0-9]
UPPER [A-Z]
LOWER [a-z]
NONDIGIT [_a-zA-Z]

%%
 /* keywords */
"auto"		{ return AUTO; }
"break"		{ return BREAK; }
"case"		{ return CASE; }
"char"		{ return CHAR; }
"const"		{ return CONST; }
"continue"	{ return CONTINUE; }
"default"	{ return DEFAULT; }
"do"		{ return DO; }
"double"	{ return DOUBLE; }
"else"		{ return ELSE; }
"enum"		{ return ENUM; }
"extern"	{ return EXTERN; }
"float"		{ return FLOAT; }
"for"		{ return FOR; }
"goto"		{ return GOTO; }
"if"		{ return IF; }
"int"		{ return INT; }
"long"		{ return LONG; }
"register"	{ return REGISTER; }
"return"	{ return RETURN; }
"short"		{ return SHORT; }
"signed"	{ return SIGNED; }
"sizeof"	{ return SIZEOF; }
"static"	{ return STATIC; }
"struct"	{ return STRUCT; }
"switch"	{ return SWITCH; }
"typedef"	{ return TYPEDEF; }
"union"		{ return UNION; }
"unsigned"	{ return UNSIGNED; }
"void"		{ return VOID; }
"volatile"	{ return VOLATILE; }
"while"		{ return WHILE; }

 /* operators */
"["		{ return LBRACKET; }
"]"		{ return RBRACKET; }
"("		{ return LPAREN; }
")"		{ return RPAREN; }
"."		{ return DOT; }
"->"		{ return ARROW; }
"++"		{ return INCREMENT; }
"--"		{ return DECREMENT; }
"&"		{ return AMPERSAND; }
"*"		{ return STAR; }
"+"		{ return PLUS; }
"-"		{ return MINUS; }
"~"		{ return TILDE; }
"!"		{ return BANG; }
"/"		{ return SLASH; }
"%"		{ return PERCENT; }
"<<"		{ return LSHIFT; }
">>"		{ return RSHIFT; }
"<"		{ return LESSTHAN; }
">"		{ return GREATERTHAN; }
"<="		{ return LESSEQUAL; }
">="		{ return GREATEREQUAL; }
"=="		{ return ISEQUAL; }
"!="		{ return NOTEQUAL; }
"^"		{ return CARET; }
"|"		{ return PIPE; }
"&&"		{ return ANDAND; }
"||"		{ return OROR; }
"?"		{ return QUESTION; }
":"		{ return COLON; }
"="		{ return EQUALS; }
"*="		{ return STAREQUALS; }
"/="		{ return SLASHEQUALS; }
"%="		{ return PERCENTEQUALS; }
"+="		{ return PLUSEQUALS; }
"-="		{ return MINUSEQUALS; }
"<<="		{ return LSHIFTEQUALS; }
">>="		{ return RSHIFTEQUALS; }
"&="		{ return ANDEQUALS; }
"^="		{ return CARETEQUALS; }
"|="		{ return PIPEEQUALS; }
","		{ return COMMA; }
"#"		{ return HASH; }
"##"		{ return HASHHASH; }

 /* additional punctuators */
"{"		{ return LBRACE; }
"}"		{ return RBRACE; }
";"		{ return SEMICOLON; }
"..."		{ return DOTDOTDOT; }
