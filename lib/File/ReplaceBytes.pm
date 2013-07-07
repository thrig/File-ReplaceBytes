# -*- Perl -*-

package File::ReplaceBytes;

use 5.010000;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

our @EXPORT_OK = qw/pread pwrite todo/;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load( 'File::ReplaceBytes', $VERSION );

1;
__END__

=head1 NAME

File::ReplaceBytes - replaces arbitrary bytes in files

=head1 SYNOPSIS

  use File::ReplaceBytes;
  TODO

=head1 DESCRIPTION

TODO

=head1 EXPORTS

=head1 SEE ALSO

L<dd(1)>, L<hexdump(1)>, L<pread(2)>, L<pwrite(2)>

=head1 AUTHOR

Jeremy Mates, E<lt>jmates@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Jeremy Mates

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.18 or, at
your option, any later version of Perl 5 you may have available.

=cut
