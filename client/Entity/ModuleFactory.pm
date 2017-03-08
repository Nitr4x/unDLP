#!/usr/bin/perl

# ------------------------------------------------------------------------- #
#                                                                           #
# The ModuleFactory package dynamically instantiate the exfiltration method #
# specified in argument.                                                    #
#                                                                           #
# ------------------------------------------------------------------------- #

package ModuleFactory;

use Moose;

require Entity::Parser;
require Module::HTTPSExfiltration;

#
# Instantiate and return the right exfiltration method.
#
sub create {
    my($self, $parser) = @_;

    my @factory = (
        { name => 'HTTPS', className => 'HTTPSExfiltration' }
    );

    for my $method (@factory) {
        if ($method->{name} eq $parser->method) {
            return $method->{className}->new(dest => $parser->dest, delay => $parser->delay, size => $parser->size, encryptionKey => $parser->encryptionKey);
        }
    }
}

1;
