CC=gcc
CFLAGS=-g -Wall

all: test

libbfdtest.so bfdtest: Makefile

libbfdtest.so: libbfdtest.c libbfdtest.h
	$(CC) $(CFLAGS) -shared -o $@ -fPIC $< -lbfd -liberty

bfdtest: bfdtest.c libbfdtest.h libbfdtest.so
	$(CC) -o $@ $< -L. -Wl,-rpath,.  -lbfdtest -ldl

.PHONY: test
test: bfdtest
	./$<
	@echo OK

clean:
	$(RM) libbfdtest.so bfdtest

