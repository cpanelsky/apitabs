#!/usr/bin/perl

foreach $arg (@ARGV) { $args = $args . " " . $arg; }
my $apiTabbed = @ARGV[0];


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
                       open( FULLINPUTFILE, "</root/.cpanel/fullsetuapi.list" ) or die "$!";
                      @fullLines = <FULLINPUTFILE>;
                      close(FULLINPUTFILE);
                      foreach my $fullLine (@fullLines) {
                        if ( $fullLine =~ m/^$cur$/ )  {
                            print " --user=\$userName $cur # cPanel Documentation #  https://documentation.cpanel.net/display/SDK/UAPI+Functions+-+$cur";
                        }  else {
                            $cur =~ s/-/ /;
                          if ( $fullLine =~ /^$cur.*/ ) {
                          chomp($fullLine);
			                    $cur =~ s/ /%3A%3A/;
                          print " --user=\$userName $fullLine  # cPanel Documentation #  https://documentation.cpanel.net/display/SDK/UAPI+Functions+-+$cur";
                                        }
                          }
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
		       open( FULLINPUTFILE, "</root/.cpanel/fullsetcpapi2.list" ) or die "$!";
                      @fullLines = <FULLINPUTFILE>;
                      close(FULLINPUTFILE);
                      foreach my $fullLine (@fullLines) {
                        if ( $fullLine =~ m/^$cur$/ )  {
                            print " --user=\$userName $cur # cPanel Documentation #  https://documentation.cpanel.net/display/SDK/cPanel+API+2+Functions+-+$cur";
                        }  else {
			                     $cur =~ s/-/ /;
                          if ( $fullLine =~ /^$cur.*/ ) {
                          chomp($fullLine);
                          $cur =~ s/ /%3A%3A/;
                          print " --user=\$userName $fullLine  # cPanel Documentation #  https://documentation.cpanel.net/display/SDK/cPanel+API+2+Functions+-+$cur";
                                    }
			                       }
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
            if ( $line =~ /^$cur$/ ) {
		      open( FULLINPUTFILE, "</root/.cpanel/fullsetwhmapi1.list" ) or die "$!";
		      @fullLines = <FULLINPUTFILE>;
		      close(FULLINPUTFILE);
		      foreach my $fullLine (@fullLines) {
			       if ( $fullLine =~ m/^$cur$/ )  {
	                    print "$cur # cPanel Documentation #  https://documentation.cpanel.net/display/SDK/WHM+API+1+Functions+-+$cur";
			            }  else {
			               if ( $fullLine =~ /^$cur.*/ ) {
			                chomp($fullLine);
                    	print "$fullLine  # cPanel Documentation #  https://documentation.cpanel.net/display/SDK/WHM+API+1+Functions+-+$cur";
					                 }
				              }
			           }
            }
        }
    }
}
