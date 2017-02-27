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

has dest => (
    is  =>  'rw',
    isa =>  'Str'
);

has file => (
    is  =>  'rw',
    isa =>  'Str'
);

has help => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

has size => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  1024
);

sub parse {
    my $self = shift;
    my @args = @_;

    GetOptions(
        'f=s' => \$self->{file},
        'd=s' => \$self->{dest},
        'delay=i' => \$self->{delay},
        'size=i' => \$self->{size},
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
    print "\t --size: Set the transfer size.\n";
    print "\t --delay: Set the transfer speed (second).\n";
    print "\t --help|h: Display the helper.\n";

    exit;
}

1;
