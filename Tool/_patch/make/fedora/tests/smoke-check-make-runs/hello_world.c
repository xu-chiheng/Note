#include <stdio.h>

int main(int argc, char ** argv) {
	if (printf("Hello world!\n") < 0) {
		return -1;
	}
	return 0;
}
