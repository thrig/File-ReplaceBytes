#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/* TODO figure out TYPEMAP for len, offset and use Off_t or whatnot
 * for those? */

/* TODO figure out pTHX_ to support threads enabled? get "Could not find
 * a typemap for C type 'pTHX_ PerlIO ..." if prefix that macro. */

MODULE = File::ReplaceBytes             PACKAGE = File::ReplaceBytes            

int
pread(PerlIO *fh, SV *buf, unsigned long len, ...)
  PREINIT:
    unsigned long offset = 0;

  CODE:
    if(!SvOK(buf)) 
        sv_setpvn(buf, "", 0);
    if( items > 3 )
        offset = SvIV(ST(3));

    RETVAL = pread(PerlIO_fileno(fh), SvGROW(buf, len), len, offset);
    SvCUR_set(buf, len);

  OUTPUT:
    buf
    RETVAL

int
pwrite(PerlIO *fh, SV *buf, ...)
  PREINIT:
    unsigned long len = 0;
    unsigned long offset = 0;

  CODE:
/* pwrite(2) does not complain if nothing to write, so emulate that */
    if(!SvOK(buf))
        XSRETURN_IV(0);
/* length, offset are optional, but offset demands that length also be
 * set by the caller */
    if( items > 2 )
        len = SvIV(ST(2));
    if( items > 3 )
        offset = SvIV(ST(3));

    if (len == 0 || len > SvCUR(buf))
        len = SvCUR(buf);

    RETVAL = pwrite(PerlIO_fileno(fh), SvPV(buf, len), len, offset);

  OUTPUT:
    RETVAL
