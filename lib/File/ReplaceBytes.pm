# -*- Perl -*-

package File::ReplaceBytes;

use 5.010000;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw/pread pwrite replacebytes/;

our $VERSION = '0.03';

require XSLoader;
XSLoader::load( 'File::ReplaceBytes', $VERSION );

# see *.xs for the code

1;
__END__

=head1 NAME

File::ReplaceBytes - read or replace arbitrary data in files

=head1 SYNOPSIS

  use File::ReplaceBytes qw(pread pwrite replacebytes);

  open my $fh, '+<', $file or die "cannot open $file: $!\n";

  # read 16 bytes at offset of 8 bytes into $buf
  my $buf;
  pread($fh, $buf, 16, 8);

  # write these bytes out in various locations to same file
  pwrite($fh, $buf);        # at beginning of file
  pwrite($fh, $buf, 4);     # write just 4 bytes of $buf
  pwrite($fh, $buf, 0, 32); # all of $buf at 32 bytes into file

  # these two are equivalent
  pwrite($fh, $buf, 0);
  pwrite($fh, $buf, length $buf);

  replacebytes('somefile', $buf, 42);

=head1 DESCRIPTION

This module employs the L<pread(2)> and L<pwrite(2)> system calls to
perform highly unsavory operations on files. These calls do not update
the filehandle position reported by C<sysseek($fh,0,1)>, and will
doubtless cause problems if mixed with any sort of buffered I/O. The
filehandles used MUST be file-based filehandles, and MUST NOT be
in-memory filehandles or sockets... look, I warned you.

=head1 EXPORTS

=head2 pread

  pread(FH,BUF,LENGTH)
  pread(FH,BUF,LENGTH,OFFSET)

FH must be a file handle, BUF a scalar, LENGTH how many bytes to
read into BUF, and optionally, how far into the filehandle to start
reading at. The call may throw an exception (e.g. if FH is
C<undef>), or otherwise will return the number of bytes read, or 0
if EOF, or -1 on error.

=head2 pwrite

  pwrite(FH,BUF)
  pwrite(FH,BUF,LENGTH)
  pwrite(FH,BUF,LENGTH,OFFSET)

FH must be a file handle, BUF a scalar, whose LENGTH will be written, or
otherwise a specified LENGTH number of bytes--but not beyond that of
BUF, because that would be so very naughty--optionally at the specified
OFFSET in bytes. If LENGTH is 0, the contents of BUF will be written.
The call may throw an exception if FH is C<undef>. The return value is
the number of bytes written, or -1 on error.

=head2 replacebytes

  replacebytes(FILENAME,BUF)
  replacebytes(FILENAME,BUF,OFFSET)

Accepts a filename and scalar buffer, and writes the buffer to the
specified offset (zero if not specified) in the said file. Does not use
PerlIO like the C<p*> routines do, instead performs a direct L<open(2)>
call on the filename.

=head1 CAVEATS

Everything mentioned above plus yet more besides.

=head1 SECURITY CONSIDERATIONS

This module MUST NOT be used if untrusted user input can influence how
the file handles are created, as who knows what the C<p*> system calls
will do with whatever C<fileno> value Perl returns for some socket or
in-memory data filehandle?

=head1 SEE ALSO

L<dd(1)>, L<hexdump(1)>, L<pread(2)>, L<pwrite(2)> and your backups. You
have backups, right? Backups are nice.

=head1 AUTHOR

Jeremy Mates, E<lt>jmates@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Jeremy Mates

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.18 or, at
your option, any later version of Perl 5 you may have available.

=cut
