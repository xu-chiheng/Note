all: hello_world

hello_world: hello_world.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm -f hello_world hello_world.o

.SUFFIXES: .c
