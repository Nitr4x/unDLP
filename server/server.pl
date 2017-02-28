#!/usr/bin/perl

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

my (@files, $content);

while (my $client = $server->accept) {
    while (my $req = $client->get_request) {
        if ($req->method eq 'POST' and $req->uri->path eq "/") {
            $content = decode_json $req->content;

            if ($content->{state} eq $START_TRANSFER) {
                push @files, {id => $content->{id}, file => $content->{file}, buffer => ''};
            } elsif ($content->{state} eq $IN_TRANSFER) {
                my $index = firstidx { $_->{id} eq $content->{id} } @files;
                $files[$index]->{buffer} .= $content->{data};
            } elsif ($content->{state} eq $END_TRANSFER) {
                my $index = firstidx { $_->{id} eq $content->{id} } @files;

                open FILE, ">$files[$index]->{file}" or die $!;
                print FILE $files[$index]->{buffer};
                close FILE;

                splice(@files, $index);
            }

            $client->send_response('ok');
        } else {
            $client->send_error(RC_FORBIDDEN)
        }
    }

    $client->close;

    undef($client);
}
