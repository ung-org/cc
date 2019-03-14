#include <stdio.h>

int main(int argc, char *argv[])
{
	FILE *in = stdin;

	if (argc > 2) {
		printf("usage: %s [file]\n", argv[0]);
		return 1;
	}

	if (argc == 2) {
		in = fopen(argv[1], "r");
		if (in == NULL) {
			perror(argv[1]);
			return 1;
		}
	}

	int c;
	int q = 0;
	while ((c = fgetc(in)) != EOF) {
		if (q == 2) {
			switch (c) {
			case '=':	putchar('#');	break;
			case '/':	putchar('\\');	break;
			case '\'':	putchar('^');	break;
			case '(':	putchar('[');	break;
			case ')':	putchar(']');	break;
			case '!':	putchar('|');	break;
			case '<':	putchar('{');	break;
			case '>':	putchar('}');	break;
			case '-':	putchar('~');	break;
			case '?':	putchar('?');	break;

			default:
				printf("??%c", c);
				break;
			}

			if (c != '?') {
				q = 0;
			}
		} else if (c == '?') {
			q++;
		} else {
			putchar(c);
			q = 0;
		}
	}

	return 0;
}
