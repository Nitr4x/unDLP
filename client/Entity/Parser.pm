package Parser;

use Getopt::Long;
use Moose;

has delay => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

has encryption => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

has file => (
    is  =>  'rw',
    isa =>  'Str'
);

has help => (
    is      =>  'rw',
    isa     =>  'Int',
    default =>  0
);

has key => (
    is      =>  'rw',
    isa     =>  'Str',
    default =>  ''
);

sub parse {
    my $self = shift;
    my @args = @_;

    GetOptions(
        'delay=i' => \$self->{delay},
        'e' => \$self->{encryption},
        'key=s' => \$self->{key},
        'help|h' => \$self->{help}
    );

    $self->{file} = $args[0];

    if (scalar @args < 1 || $self->help || !$self->file) {
        usage()
    }
}

sub usage {
    print "\nusage: unDLP.pl FILE [-e] [-delay DELAY] [-key KEY] [--help]\n\n";
    print "\t -e: Cipher the provided file.\n";
    print "\t -delay: Set the transfer speed.\n";
    print "\t -key: Set the public key used for the encryption. If not specified, the key will be retrieved from the server.\n";

    exit;
}

1;
