#!perl
#
# Because gmtime() in pp_sys.c had a little goof with "NaN" as input.

use strict;
use warnings;

use Test::More;    # plan is down at bottom

eval 'use Test::Differences';    # display convenience
my $deeply = $@ ? \&is_deeply : \&eq_or_diff;

use File::ReplaceBytes;

open my $fh, '<', 't/testdata' or die "could not read t/testdata: $!\n";

my $buf = '';
my $st = File::ReplaceBytes::pread( $fh, $buf, "Nan", 8 );
ok ( $st == 0, "NaN to SvIV becomes zero" );

plan tests => 1;
