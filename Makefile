.POSIX:

.SILENT: all clean .util.mk

CFLAGS=-std=gnu99 -D_XOPEN_SOURCE=700 -g

all: .util.mk
	make -f .util.mk --no-print-directory

deps: clean .util.mk

clean:
	[ -f .util.mk ] && make -k --no-print-directory -f .util.mk clean || true
	rm -f .util.mk

.util.mk: . Makefile
	printf '.POSIX:\n\n' > $@
	printf '.SUFFIXES: .cat .msg\n\n' >> $@
	printf 'default: all\n\n' >> $@
	printf 'CFLAGS=$(CFLAGS)\n' >> $@
	printf 'UTILITY=%s\n' "$$(basename -s .c $$(grep -l ^main *.c | head -n1))" >> $@
	printf 'SOURCES=%s\n' "$$(ls -1 *.c | tr '\n' ' ')" >> $@
	printf 'HEADERS=%s\n' "$$(ls -1 *.h 2>/dev/null | tr '\n' ' ')" >> $@
	printf 'OBJECTS=%s\n' "$$(ls -1 *.c | sed -e 's/\.c$$/.o/' | tr '\n' ' ')" >> $@
	printf 'L10N=%s\n' "$$(ls -1 *.msg 2>/dev/null | sed -e 's/\.msg$$/\.cat/' | tr '\n' ' ')" >> $@
	printf 'L11N=' >> $@
	sed -ne '/^\/\*\*cat/,/cat\*\*\//p;' *.c | head -n1 | awk '{print $$2 ".cat"}' >> $@
	printf '\n' >> $@
	printf 'all: $$(UTILITY) $$(L10N)\n\n' >> $@
	printf '$$(UTILITY): $$(OBJECTS) $$(HEADERS)\n\n' >> $@
	printf '.msg.cat:\n\tgencat $$@ $$<\n\n' >> $@
	printf ".c.cat:\n\tsed -ne '/^\/\*\*cat/,/cat\*\*\//p;' $$< | grep -v ^/ | grep -v ^\* | gencat \$$@ -\n\n" >> $@
	printf 'clean:\n\trm -f *.o $$(L10N) $$(UTILITY)\n\n' >> $@
