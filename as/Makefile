as: as.yy.o as.tab.o
	c99 -o $@ as.yy.o as.tab.o -ly -ll

as.yy.c: as.l as.tab.h
	lex -t as.l > $@

as.tab.h as.tab.c: as.y
	yacc -d -b as as.y

clean:
	rm -f as *.o as.yy.c as.tab.c as.tab.h
