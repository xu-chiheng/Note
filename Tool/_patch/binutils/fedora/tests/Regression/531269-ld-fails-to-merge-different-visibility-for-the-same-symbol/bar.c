int foo __attribute__ ((section (".gnu.linkonce.d.1"),
                       visibility ("hidden"))) = 1;
int
__attribute__ ((section (".gnu.linkonce.t.1"), visibility ("hidden")))
bar ()
{
 return 1;
}
int
get_foo ()
{
 return foo;
}
int
get_bar ()
{
 return bar ();
}

