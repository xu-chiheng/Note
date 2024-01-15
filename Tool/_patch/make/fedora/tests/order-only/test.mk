all: ./a/b/c a

clean:
	rm -rf a dir

%/.:
	mkdir -p $(@)

a/%/c: | ./dir/%/.
	@echo "@ [$@]"
	@echo "^ [$^]"
	@echo "? [$?]"

a: | ./a/b/.
	@echo "@ [$@]"
	@echo "^ [$^]"
	@echo "? [$?]"
