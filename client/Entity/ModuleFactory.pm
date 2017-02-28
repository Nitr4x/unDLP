#!/usr/bin/perl

package ModuleFactory;

use Moose;

require Entity::Parser;
require Module::HTTPSExfiltration;

sub create {
    my($self, $parser) = @_;

    my @factory = (
        { name => 'HTTPS', className => 'HTTPSExfiltration' }
    );

    for my $method (@factory) {
        if ($method->{name} eq $parser->method) {
            return $method->{className}->new(dest => $parser->dest, delay => $parser->delay, size => $parser->size);
        }
    }
}

1;
