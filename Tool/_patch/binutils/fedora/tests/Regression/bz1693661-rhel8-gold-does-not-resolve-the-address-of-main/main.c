#include <stdio.h>
extern int foo(int, int);

int main()
{
  printf("%d\n", foo(1, 3));
  return 0;
}
