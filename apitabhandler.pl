#!/usr/bin/perl

foreach $arg (@ARGV) { $args = $args . " " . $arg; }
my $apiTabbed = @ARGV[0];


if ( $apiTabbed =~ "uapi" ) {
     $docsURL="  ## Documentation -> https://documentation.cpanel.net/display/SDK/UAPI+Functions+-+";
} else {
    if ( $apiTabbed =~ "cpapi2" ) {
        $docsURL="  ## Documentation -> https://documentation.cpanel.net/display/SDK/cPanel+API+2+Functions+-+";
    } else {
        $docsURL="  ## Documentation -> https://documentation.cpanel.net/display/SDK/WHM+API+1+Functions+-+";
    }
}

$apiFuncList = "/root/.cpanel/" . $apiTabbed . ".list";
$apiFullList = "/root/.cpanel/fullset" . $apiTabbed . ".list";

sub doTabApi {
    
    open( INPUTFILE, $apiFuncList ) or die "$!";
    @lines = <INPUTFILE>;
    close(INPUTFILE);
    if ( $args =~ /.*cur=(.*)$/ ) {
        my $cur = $1;
        foreach my $line (@lines) {
            if ( $line =~ /^$cur.*/ ) {
                if ( $line =~ m/^$cur$/ ) {
                       open( FULLINPUTFILE, $apiFullList ) or die "$!";
                      @fullLines = <FULLINPUTFILE>;
                      close(FULLINPUTFILE);
                      foreach my $fullLine (@fullLines) {
                        if ( $fullLine =~ m/^$cur$/ )  {
			   if ( $apiTabbed == "whmapi1" ) {
                            print "$cur" . $docsURL . "$cur";
			  }
                        }  else {
                           $cur =~ s/-/ /;
                           if ( $fullLine =~ /^$cur.*/ ) {
                           chomp($fullLine);
			   $cur =~ s/ /%3A%3A/;
                           print " --user=\$userName $fullLine" . $docsURL . "$cur";
                              }
                          }
                     }
                }
            }
        }
    }
}

&doTabApi();
