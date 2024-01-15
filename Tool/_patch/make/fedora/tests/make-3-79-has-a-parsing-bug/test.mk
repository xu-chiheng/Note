# Author: Petr Muller <pmuller@redhat.com>

default: out/file.o
%/.exists:
	-mkdir $(@D)
	touch $@
src/file.c: file.l src/.exists
	@echo file.l to $@
	touch $@
out/%.o: src/%.c out/.exists
	@echo -c $< -o $@
	touch $@

