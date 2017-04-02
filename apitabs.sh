#!/usr/bin/bash
#setup API tab completion - https://forums.cpanel.net/threads/tab-completion-for-the-api.596967/

touch /etc/bash_completion
cp -iav /etc/bash_completion{,.cpanel_backup.$(date +'%s')}
echo > /etc/bash_completion
rm -fv /root/.cpanel/*api*.list
rm -fv /etc/bash_completion.d/cpanel*api*.bash
touch /etc/bash_completion.d/cpanelcpapi2.bash
touch /etc/bash_completion.d/cpanelwhmapi1.bash
touch /etc/bash_completion.d/cpaneluapi.bash
wget --verbose -O /root/.cpanel/fullsetcpapi2.list    https://raw.githubusercontent.com/cpanelsky/apitabs/master/fullsetcpapi2.list
wget --verbose -O /root/.cpanel/fullsetuapi.list      https://raw.githubusercontent.com/cpanelsky/apitabs/master/fullsetuapi.list
wget --verbose -O /root/.cpanel/fullsetwhmapi1.list   https://raw.githubusercontent.com/cpanelsky/apitabs/master/fullsetwhmapi1.list
wget --verbose -O /usr/bin/apitabhandler.pl           https://raw.githubusercontent.com/cpanelsky/apitabs/master/apitabhandler.pl
chmod +x /usr/bin/apitabhandler.pl
echo -e ". /etc/bash_completion.d/cpanelcpapi2.bash"   >>  /etc/bash_completion
echo -e ". /etc/bash_completion.d/cpanelwhmapi1.bash"  >>  /etc/bash_completion
echo -e ". /etc/bash_completion.d/cpaneluapi.bash"     >>  /etc/bash_completion


if ! grep -q bash_completion  /root/.bashrc  
  then 
  echo -e '  if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
      . /etc/bash_completion
  fi' >> /root/.bashrc
fi
  

echo -e '_whmapi1()
{
  ourAPI="whmapi1";
  local cur=${COMP_WORDS[COMP_CWORD]}
  if grep -q "^$cur$" /root/.cpanel/whmapi1.list
    then
       COMPREPLY=$(/usr/bin/apitabhandler.pl $ourAPI cur=$cur)
     else 
      COMPREPLY=( $(compgen -W "$(cat /root/.cpanel/whmapi1.list)" -- $cur))
  fi
}
complete -F _whmapi1 whmapi1' > /etc/bash_completion.d/cpanelwhmapi1.bash

echo -e '_cpapi2()
{

  COMPREPLY=()
  ourAPI="cpapi2";
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

     if grep -q "^$cur$" /root/.cpanel/cpapi2.list
      then
         COMPREPLY=$(/usr/bin/apitabhandler.pl $ourAPI cur=$cur)
       else 
        COMPREPLY=( $(compgen -W "$(cat /root/.cpanel/cpapi2.list)" -- $cur))
     fi

     if [[ ${prev} == "user"* ]]
      then
        COMPREPLY=( $(compgen -W "$(awk -F': ' '{print $2}' /etc/trueuserdomains )" -- $cur ))
     fi

     if [[ ${prev} == "domain"* ]]
      then
       userArgName=$( grep -oP "(?<=user.)[0-9a-zA-Z].*(?=\s)" <(echo $COMP_LINE ) )
       COMPREPLY=( $(compgen -W "$(awk -F':' '{if (/: '$userArgName'==/) print $1}' /etc/userdatadomains )" -- $cur ))
     fi


}
complete -F _cpapi2 cpapi2' > /etc/bash_completion.d/cpanelcpapi2.bash


echo -e '_uapi()
{

  COMPREPLY=()
  ourAPI="uapi";
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

     if grep -q "^$cur$" /root/.cpanel/uapi.list
      then
         COMPREPLY=$(/usr/bin/apitabhandler.pl $ourAPI cur=$cur)
       else 
        COMPREPLY=( $(compgen -W "$(cat /root/.cpanel/uapi.list)" -- $cur))
     fi

     if [[ ${prev} == "user"* ]]
      then
        COMPREPLY=( $(compgen -W "$(awk -F': ' '{print $2}' /etc/trueuserdomains )" -- $cur ))
     fi

     if [[ ${prev} == "domain"* ]]
      then
       userArgName=$( grep -oP "(?<=user.)[0-9a-zA-Z].*(?=\s)" <(echo $COMP_LINE ) )
       COMPREPLY=( $(compgen -W "$(awk -F':' '{if (/: '$userArgName'==/) print $1}' /etc/userdatadomains )" -- $cur ))
     fi


}
complete -F _uapi uapi' > /etc/bash_completion.d/cpaneluapi.bash

cpapiVar=$(/usr/local/cpanel/3rdparty/bin/perl -MCpanel::Template::Plugin::API_Shell -e 'our @apis = (\&Cpanel::Template::Plugin::API_Shell::api2_functions, \&Cpanel::Template::Plugin::API_Shell::whm1_functions, \&Cpanel::Template::Plugin::API_Shell::uapi_functions);  my @elemV =  (0) ; foreach (@elemV) { apiC($_) ;} sub apiC {if($_ == 1){$currentApi="whm1 "}else{if($_ == 2){$currentApi="UAPI "} else {$currentApi="cpapi2 "}}; foreach ( @apis[@_]->() ) { my $snipString = "@$_"; $snipString =~ (s/ /\n/g);  $snipString =~ (s/::/\-/g); print "$snipString";}}' )
echo $cpapiVar > /root/.cpanel/cpapi2.list
sed -i 's/ /\n/g' /root/.cpanel/cpapi2.list

whmapiVar=$(/usr/local/cpanel/3rdparty/bin/perl -MCpanel::Template::Plugin::API_Shell -e 'our @apis = (\&Cpanel::Template::Plugin::API_Shell::api2_functions, \&Cpanel::Template::Plugin::API_Shell::whm1_functions, \&Cpanel::Template::Plugin::API_Shell::uapi_functions);  my @elemV =  (1) ; foreach (@elemV) { apiC($_) ;} sub apiC {if($_ == 1){$currentApi="whm1 "}else{if($_ == 2){$currentApi="UAPI "} else {$currentApi="cpapi2 "}}; foreach ( @apis[@_]->() ) { my $snipString = "@$_"; $snipString =~ (s/ /\n/g);  $snipString =~ (s/::/\-/g); print "$snipString\n";}}') 
echo $whmapiVar > /root/.cpanel/whmapi1.list
sed -i 's/ /\n/g' /root/.cpanel/whmapi1.list

uapiVar=$(/usr/local/cpanel/3rdparty/bin/perl -MCpanel::Template::Plugin::API_Shell -e 'our @apis = (\&Cpanel::Template::Plugin::API_Shell::api2_functions, \&Cpanel::Template::Plugin::API_Shell::whm1_functions, \&Cpanel::Template::Plugin::API_Shell::uapi_functions);  my @elemV =  (2) ; foreach (@elemV) { apiC($_) ;} sub apiC {if($_ == 1){$currentApi="whm1 "}else{if($_ == 2){$currentApi="UAPI "} else {$currentApi="cpapi2 "}}; foreach ( @apis[@_]->() ) { my $snipString = "@$_"; $snipString =~ (s/ /\n/g);  $snipString =~ (s/::/\-/g); print "$snipString\n";}}') 
echo $uapiVar > /root/.cpanel/uapi.list
sed -i 's/ /\n/g' /root/.cpanel/uapi.list

source ~/.bashrc
