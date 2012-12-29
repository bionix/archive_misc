#!/bin/sh
#set -e
#
# This script downloads my sources.lists for debian wheezy systems and installs
# the repo keys.
# Need to run under root rights and need the package wget with internet.
#
echo " -- START --"

if [ ! -d /etc/apt/sources.list.d ] ; then
    mkdir -p /etc/apt/sources.list.d ;
    chown root:root /etc/apt/sources.list.d ;
fi

cd /etc/apt/sources.list.d ;

echo "Download the apt sourceslist files from Github"
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/grml.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/varnish_repo.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/deb_multimedia_org.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/dotdeb.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/i3_wm_autobuild.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/jenkins_ci.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/oracle_java7_installer.list" ;
wget -q --no-check-certificate "https://raw.github.com/bionix/misc/master/etc/apt/sources.list.d/virtualbox.list" ;

echo "Installing google chrome debian package with repo/key infos - NOT the software!"
wget --no-check-certificate -q -O- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /opt/google-chrome-stable.deb && dpkg -i /opt/google-chrome-stable.deb

echo "Installing puppetlabs deb package with repo/key infos - NOT the software!"
wget -q -O- http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb > /opt/puppetlabs-release.deb && dpkg -i /opt/puppetlabs-release.deb

echo "Install dotdeb key"
wget -q -O- http://www.dotdeb.org/dotdeb.gpg | apt-key add -
echo "Install jenkins key"
wget -q -O- http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo "Install webupd8team repo key"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
echo "Install varnish repo key"
wget -q -O- http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -
echo "Install virtualbox repo"
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
echo "Update apt cache"
apt-get update -qq ;
echo "Install the keyrings"
apt-get -y --allow-unauthenticated install deb-multimedia-keyring grml-debian-keyring i3-autobuild-keyring

echo "-- END --"

exit ;
# EOF
