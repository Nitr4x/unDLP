#!/usr/bin/perl

package ExfiltrationEngine;

use Moose;

has delay => (
    is  =>  'rw',
    isa =>  'Int'
);

has dest => (
    is  =>  'rw',
    isa =>  'Str'
);

has file => (
    is  =>  'rw'
);

has size => (
    is  =>  'rw',
    isa =>  'Int'
);

sub load {
    my($self, $file) = @_;

    open $self->{file}, '<', $file or die $!;
    binmode $self->file;
}

sub close {
    my $self = shift;

    close($self->file);
}

1;
