#!perl

use strict;
use warnings;

use Test::More;    # plan is down at bottom
use Test::Exception;

eval 'use Test::Differences';    # display convenience
my $deeply = $@ ? \&is_deeply : \&eq_or_diff;

########################################################################
#
# Fundamentals

BEGIN { use_ok('File::ReplaceBytes') }

can_ok( 'File::ReplaceBytes', qw/pread pwrite/ );

########################################################################
#
# pread

open my $fh, '<', 't/testdata' or die "could not read t/testdata: $!";

my $buf = '';
my $st = File::ReplaceBytes::pread( $fh, $buf, 8, 8 );
$deeply->( [ $buf, $st ], [ 'bbbbbbbb', 8 ], 'read bx8' );

my $at = sysseek( $fh, 0, 1 );
ok( $at == 0, 'no position change after read' );

# and where pread from should not be influenced by position...
sysseek( $fh, 4, 0 );
$buf = '';
$st = File::ReplaceBytes::pread( $fh, $buf, 8, 7 );
$deeply->( [ $buf, $st ], [ 'abbbbbbb', 8 ], 'read after seek()' );

$buf = undef;
$st = File::ReplaceBytes::pread( $fh, $buf, 7, 6 );
$deeply->( [ $buf, $st ], [ 'aabbbbb', 7 ], 'read into undef scalar' );

undef $fh;
$buf = '';
throws_ok(
  sub { File::ReplaceBytes::pread( $fh, $buf, 7, 6 ) },
  qr/undefined value as filehandle reference/,
  'bad filehandle'
);

# TODO way to detect in-memory fh vs. those that point to files? so can
# skip or issue error? Because pread on such... well, yeah. no.
# Devel::Peek shows no obvious differences between this and a file
# filehandle. (but could also be a socket, or who knows, probably just
# best to warn in the docs "must be file filehandle, here's your loaded
# shotgun, good luck!")
#my $data = 'aaaaaaaabbbbbbbbcccccccc';
#open my $imfh, '<', \$data;

########################################################################
#
# pwrite

# TODO copy test data to file, then pwrite, then confirm file contents
# are what expect to see
open $fh, '+<', 'out' or die "could not write 'out': $!";

my $to_write = "a" x 16;
my $write_offset = 8;
$st = File::ReplaceBytes::pwrite( $fh, $to_write, 0, $write_offset );
is( $st, length $to_write, 'pwrite some bytes' );
$at = sysseek( $fh, 0, 1 );
ok( $at == 0, 'should be no filehandle position change' );

# TODO might be fs sync problems if pwrite data tardy getting to disk?

open my $readout, '<', 'out' or die "could not read 'out': $!";
seek($readout, $write_offset, 0);
my $written = do { local $/ = undef; readline $readout };
is($to_write, $written, 'read what expected to write');

# reset
open $fh, '>', 'out' or die "could not trucate 'out': $!";

plan tests => 10;
