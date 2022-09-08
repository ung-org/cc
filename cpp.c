#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "cc.h"
#include "cpp.h"

static void dump(struct macro *list)
{
	for (struct macro *p = list; p != NULL; p = p->next) {
		if (p->file) {
			printf("%s:%ju: ", p->file, p->line);
		} else if (p->line == 0) {
			printf("<BUILTIN>: ");
		} else {
			printf("<COMMAND LINE>: ");
		}
		printf("'%s' => '%s'\n", p->identifier, p->replacement);
	}
}

int preprocess(const char *in, const char *out, struct macro *predefined)
{
	(void)in; (void)out;
		
	time_t now = time(NULL);
	struct tm *tm = localtime(&now);
	char compiletime[16] = { 0 };
	char compiledate[16] = { 0 };
	strftime(compiletime, sizeof(compiletime), "%T", tm);
	strftime(compiledate, sizeof(compiledate), "%b %e %Y", tm);

	struct macro *perfile = define(NULL, NULL, 0, "__DATE__", compiledate);
	define(perfile, NULL, 0, "__TIME__", compiletime);
	define(perfile, NULL, 0, "__FILE__", in);
	define(perfile, NULL, 0, "__LINE__", "0");

	dump(predefined);
	dump(perfile);

	return 0;
}

static struct macro *do_define(struct macro *list, const char *file, uintmax_t line, const char *macro, const char *replacement)
{
	struct macro *def = list;

	/* TODO: replace existing thing */
	/* TODO: prevent redefining builtins */

	if (def == NULL) {
		def = calloc(1, sizeof(*def));
		list = def;
	} else {
		while (def->next != NULL) {
			def = def->next;
		}
		def->next = calloc(1, sizeof(*def));
		def = def->next;
	}

	if (def == NULL) {
		return NULL;
	}

	if (file) {
		def->file = strdup(file);
		if (file == NULL) {
			return NULL;
		}
	}
	def->line = line;
	def->identifier = strdup(macro);
	def->replacement = strdup(replacement);
	if (def->identifier == NULL || def->replacement == NULL) {
		return NULL;
	}

	return list;
}

struct macro *define(struct macro *list, const char *file, uintmax_t line, const char *macro, const char *replacement)
{
	list = do_define(list, file, line, macro, replacement);
	if (list == NULL) {
		error(file, line, "out of memory defining macro");
	}
	return list;
}
