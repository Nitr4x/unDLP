#!/usr/bin/perl

package ExfiltrationEngine;

use Moose;

has file => (
    is  =>  'rw'
);

has dest => (
    is  =>  'rw',
    isa =>  'Str'
);

has delay => (
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
