#include <stdio.h>

void foo(void);
void bar(void) {
    puts("In DSO: bar");
      foo();
}
