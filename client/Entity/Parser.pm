#!/usr/bin/perl

package Parser;

use Getopt::Long;
use Moose;
use strict;
use warnings;

has delay => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

has file => (
    is  =>  'rw',
    isa =>  'Str'
);

has dest => (
    is  =>  'rw',
    isa =>  'Str'
);

has help => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

sub parse {
    my $self = shift;
    my @args = @_;

    GetOptions(
        'delay=i' => \$self->{delay},
        'f=s' => \$self->{file},
        'd=s' => \$self->{dest},
        'help|h' => \$self->{help}
    );

    if (scalar @args < 1 || $self->help || !$self->file || !$self->dest) {
        usage()
    }
}

sub usage {
    print "\nusage: unDLP.pl -f FILE -d DESTINATION [--delay DELAY] [--help|h]\n\n";
    print "\t -f: File to transfer.\n";
    print "\t -d: Destination.\n";
    print "\t --delay: Set the transfer speed (second).\n";
    print "\t --help|h: Display the helper.\n";

    exit;
}

1;
