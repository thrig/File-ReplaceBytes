#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

MODULE = File::ReplaceBytes             PACKAGE = File::ReplaceBytes            

long
pread(PerlIO *fh, SV *buf, ...)
  PROTOTYPE: $$$;$
  PREINIT:
    unsigned long len    = 0;
    unsigned long offset = 0;

  CODE:
    if( items > 2 ) {
        if (SvIV(ST(2)) < 0) {
            errno = EINVAL;
            XSRETURN_IV(-1);
        }
        len = SvIV(ST(2));
    }
/* emulate pread not complaining if nothing to read */
    if (len == 0)
        XSRETURN_IV(0);
    if( items > 3 ) {
        if (SvIV(ST(3)) < 0) {
            errno = EINVAL;
            XSRETURN_IV(-1);
        }
        offset = SvIV(ST(3));
    }

    if(!SvOK(buf)) 
        sv_setpvn(buf, "", 0);

    RETVAL = pread(PerlIO_fileno(fh), SvGROW(buf, len), len, offset);
    SvCUR_set(buf, len);
    SvTAINTED_on(buf);

  OUTPUT:
    buf
    RETVAL

long
pwrite(PerlIO *fh, SV *buf, ...)
  PROTOTYPE: $$;$$
  PREINIT:
    unsigned long len = 0;
    unsigned long offset = 0;

  CODE:
/* pwrite(2) does not complain if nothing to write, so emulate that */
    if(!SvOK(buf) || SvCUR(buf) == 0)
        XSRETURN_IV(0);
/* length, offset are optional, but offset demands that length also be
 * set by the caller */
    if( items > 2 ) {
        if (SvIV(ST(2)) < 0) {
            errno = EINVAL;
            XSRETURN_IV(-1);
        }
        len = SvIV(ST(2));
    }
    if( items > 3 ) {
        if (SvIV(ST(3)) < 0) {
            errno = EINVAL;
            XSRETURN_IV(-1);
        }
        offset = SvIV(ST(3));
    }

    if (len == 0 || len > SvCUR(buf))
        len = SvCUR(buf);

    RETVAL = pwrite(PerlIO_fileno(fh), SvPV(buf, len), len, offset);

  OUTPUT:
    RETVAL

long
replacebytes(SV *filename, SV *buf, ...)
  PROTOTYPE: $$;$
  PREINIT:
    unsigned long offset = 0;

  CODE:
    int fd;

    if(!SvOK(buf) || SvCUR(buf) == 0)
        XSRETURN_IV(0);
    if( items > 2 ) {
        if (SvIV(ST(2)) < 0) {
            errno = EINVAL;
            XSRETURN_IV(-1);
        }
        offset = SvIV(ST(2));
    }

    if((fd = open(SvPV_nolen(filename), O_WRONLY)) == -1)
        XSRETURN_IV(-1);

    RETVAL = pwrite(fd, SvPV_nolen(buf), SvCUR(buf), offset);

  OUTPUT:
    RETVAL
