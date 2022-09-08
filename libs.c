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

static char **libdirs = NULL;
static size_t nlibdirs = 0;

void addlibdir(char *path, int commandline)
{
	libdirs = realloc(libdirs, (nlibdirs + 1) * sizeof(*libdirs));
	if (!libdirs) {
		error(NULL, commandline, "out of memory adding '%s' to library search path\n", path);
	}
	libdirs[nlibdirs++] = path;
}

char *findlib(const char *lib)
{
	char path[PATH_MAX];
	for (size_t i = 0; i < nlibdirs; i++) {
		snprintf(path, sizeof(path), "-l%s/lib%s.a", libdirs[i], lib);
		printf("checking %s\n", path + 2);
		if (access(path + 2, F_OK) == 0) {
			printf("\tOK\n");
			return strdup(path);
		}
	}
	error(NULL, 1, "could not find library -l%s\n", lib);
	return NULL;
}
