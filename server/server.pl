#!/usr/bin/perl

use IO::Socket::INET;
use strict;
use warnings;

$| = 1;

my $socket = new IO::Socket::INET (
    LocalHost => 'localhost',
    LocalPort => '443',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
);

die "cannot create socket $!\n" unless $socket;

while (1) {
    my $data = "";
    my $client_socket = $socket->accept();

    $client_socket->recv($data, 1024);

    print "received data: $data\n";

    $client_socket->send("ok");

    shutdown($client_socket, 1);
}

$socket->close();
