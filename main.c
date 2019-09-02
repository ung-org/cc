#define _XOPEN_SOURCE 700
#include <errno.h>
#include <libgen.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "cpp.h"
#include "link.h"
#include "trigraph.h"
#include "version.h"

static char **sources = NULL;
size_t nsources = 0;

static char **objects = NULL;
size_t nobjects = 0;

void compile(FILE *in, FILE *out, long int version)
{
	printf("compiling\n");
}

void assemble(FILE *in, FILE *out)
{
	printf("assembling\n");
}

long int setversion(const char *progname)
{
	long int version = LATEST;

	define("__STDC__", "1");
	/* define("__FILE__", argv[optind]); */
	/* define("__DATE__", (char*)-1); */
	/* define("__TIME__", (char*)-1); */

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

	/* if (!defined("__STDC_VERSION__") { */
	/* 	version = C89; */
	/* } */

	/* if (!defined("__STDC__")) { */
	/* 	version = KNR; */
	/* } */

	if (version >= C95) {
		char ppversion[8] = "";
		sprintf(ppversion, "%dL", version);
		define("__STDC_VERSION__", ppversion);
	}
	
	if (version >= C99) {
		define("__STDC_HOSTED__", "1");
		define("__STDC_IEC_559__", "1");
		define("__STDC_IEC_559_COMPLEX__", "1");
		define("__STDC_ISO_10646__", ISO_10646_VERSION);
	}

	if (version >= C11) {
		define("__STDC_UTF_16__", "1");
		define("__STDC_UTF_32__", "1");
		define("__STDC_ANALYZABLE__", "1");
		define("__STDC_LIB_EXT1__", "1");
		/* __STDC_NO_ATOMICS__ */
		/* __STDC_NO_COMPLEX__ */
		/* __STDC_NO_THREADS__ */
		/* __STDC_NO_VLA__ */
	}

	return version;
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

void addobj(char *path)
{
	nobjects++;
	objects = realloc(objects, sizeof(*objects) * nobjects);
	objects[nobjects - 1] = path;

	printf("adding '%s' to list of objects\n", path);
}

void addsource(char *path)
{
	nsources++;
	sources = realloc(sources, sizeof(*sources) * nsources);
	sources[nsources - 1] = path;
	
	printf("adding '%s' to list of source files\n", path);

	char obj[strlen(path) + 1];
	strcpy(obj, path);
	obj[strlen(obj) - 1] = 'o';
	addobj(obj);
}

int main(int argc, char *argv[])
{
	int cpp_stdout = 0;
	int skip_linking = 0;
	char *progname = basename(argv[0]);
	char *output = "a.out";

	/* special cases for different program names */
	if (!strcmp(progname, "lint")) {
	} else if (!strcmp(progname, "cflow")) {
	} else if (!strcmp(progname, "ctags")) {
	}

	for (int i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "-c")) {
			skip_linking = 1;

		} else if (!strcmp(argv[i], "-g")) {
			/* include debugging symbols */

		} else if (!strcmp(argv[i], "-s")) {
			/* strip */

		} else if (!strcmp(argv[i], "-E")) {
			cpp_stdout = 1;

		} else if (!strncmp(argv[i], "-o", 2)) {
			i += getoptarg(argv, i, &output);

		} else if (!strncmp(argv[i], "-D", 2)) {
			char *macro = NULL;
			i += getoptarg(argv, i, &macro);
			char *eq = strchr(macro, '=');
			if (eq) {
				*eq = '\0';
				eq++;
			}
			define(macro, eq ? eq : "1");

		} else if (!strncmp(argv[i], "-I", 2)) {
			char *path = NULL;
			i += getoptarg(argv, i, &path);
			include(path);

		} else if (!strncmp(argv[i], "-L", 2)) {
			char *path = NULL;
			i += getoptarg(argv, i, &path);
			libpath(path);

		} else if (!strncmp(argv[i], "-O", 2)) {
			/* optimize */

		} else if (!strncmp(argv[i], "-U", 2)) {
			char *macro = NULL;
			i += getoptarg(argv, i, &macro);
			undef(macro);

		} else if (!strncmp(argv[i], "-l", 2)) {
			char *lib = NULL;
			i += getoptarg(argv, i, &lib);
			addobj(lib);

		} else if (argv[i][0] == '-') {
			fprintf(stderr, "%s: unknown option %s\n", progname, argv[i]);
			/* invalid option */
		} else {
			addsource(argv[i]);
		}
	}

	long int version = setversion(progname);

	for (size_t i = 0; i < nsources; i++) {
		printf("compiling '%s'\n", sources[i]);
		FILE *in = fopen(sources[i], "r");
		if (in == NULL) {
			fprintf(stderr, "%s: %s: %s\n", progname, sources[i], strerror(errno));
			continue;
		}
		FILE *out = tmpfile();
		if (out == NULL) {
			fprintf(stderr, "%s: tmpfile(): %s\n", progname, strerror(errno));
			continue;
		}

		char *dot = strrchr(sources[i], '.');
		if (!dot || strlen(dot) != 2) {
			fprintf(stderr, "%s: don't know what to do with %s\n", progname, sources[i]);
			return 1;
		}

		define("__FILE__", sources[i]);
		switch (dot[1]) {
		case 'c':
			trigraph(in, out);

			fclose(in);
			in = out;
			rewind(in);

			if (cpp_stdout) {
				out = stdout;
			} else {
				out = tmpfile();
			}
			preprocess(in, out, version);
			if (cpp_stdout) {
				break;
			}

			fclose(in);
			in = out;
			rewind(in);
			out = tmpfile();
			/* FALLTHRU */

		case 'i':
			compile(in, out, version);
			/* if (-S) break; */

			fclose(in);
			in = out;
			rewind(in);
			out = tmpfile();
			/* FALLTHRU */

		case 's':
			assemble(in, out);
			break;

		case 'a':
		case 'o':
			/* just link at the end */
			break;

		default:
			fprintf(stderr, "%s: unknown file type %s\n", progname, sources[i]);
		}
	}

	/* link(outfile, nobjects, objects); */
}
