VARIABLE = $(eval VARIABLE := $(shell sleep 1; echo echo ahoj))$(VARIABLE)
wololo:; $(VARIABLE)
