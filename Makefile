.POSIX:

CFLAGS=-g -D_POSIX_C_SOURCE=200809L
YFLAGS=-d 
LIBS=-ly -ll
PROGRAM=cc
SYMLINKS=c89 c99 lint cflow ctags
OBJECTS=main.o trigraph.o cpp.tab.o link.o
GENERATED=trigraph.c *.tab.c *.tab.h

all: $(PROGRAM) $(SYMLINKS)

$(SYMLINKS): $(PROGRAM)
	ln -s $(PROGRAM) $@

cpp.tab.c cpp.tab.h: cpp.y
	$(YACC) $(YFLAGS) -p cpp -b cpp cpp.y

cc: $(OBJECTS)
	$(CC) -o $@ $(OBJECTS) $(LIBS)

clean:
	rm -f $(PROGRAM) $(SYMLINKS) $(GENERATED) *.o
