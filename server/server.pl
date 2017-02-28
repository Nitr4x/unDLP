#!/usr/bin/perl

use Crypt::PK::RSA;
use HTTP::Daemon;
use HTTP::Status;
use JSON;
use List::MoreUtils qw(firstidx);
use Readonly;
use strict;
use warnings;

Readonly my $START_TRANSFER => 1;
Readonly my $IN_TRANSFER => 0;
Readonly my $END_TRANSFER => -1;

$| = 1;

my $server = HTTP::Daemon->new (
    LocalAddr => 'localhost',
    LocalPort => 443,
);

my $pk = Crypt::PK::RSA->new('private.pem');

my(@files, $content, $index);

while (my $client = $server->accept) {
    while (my $req = $client->get_request) {
        if ($req->method eq 'POST' and $req->uri->path eq "/") {
            $content = decode_json $pk->decrypt($req->content, 'v1.5');

            if ($content->{state} eq $START_TRANSFER) {
                push @files, {id => $content->{id}, file => $content->{file}, buffer => ''};
            } elsif ($content->{state} eq $IN_TRANSFER && ($index = firstidx { $_->{id} eq $content->{id} } @files)!= -1) {
                $files[$index]->{buffer} .= $content->{data};
            } elsif ($content->{state} eq $END_TRANSFER && ($index = firstidx { $_->{id} eq $content->{id} } @files)!= -1) {
                open FILE, ">$files[$index]->{file}" or die $!;
                print FILE $files[$index]->{buffer};
                close FILE;

                splice(@files, $index);
            }

            $client->send_response('ok');
        } elsif ($req->method eq 'GET' and $req->uri->path eq "/") {
            my($n, $data, $buffer);

            open FILE, "<", "public.pem" or die $!;

            $buffer = '';
            while (($n = read FILE, $data, 1024) != 0) {
                $buffer .= $data;
            }

            $client->send($buffer);
        } else {
            $client->send_error(RC_FORBIDDEN)
        }
    }

    $client->close;

    undef($client);
}
