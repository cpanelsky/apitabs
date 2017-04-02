#!/usr/bin/perl
use strict;

my $args;
my $docsURL;
my $apiTabbed = @ARGV[0];
my $cur;

foreach my $arg (@ARGV) { $args = $args . " " . $arg; }

my $apiFullList = "/root/.cpanel/fullset" . $apiTabbed . ".list";
my $apiFuncList = "/root/.cpanel/" . $apiTabbed . ".list";
my $docsBase    = "  ## Documentation -> https://documentation.cpanel.net/display/SDK/";


if ( $apiTabbed =~ "uapi" ) {
    $docsURL = $docsBase . "UAPI+Functions+-+";
  } 
    else {
        if ( $apiTabbed =~ "cpapi2" ) {
        $docsURL = $docsBase . "cPanel+API+2+Functions+-+";
    }
    else {
        $docsURL = $docsBase . "WHM+API+1+Functions+-+";
    }
}


if ( $args =~ /.*cur=(.*)$/ ) {
     $cur = $1;
     &doTabApi();
}

sub doTabApi {
       open(FULLINPUTFILE, $apiFullList) or open(FULLINPUTFILE, $apiFuncList) or die "No $apiFullList or $apiFuncList\n";
       my @fullLines = <FULLINPUTFILE>;
       close(FULLINPUTFILE);
       foreach my $fullLine (@fullLines) {
           if ( $apiTabbed =~ /whmapi1/ && $fullLine =~ /^$cur$/ ) {
                print $cur . $docsURL . $cur;
            }
            else {
                $cur =~ s/-/\ /;
                my $holder = $cur;
                $holder =~ s/ /%3A%3A/;
                if ( $fullLine =~ /^$cur\s/ ) {
                    chomp($fullLine);
                    print "--user \$userName $fullLine" . $docsURL . $holder;
              }
         }
    }
}
