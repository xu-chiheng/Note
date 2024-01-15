int foo __attribute__ ((section (".gnu.linkonce.d.1"))) = 1;
int
__attribute__ ((section (".gnu.linkonce.t.1")))
bar ()
{
 return 1;
}
