#include <stdio.h>
#include <dlfcn.h>

void foo(void) __attribute__((visibility("hidden")));
void foo(void) {
    puts("In executable: foo - before forwarding to DSO");
      ((void(*)(void))dlsym(RTLD_DEFAULT,"foo"))();
        puts("In executable: foo - after forwarding to DSO");
}

void bar(void);

int main() {
    foo();
      bar();
}
