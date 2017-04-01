#!/usr/bin/perl
use strict;

my $args;
my $docsURL;
my $apiTabbed = @ARGV[0];

foreach my $arg (@ARGV) { $args = $args . " " . $arg; }

my $apiFullList = "/root/.cpanel/fullset" . $apiTabbed . ".list";

if ( $apiTabbed =~ "uapi" ) {
    $docsURL = "  ## Documentation -> https://documentation.cpanel.net/display/SDK/UAPI+Functions+-+";
}
else {
    if ( $apiTabbed =~ "cpapi2" ) {
        $docsURL = "  ## Documentation -> https://documentation.cpanel.net/display/SDK/cPanel+API+2+Functions+-+";
    }
    else {
        $docsURL = "  ## Documentation -> https://documentation.cpanel.net/display/SDK/WHM+API+1+Functions+-+";
    }
}

sub doTabApi {
    if ( $args =~ /.*cur=(.*)$/ ) {
        my $cur = $1;
        open( FULLINPUTFILE, $apiFullList ) or die "$!";
        my @fullLines = <FULLINPUTFILE>;
        close(FULLINPUTFILE);
        foreach my $fullLine (@fullLines) {
            if ( $apiTabbed == "whmapi1" && $fullLine =~ /^$cur$/ ) {
                print $cur . $docsURL . $cur;
            }
            else {
                $cur =~ s/-/\ /;
                my $holder = $cur;
                $holder =~ s/ /%3A%3A/;
                if ( $fullLine =~ /^$cur\s/ ) {
                    chomp($fullLine);
                    print " --user=\$userName $fullLine" . $docsURL . $holder;
                }
            }
        }
    }
}

&doTabApi();
