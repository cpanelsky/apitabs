#!/usr/bin/perl

foreach $arg (@ARGV) { $args = $args . " " . $arg; }
my $apiTabbed = @ARGV[0];

#print "$apiTabbed";

if ( $apiTabbed =~ "uapi" ) {
    &doUAPI();
}
else {
    if ( $apiTabbed =~ "cpapi2" ) {
        &doCPAPI2();
    }
    else {
        &doWHMAPI1();
    }
}

sub doUAPI {
    open( INPUTFILE, "</root/.cpanel/uapi.list" ) or die "$!";
    @lines = <INPUTFILE>;
    close(INPUTFILE);
    if ( $args =~ /.*cur=(.*)$/ ) {
        my $cur = $1;
        foreach my $line (@lines) {
            if ( $line =~ /^$cur.*/ ) {
                if ( $line =~ m/^$cur$/ ) {
                    my ( $moduleref, $funcref ) = split /-/, $cur;
                    print
"$moduleref $funcref --user=\$userName # https://documentation.cpanel.net/display/SDK/UAPI+Functions+-+$moduleref%3A%3A$funcref\n";
                }
                else {
                    if ( $cur != ~m/^\s$/ ) {
                        print "$line";
                    }
                }
            }
        }
    }
}

sub doCPAPI2 {
    open( INPUTFILE, "</root/.cpanel/cpapi2.list" ) or die "$!";
    @lines = <INPUTFILE>;
    close(INPUTFILE);
    if ( $args =~ /.*cur=(.*)$/ ) {
        my $cur = $1;
        foreach my $line (@lines) {
            if ( $line =~ /^$cur.*/ ) {
                if ( $line =~ m/^$cur$/ ) {
                    my ( $moduleref, $funcref ) = split /-/, $cur;
                    print
"$moduleref $funcref --user=\$userName # https://documentation.cpanel.net/display/SDK/cPanel+API+2+Functions+-+$moduleref%3A%3A$funcref\n";
                }
                else {
                    if ( $cur != ~m/^\s$/ ) {
                        print "$line";
                    }
                }
            }
        }
    }
}

sub doWHMAPI1 {

    open( INPUTFILE, "</root/.cpanel/whmapi1.list" ) or die "$!";
    @lines = <INPUTFILE>;
    close(INPUTFILE);

    if ( $args =~ /.*cur=(.*)$/ ) {
        my $cur = $1;
        foreach my $line (@lines) {
            if ( $line =~ /^$cur.*/ ) {
                if ( $line =~ m/^$cur$/ ) {
                    print
"$cur # https://documentation.cpanel.net/display/SDK/WHM+API+1+Functions+-+$line\n";
                }
                else {
                    if ( $cur != ~m/^\s$/ ) {
                        print "$line";
                    }
                }
            }
        }
    }

}
