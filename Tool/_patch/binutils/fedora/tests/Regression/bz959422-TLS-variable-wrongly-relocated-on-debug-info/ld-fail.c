#include <pthread.h>

__thread const char *tls_var = "hello";

int main ()
{
  return 0;
}
