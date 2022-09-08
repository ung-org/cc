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


static char *system_dirs[] = {
	"/lib/x86_64-linux-gnu",
	"/usr/lib/x86_64-linux-gnu",
	"/usr/local/lib/x86_64-linux-gnu",
};
static size_t nsystem_dirs = sizeof(system_dirs) / sizeof(system_dirs[0]);

static char **user_dirs = NULL;
static size_t nuser_dirs = 0;

void addlibdir(char *path, int commandline)
{
	user_dirs = realloc(user_dirs, (nuser_dirs + 1) * sizeof(*user_dirs));
	if (!user_dirs) {
		error(NULL, commandline, "out of memory adding '%s' to library search path\n", path);
	}
	user_dirs[nuser_dirs++] = path;
}

static char *do_findlib(size_t ndirs, char *dirs[static ndirs], size_t plen, char path[static plen], const char *lib)
{
	for (size_t i = 0; i < ndirs; i++) {
		snprintf(path, plen, "-l%s/lib%s.a", dirs[i], lib);
		printf("checking %s\n", path + 2);
		if (access(path + 2, F_OK) == 0) {
			printf("\tOK\n");
			return path;
		}
	}
	return NULL;
}

char *findlib(const char *lib)
{
	static char path[PATH_MAX];
	if (do_findlib(nsystem_dirs, system_dirs, sizeof(path), path, lib)) {
		return path;
	}
	if (do_findlib(nuser_dirs, user_dirs, sizeof(path), path, lib)) {
		return path;
	}
	error(NULL, 1, "could not find library -l%s\n", lib);
	return NULL;
}
