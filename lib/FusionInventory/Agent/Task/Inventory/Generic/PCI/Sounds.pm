package FusionInventory::Agent::Task::Inventory::Generic::PCI::Sounds;

use strict;
use warnings;

use FusionInventory::Agent::Tools;
use FusionInventory::Agent::Tools::Generic;

sub isEnabled {
    return 0;
}

sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};
    my $logger    = $params{logger};

    foreach my $sound (_getSounds(logger => $logger)) {
        $inventory->addEntry(
            section => 'SOUNDS',
            entry   => $sound
        );
    }
}

sub _getSounds {
    my @sounds;

    foreach my $device (getPCIDevices(@_)) {
        next unless $device->{NAME} =~ /audio/i;
        push @sounds, {
            NAME         => $device->{NAME},
            MANUFACTURER => $device->{MANUFACTURER},
            DESCRIPTION  => $device->{REV} && "rev $device->{REV}",
        };
    }

    return @sounds;
}

1;
