package FusionInventory::Agent::Task::Inventory::HPUX::Slots;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isEnabled {
    return 0;
}

sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};
    my $logger    = $params{logger};

    foreach my $type (qw/ioa ba/) {
        foreach my $slot (_getSlots(
            command => "ioscan -kFC $type",
            logger  => $logger
        )) {
            $inventory->addEntry(
                section => 'SLOTS',
                entry   => $slot
            );
        }
    }
}

sub _getSlots {
    my $handle = getFileHandle(@_);
    return unless $handle;

    my @slots;
    while (my $line = <$handle>) {
        my @info = split(/:/, $line);
        push @slots, {
            DESIGNATION => $info[17],
        };
    }
    close $handle;

    return @slots;
}

1;
