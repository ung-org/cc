#ifndef CPP_H
#define CPP_H
#include <stdio.h>

int preprocess(FILE *in, FILE *out, long int version);
void define(const char *macro, const char *replacement);
void undef(const char *macro);
int defined(const char *macro);
void include(const char *path);

#endif
