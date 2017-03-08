#!/usr/bin/perl

# ----------------------------------------------- #
#                                                 #
# The Parser package parse the server arguments.  #
#                                                 #
# ----------------------------------------------- #

package Parser;

use Getopt::Long;
use Moose;

has help => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

has encryptionKey => (
    is      =>  'rw',
    isa     =>  'Str',
    default =>  ''
);

#
# Parse the command line arguments.
#
sub parse {
    my $self = shift;
    my @args = @_;

    GetOptions(
        'e=s'       =>  \$self->{encryptionKey},
        'help|h'    =>  \$self->{help}
    );

    if ($self->help) {
        usage()
    }
}

#
# Display the server usage.
#
sub usage {
    print "\nusage: server.pl [--e PASSWORD] [--help|h]\n\n";
    print "\t --e: Set the encryption password.\n";
    print "\t --help|h: Display the helper.\n";

    exit;
}

1;
