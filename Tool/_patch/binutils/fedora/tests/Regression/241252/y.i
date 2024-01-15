extern void __assert_fail (const char *, const char *, unsigned int, const char *)
     __attribute__ ((__nothrow__, __noreturn__));

struct gst;
struct gs;

extern void bar (void *) __attribute__ ((__nothrow__));

void bar (void *x)
{
}

typedef int (*gf) (struct gst *, struct gs *,
       const unsigned char **, const unsigned char *,
       unsigned char **, unsigned long *, int, int);

struct gst
{
  gf fct;
  int min_needed_from;
};

struct gs
{
  unsigned char *outbuf;
  unsigned char *outbufend;
  int flags;
  int invocation_counter;
  int internal_use;
};

typedef struct gi
{
  unsigned long nsteps;
  struct gst *steps;
  struct gs data [10];
} *gt;

int
baz (gt cd, const unsigned char **inbuf,
  const unsigned char *inbufend, unsigned char **outbuf,
  unsigned char *outbufend, unsigned long *irreversible)
{
  unsigned long last_step;
  int result;
  last_step = cd->nsteps - 1;
  *irreversible = 0;
  cd->data[last_step].outbuf = outbuf != ((void *)0) ? *outbuf : ((void *)0);
  cd->data[last_step].outbufend = outbufend;
  gf fct = cd->steps->fct;
  if (inbuf == ((void *)0) || *inbuf == ((void *)0))
    result = (bar ((void *) (fct)), (*(fct)) (cd->steps, cd->data, ((void *)0), ((void *)0), ((void *)0), irreversible, cd->data[last_step].outbuf == ((void *)0) ? 2 : 1, 0));
  else
    {
      const unsigned char *last_start;
      ((outbuf != ((void *)0) && *outbuf != ((void *)0)) ? (void) (0) : __assert_fail ("outbuf != ((void *)0) && *outbuf != ((void *)0)", "gconv.c", 67, "foo"));
      do
	{
	  last_start = *inbuf;
	  result = (bar ((void *) (fct)), (*(fct)) (cd->steps, cd->data, inbuf, inbufend, ((void *)0), irreversible, 0, 0));
	}
      while (result == 4 && last_start != *inbuf
      && *inbuf + cd->steps->min_needed_from <= inbufend);
    }
  return result;
}

int
main (void)
{
}
