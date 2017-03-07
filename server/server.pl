#!/usr/bin/perl

use Crypt::AES::CTR;

use HTTP::Daemon;
use HTTP::Status;
use JSON;
use List::MoreUtils qw(firstidx);
use Readonly;
use strict;
use warnings;

require Entity::Parser;

Readonly my $START_TRANSFER => 1;
Readonly my $IN_TRANSFER => 0;
Readonly my $END_TRANSFER => -1;

$| = 1;

my $server = HTTP::Daemon->new (
    LocalAddr => 'localhost',
    LocalPort => 443,
);

my $parser = Parser->new();

$parser->parse(@ARGV);

my(@files, $content, $index);
while (my $client = $server->accept) {
    while (my $req = $client->get_request) {
        if ($req->method eq 'POST' and $req->uri->path eq "/") {

            my $hash = isJSON($req->content) eq 1 ? $req->content :
                $parser->encryptionKey ? Crypt::AES::CTR::decrypt($req->content, $parser->encryptionKey, 256) : $req->content;

            if (isJSON($hash) eq 1) {
                $content = decode_json $hash;

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
            }
        } else {
            $client->send_error(RC_FORBIDDEN)
        }
    }

    $client->close;

    undef($client);
}

sub isJSON {
    my $str = shift;
    my @chars = split("", $str);

    return $chars[0] eq '{' and $chars[length($str) - 1] eq '}' ? 1 : 0;
}
