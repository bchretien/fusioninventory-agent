package FusionInventory::Agent::Task::Inventory::OS::BSD;

use strict;
use warnings;

use English qw(-no_match_vars);

our $runAfter = ["FusionInventory::Agent::Task::Inventory::OS::Generic"];

sub isInventoryEnabled {
    return $OSNAME =~ /freebsd|openbsd|netbsd|gnukfreebsd|gnuknetbsd|dragonfly/;
}

sub doInventory {
    my $params = shift;
    my $inventory = $params->{inventory};

    my $OSComment;
    my $OSVersion;
    my $OSLevel;
    my $OSArchi;
    my $OSName;

    # Operating system informations
    chomp($OSVersion=`uname -r`);
    chomp($OSArchi=`uname -p`);
    chomp($OSName=`uname -s`);

    # Retrieve the origin of the kernel configuration file
    my ($date, $origin, $kernconf);
    for (`sysctl -n kern.version`) {
        $date = $1 if /^\S.*\#\d+:\s*(.*)/;
	if (/^\s+(.+):(.+)$/) {
            ($origin,$kernconf) = ($1,$2);
	    $kernconf =~ s/\/.*\///; # remove the path
            $OSComment = $kernconf." (".$date.")\n".$origin;
            # if there is a problem use uname -v
            chomp($OSComment=`uname -v`) unless $OSComment;
        }
    }

    if (can_run("lsb_release")) {
        foreach (`lsb_release -d`) {
            $OSNAME = $1 if /Description:\s+(.+)/;
        }
    }

    $inventory->setHardware({
        OSNAME => $OSNAME,
        OSCOMMENTS => $OSComment,
        OSVERSION => $OSVersion,
    });

    $inventory->setOperatingSystem({
        NAME                 => $OSName,
        VERSION              => $OSVersion,
        KERNEL_VERSION       => $OSVersion,
        FULL_NAME            => $OSNAME
    });
}
1;