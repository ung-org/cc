struct {
const char *mnemonic;
const char *opcode;
char x32;
char x64;
} x86_opcodes[] = {
{ "aaa",	"37", 1, 0 },

{ "aad",	"d5 0a", 1, 0 },
{ "aad imm8",	"db ib", 1, 0 },

{ "aam",	"d4 0a", 1, 0 },
{ "aam imm8",	"d4 ib", 1, 0 },

{ "aas",	"3f" , 1, 0 },

{ "adc al, imm8",	"14 ib", 1, 1 },
{ "adc ax, immm16",	"15 iw", 1, 1 },
{ "adc eax, imm32",	"15 id", 1, 1 },
{ "adc rax, imm32",	"rex.w 15 id", 0, 1 },
{ "adc r/m8, imm8",	"80 /2 ib",  1, 1 },
{ "adc r/m8*, imm8",	"rex 80 /2 ib", 0, 1 },
{ "adc r/m16, imm16",	"81 /2 iw", 1, 1 },
{ "adc r/m32, imm32",	"81 /2 id", 1, 1 },
{ "adc r/m64, imm32",	"rex.w 81 /2 id", 0, 1 },
{ "adc r/m16, imm8",	"83 /2 ib", 1, 1 },
{ "adc r/m32, imm8",	"83 /2 ib", 1, 1 },
{ "adc r/m64, imm8",	"rex.w 83 /2 ib", 0, 1 },
{ "adc r/m8, r8",	"10 /r", 1, 1 },
{ "adc r/m8*, r8*",	"rex 10 /r", 0, 1 },
{ "adc r/m16, r16",	"11 /r", 1, 1 },
{ "adc r/m32, r32",	"11 /r", 1, 1 },
{ "adc r/m64, r64",	"rex.w 11 /r", 0, 1 },
{ "adc r8, r/m8",	"12 /r", 1, 1 },
{ "adc r8*, r/m8*",	"rex 12 /r", 0, 1 },
{ "adc r16, r/m16",	"13 /r", 1, 1 },
{ "adc r32, r/m32",	"13 /r", 1, 1 },
{ "adc r64, r/m64",	"rex.w 13 /r", 0, 1 },
