#!/usr/bin/perl

package ExfiltrationEngine;

use Moose;
use strict;
use warnings;

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

sub loadFile {
    my $self = shift;

    open $self->{file}, '<', $self->file or die $!;
}

1;
