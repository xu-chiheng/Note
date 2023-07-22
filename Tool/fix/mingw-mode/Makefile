
all : install

/mingw64/lib/%.o : %.o
	cp -rf $< $$(dirname $@)
/ucrt64/lib/%.o : %.o
	cp -rf $< $$(dirname $@)

%.o : %.c
	gcc -c -O2 -o $@ $<

# clean :
# 	rm -rf binmode.o commode.o

uninstall :
	rm -rf {/mingw64,/ucrt64}/lib/{binmode.o,commode.o}

install : /mingw64/lib/binmode.o /mingw64/lib/commode.o /ucrt64/lib/binmode.o /ucrt64/lib/commode.o
