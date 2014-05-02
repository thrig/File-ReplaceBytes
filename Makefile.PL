#!perl

use 5.010000;

use strict;
use warnings;
use ExtUtils::MakeMaker;

# TODO no idea if pread/pwrite available, maybe if someone has the time
# and can provide patches...
if ( $^O =~ m/MSWin32/ ) {
  print "Sorry, no automated install is available on Windows.\n";
  exit(0);
}

my %params = (
  NAME         => 'File::ReplaceBytes',
  VERSION_FROM => 'lib/File/ReplaceBytes.pm',
  PREREQ_PM    => {},
  ( $] >= 5.005
    ? (
      ABSTRACT_FROM => 'lib/File/ReplaceBytes.pm',
      AUTHOR        => 'Jeremy Mates <jmates@cpan.org>'
      )
    : ()
  ),
  LIBS   => [''],     # e.g., '-lm'
  DEFINE => '',       # e.g., '-DHAVE_SOMETHING'
  INC    => '-I.',    # e.g., '-I. -I/usr/include/other'
                      # Un-comment this if you add C files to link with later:
       # OBJECT            => '$(O_FILES)', # link all the C files too
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
  $params{LICENSE} = 'perl';
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.46' ) {
  $params{META_MERGE} = {
    resources => {
      homepage   => 'http://github.com/thrig/File-ReplaceBytes',
      license    => 'http://dev.perl.org/licenses/',
      repository => 'http://github.com/thrig/File-ReplaceBytes',
    }
  };
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.48' ) {
  $params{MIN_PERL_VERSION} = 5.010000;
  # TODO when was this added? or do the mauke method and build
  # everything but only subtract things for legacy ExtUtils::MakeMaker
  # support?
  $params{BUILD_REQUIRES} = { 'Test::More' => 0, 'Test::Exception' => 0 };
}

WriteMakefile((MM->can('signature_target') ? (SIGN => 1) : ()), %params);
