#include <bfd.h>

#include "libbfdtest.h"

int
libbfdtest (void)
{
  bfd_set_error (bfd_error_no_error);
  return bfd_get_error () == bfd_error_no_error;
}
