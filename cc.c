#define _XOPEN_SOURCE 700
#include <errno.h>
#include <libgen.h>
#include <limits.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <unistd.h>

#include "cc.h"
#include "libs.h"
#include "cpp.h"
#include "link.h"
#include "version.h"

void error(const char *file, uintmax_t line, const char *fmt, ...)
{
	if (file) {
		fprintf(stderr, "%s:%ju: ", file, line);
	} else if (line == 0) {
		fprintf(stderr, "<BUILTIN>: ");
	} else {
		fprintf(stderr, "<COMMAND LINE>: ");
	}

	va_list ap;
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
	exit(1);
}

static struct macro *do_predefs(const char *argv0)
{
	long int version = LATEST;
	char *fullname = strdup(argv0);
	char *progname = basename(fullname);

	struct macro *defs = define(NULL, NULL, 0, "__STDC__", "1");

	if (!strcmp(progname, "c18")) {
		version = C18;
	} else if (!strcmp(progname, "c11")) {
		/* warn */
		version = C11;
	} else if (!strcmp(progname, "c99")) {
		version = C99;
	} else if (!strcmp(progname, "c89")) {
		version = C95;
	}

	if (version >= C95) {
		char ppversion[8] = "";
		sprintf(ppversion, "%ldL", version);
		define(defs, NULL, 0, "__STDC_VERSION__", ppversion);
	}
	
	if (version >= C99) {
		define(defs, NULL, 0, "__STDC_HOSTED__", "1");
		define(defs, NULL, 0, "__STDC_IEC_559__", "1");
		define(defs, NULL, 0, "__STDC_IEC_559_COMPLEX__", "1");
		define(defs, NULL, 0, "__STDC_ISO_10646__", ISO_10646_VERSION);
	}

	if (version >= C11) {
		define(defs, NULL, 0, "__STDC_UTF_16__", "1");
		define(defs, NULL, 0, "__STDC_UTF_32__", "1");
		define(defs, NULL, 0, "__STDC_ANALYZABLE__", "1");
		define(defs, NULL, 0, "__STDC_LIB_EXT1__", "1");
		/* __STDC_NO_ATOMICS__ */
		/* __STDC_NO_COMPLEX__ */
		/* __STDC_NO_THREADS__ */
		/* __STDC_NO_VLA__ */
	}

	return defs;
}

static int getoptarg(char *argv[], int i, char **arg)
{
	if (argv[i][2] != '\0') {
		*arg = argv[i] + 2;
		return 0;
	}
	*arg = argv[i + 1];
	return 1;
}

int main(int argc, char *argv[])
{
	enum { PREPROCESSED, ASSEMBLY, OBJECT, BINARY } output = BINARY;
	char *output_path = "a.out";
	char *inputs[argc];
	int ninputs = 0;

	struct macro *predef = do_predefs(argv[0]);

	for (int i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "-c")) {
			output = OBJECT;

		} else if (!strcmp(argv[i], "-g")) {
			/* include debugging symbols */

		} else if (!strcmp(argv[i], "-s")) {
			/* strip */

		} else if (!strcmp(argv[i], "-E")) {
			output = PREPROCESSED;

		} else if (!strncmp(argv[i], "-o", 2)) {
			i += getoptarg(argv, i, &output_path);

		} else if (!strncmp(argv[i], "-D", 2)) {
			char *macro = NULL;
			i += getoptarg(argv, i, &macro);
			char *eq = strchr(macro, '=');
			if (eq) {
				*eq = '\0';
				eq++;
			}
			define(predef, NULL, 1, macro, eq ? eq : "1");

		} else if (!strncmp(argv[i], "-I", 2)) {
			char *path = NULL;
			i += getoptarg(argv, i, &path);
			//include(path);

		} else if (!strncmp(argv[i], "-L", 2)) {
			/* TODO: add to inputs[] */
			char *path = NULL;
			i += getoptarg(argv, i, &path);
			addlibdir(path, 1);

		} else if (!strncmp(argv[i], "-O", 2)) {
			/* optimize */

		} else if (!strncmp(argv[i], "-U", 2)) {
			char *macro = NULL;
			i += getoptarg(argv, i, &macro);
			//undef(macro);

		} else if (!strncmp(argv[i], "-l", 2)) {
			/* TODO: add to inputs[] */
			char *lib = NULL;
			i += getoptarg(argv, i, &lib);
			inputs[ninputs++] = findlib(lib);

		} else if (argv[i][0] == '-') {
			error(NULL, 1, "unknown options '%s'\n", argv[i]);

		} else {
			inputs[ninputs++] = argv[i];
		}
	}

	for (int i = 0; i < ninputs; i++) {
		if (!strcmp(inputs[i], "")) {
			continue;
		}

		fprintf(stderr, "%s\n", inputs[i]);

		//preprocess
		//compile
		//analyze
		//optimize
		//assemble

		switch (output) {
		case PREPROCESSED:
			preprocess(inputs[i], output_path, predef);
			break;
		default:
			break;	
		}
	}

	//optimize?
	//link
	//strip
}
