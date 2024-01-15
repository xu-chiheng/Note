#include <stdlib.h>
#include <stdio.h>

static __thread int a;
static int *c;

int main(int argc, char *argv[])
{
 a = 2;
 c = &a;
 printf("c=%d\n", *c);
 return 0;
}
