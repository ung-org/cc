#ifndef CPP_H
#define CPP_H
#include <stdint.h>

struct macro {
	char *file;
	uintmax_t line;
	char *identifier;
	char *replacement;
	struct macro *next;
};

int preprocess(const char *infile, const char *outfile, struct macro *predefined_list);
struct macro *define(struct macro *list, const char *file, uintmax_t line, const char *macro, const char *replacement);
struct macro *undef(struct macro *list, const char *macro);

#endif
