#include <stdio.h>
int
main (int argc, char *argv[] __attribute__((unused)))
{
  printf ("%p\n", main);
  return __builtin_popcount (argc);
}
