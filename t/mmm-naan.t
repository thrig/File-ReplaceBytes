#!perl
#
# Because gmtime() in pp_sys.c had a little goof with "NaN" as input.
# ... and because I wasn't actually checking whether the input could
# pass a SvIOK call.

use strict;
use warnings;

use File::ReplaceBytes;
use Test::Most tests => 2;

open my $fh, '<', 't/testdata' or die "could not read t/testdata: $!\n";

my $buf = '';
my $ret;

$ret = File::ReplaceBytes::pread( $fh, $buf, "Nan", 8 );
ok ( $ret == -1, "NaN to SvIV fails becase SvIOK check" );

# sorry, buzz lightyear
$ret = File::ReplaceBytes::pread( $fh, $buf, "inf", 8 );
ok ( $ret == -1, "not to inf and beyond" );
