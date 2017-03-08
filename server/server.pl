#!/usr/bin/perl

package Main;

use Carp;
use Crypt::AES::CTR;
use IO::Socket::SSL;
use JSON::MaybeXS;
use List::SomeUtils qw(firstidx);
use strict;
use warnings;

our $VERSION = '1.0';

require Entity::Parser;

use constant START_TRANSFER => 1;
use constant IN_TRANSFER    => 0;
use constant END_TRANSFER   => -1;

$| = 1;

sub isJSON {
    my $str = shift;
    my @chars = split("", $str);

    return $chars[0] eq '{' and $chars[length($str) - 1] eq '}' ? 1 : 0;
}

my $parser = Parser->new();

$parser->parse(@ARGV);

my $server = IO::Socket::SSL->new(
    LocalAddr => 'localhost',
    LocalPort   =>  443,
    Listen => 10,
    SSL_cert_file => 'cert/server.crt',
    SSL_key_file => 'cert/server.key',
);

my(@files, $content, $index);

while (my $client = $server->accept) {
    local $/ = Socket::CRLF;
    my %request = ();
    my %data;

    $client->autoflush(1);

    while (<$client>) {
        chomp;

        if (/\s*(\w+)\s*([^\s]+)\s*HTTP\/(\d.\d)/) {
            $request{METHOD} = uc $1;
            $request{URL} = $2;
            $request{HTTP_VERSION} = $3;
        } elsif (/:/) {
            my($type, $val) = split /:/, $_, 2;

            $type =~ s/^\s+//;
            foreach ($type, $val) {
                s/^\s+//;
                s/\s+$//;
            }

            $request{lc $type} = $val;
        } elsif (/^$/) {
            read($client, $request{CONTENT}, $request{'content-length'})

            if defined $request{'content-length'};
            last;
        }
    }

    if ($request{METHOD} eq 'POST') {
        my $hash = isJSON($request{CONTENT}) eq 1 ? $request{CONTENT} :
            $parser->encryptionKey ? Crypt::AES::CTR::decrypt($request{CONTENT}, $parser->encryptionKey, 256) : $request{CONTENT};

        if (isJSON($hash) eq 1) {
            $content = decode_json $hash;

            if ($content->{state} eq START_TRANSFER) {
                push @files, {id => $content->{id}, file => $content->{file}, buffer => ''};
            } elsif ($content->{state} eq IN_TRANSFER && ($index = firstidx { $_->{id} eq $content->{id} } @files)!= -1) {
                $files[$index]->{buffer} .= $content->{data};
            } elsif ($content->{state} eq END_TRANSFER && ($index = firstidx { $_->{id} eq $content->{id} } @files)!= -1) {
                open my $FILE, '>', $files[$index]->{file} or croak "File [$files[$index]->{file}] cannot be created\n";
                print $FILE $files[$index]->{buffer};
                close $FILE;

                splice(@files, $index);
            }

            print $client 200;
        }
    } else {
        print $client 400;
    }

    close $client;
}
