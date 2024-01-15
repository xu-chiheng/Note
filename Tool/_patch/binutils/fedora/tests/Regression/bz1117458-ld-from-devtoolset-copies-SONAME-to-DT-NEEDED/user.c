#include <stdio.h>

extern int foo(void);

int main(void) {
	int a = foo();
	printf("a is %d\n", a);
	return 0;
}
