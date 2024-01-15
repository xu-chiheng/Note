/*
	This reproducer is taken from https://sourceware.org/bugzilla/show_bug.cgi?id=6443
	Author is Jakub Jelinek <jakub@redhat.com>

	gcc -O2 -pie -fpie -o reproducer6 reproducer6.c
	eu-readelf -d reproducer6 | grep TEXTREL
	test $? -eq 0 && echo FAIL || echo PASS
*/

__thread int a;
__thread int b __attribute((tls_model ("local-exec")));
__thread int c __attribute((tls_model ("initial-exec")));
__thread int d __attribute((tls_model ("local-dynamic")));
__thread int e __attribute((tls_model ("global-dynamic")));

int
main (void)
{
  return a + b + c + d + e;
}
